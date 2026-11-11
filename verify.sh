#!/usr/bin/env bash
# Проверяет VLAN и переключение bond0, затем восстанавливает отключённый линк.
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

echo '=== VLAN 1 и VLAN 2: связность и MAC соседей ==='
for vlan in 1 2; do
  case "$vlan" in
    1) client_mac=02:00:00:36:21:02; server_mac=02:00:00:36:22:02; wrong_mac=02:00:00:36:32:02 ;;
    2) client_mac=02:00:00:36:31:02; server_mac=02:00:00:36:32:02; wrong_mac=02:00:00:36:22:02 ;;
  esac
  echo "VLAN $vlan"
  vagrant ssh "testClient$vlan" -c "
    set -e
    ip -d link show vlan$vlan
    ping -I vlan$vlan -c 3 -W 2 10.10.10.1
    ip neigh show 10.10.10.1 dev vlan$vlan | tee /dev/stderr | grep -F 'lladdr $server_mac' >/dev/null
  "
  vagrant ssh "testServer$vlan" -c "
    set -e
    ping -I vlan$vlan -c 3 -W 2 10.10.10.254
    ip neigh show 10.10.10.254 dev vlan$vlan | tee /dev/stderr | grep -F 'lladdr $client_mac' >/dev/null
  "
  # Подставляем MAC сервера другого VLAN и проверяем отсутствие ответа.
  vagrant ssh "testClient$vlan" -c "
    set -e
    sudo ip neigh replace 10.10.10.1 lladdr $wrong_mac nud permanent dev vlan$vlan
    trap 'sudo ip neigh del 10.10.10.1 dev vlan$vlan' EXIT
    if ping -I vlan$vlan -c 2 -W 1 10.10.10.1; then
      echo 'Ошибка: сервер другого VLAN ответил' >&2
      exit 1
    else
      rc=\$?
      test \"\$rc\" -eq 1
      echo 'Изоляция VLAN подтверждена'
    fi
  "
done

echo '=== Uplink Office1 ==='
vagrant ssh centralRouter -c 'ping -I office-uplink -c 3 -W 2 192.168.255.10'

echo '=== bond0 до отказа ==='
vagrant ssh inetRouter -c 'cat /proc/net/bonding/bond0 && ping -I bond0 -c 3 -W 2 192.168.255.2'
bond_info=$(vagrant ssh centralRouter -c 'cat /proc/net/bonding/bond0' | tr -d '\r')
echo "$bond_info"
if grep -q 'IEEE 802.3ad' <<< "$bond_info"; then
  grep -Eq '^Number of ports:[[:space:]]*2$' <<< "$bond_info"
  partner=$(awk '/^Partner Mac Address:/ {print $4; exit}' <<< "$bond_info")
  test -n "$partner"
  test "$partner" != 00:00:00:00:00:00
fi

# При active-backup отключаем текущий активный порт; при LACP — первый линк.
active=$(vagrant ssh centralRouter -c "awk '/^Currently Active Slave:/ { print \$4 }' /proc/net/bonding/bond0" | tr -d '\r')
case "$active" in
  lab-b) adapter=3; member=lab-b ;;
  lab-a|'') adapter=2; member=lab-a ;;
  *) echo "Неизвестный активный порт: $active" >&2; exit 1 ;;
esac
vm_id=$(tr -d '\r\n' < .vagrant/machines/centralRouter/virtualbox/id)
restore_link() {
  VBoxManage controlvm "$vm_id" "setlinkstate$adapter" on
}
trap restore_link EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

echo "=== Отключаем $member на centralRouter ==="
VBoxManage controlvm "$vm_id" "setlinkstate$adapter" off
vagrant ssh inetRouter -c 'ping -I bond0 -c 24 -i 0.3 -W 2 192.168.255.2'
vagrant ssh centralRouter -c "
  set -e
  cat /proc/net/bonding/bond0
  test \"\$(cat /sys/class/net/$member/carrier)\" = 0
  ping -I bond0 -c 3 -W 2 192.168.255.1
"

echo '=== Восстанавливаем линк ==='
restore_link
trap - EXIT INT TERM
vagrant ssh inetRouter -c 'ping -I bond0 -c 3 -W 2 192.168.255.2'

# v1 — 2026-11-10
# Проверки VLAN, Office1 и отказоустойчивости bond0.
