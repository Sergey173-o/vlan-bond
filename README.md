Строим бонды и вланы

## Схема

| Сегмент | Участники и адреса | Реализация |
|---|---|---|
| testLAN, VLAN 1 | testClient1 `10.10.10.254/24` ↔ testServer1 `10.10.10.1/24` | Тег 802.1Q ID 1 |
| testLAN, VLAN 2 | testClient2 `10.10.10.254/24` ↔ testServer2 `10.10.10.1/24` | Тег 802.1Q ID 2 |
| bond0 | inetRouter `192.168.255.1/30` ↔ centralRouter `192.168.255.2/30` | `lab-a` и `lab-b` на общей сети `vlanlab-router-a` |
| Uplink Office1 | centralRouter `192.168.255.9/30` ↔ office1Router `192.168.255.10/30` | `vlanlab-office1-central` |

Все четыре тестовые ВМ используют одну сеть VirtualBox `vlanlab-testLAN`. VLAN разделяются тегами внутри неё. Office1Router проверяется по uplink, маршрутизация между тестовыми VLAN в задании не используется.

##  Запуск

```bash
root@nfsc:~/vlan-bond-hw# free -h
VBoxManage list runningvms
unset BOND_MODE
vagrant validate && vagrant up --provider=virtualbox
               total        used        free      shared  buff/cache   available
Mem:            11Gi       974Mi        10Gi       1.3Mi       611Mi        10Gi
Swap:             0B          0B          0B
Vagrantfile validated successfully.
Bringing machine 'inetRouter' up with 'virtualbox' provider...
Bringing machine 'centralRouter' up with 'virtualbox' provider...
Bringing machine 'office1Router' up with 'virtualbox' provider...
Bringing machine 'testClient1' up with 'virtualbox' provider...
Bringing machine 'testServer1' up with 'virtualbox' provider...
Bringing machine 'testClient2' up with 'virtualbox' provider...
Bringing machine 'testServer2' up with 'virtualbox' provider...
==> inetRouter: Importing base box 'generic/ubuntu2204'...
==> inetRouter: Matching MAC address for NAT networking...
==> inetRouter: Checking if box 'generic/ubuntu2204' version '4.3.12' is up to date...
==> inetRouter: Setting the name of the VM: vlan-bond-inetRouter
==> inetRouter: Clearing any previously set network interfaces...
==> inetRouter: Preparing network interfaces based on configuration...
    inetRouter: Adapter 1: nat
==> inetRouter: Forwarding ports...
    inetRouter: 22 (guest) => 2222 (host) (adapter 1)
==> inetRouter: Running 'pre-boot' VM customizations...
==> inetRouter: Booting VM...
==> inetRouter: Waiting for machine to boot. This may take a few minutes...
    inetRouter: SSH address: 127.0.0.1:2222
    inetRouter: SSH username: vagrant
    inetRouter: SSH auth method: private key
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Remote connection disconnect. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter:
    inetRouter: Vagrant insecure key detected. Vagrant will automatically replace
    inetRouter: this with a newly generated keypair for better security.
    inetRouter:
    inetRouter: Inserting generated public key within guest...
    inetRouter: Removing insecure key from the guest if it's present...
    inetRouter: Key inserted! Disconnecting and reconnecting using new SSH key...
==> inetRouter: Machine booted and ready!
==> inetRouter: Checking for guest additions in VM...
    inetRouter: The guest additions on this VM do not match the installed version of
    inetRouter: VirtualBox! In most cases this is fine, but in rare cases it can
    inetRouter: prevent things such as shared folders from working properly. If you see
    inetRouter: shared folder errors, please make sure the guest additions within the
    inetRouter: virtual machine match the version of VirtualBox you have installed on
    inetRouter: your host and reload your VM.
    inetRouter:
    inetRouter: Guest Additions Version: 6.1.38
    inetRouter: VirtualBox Version: 7.0
==> inetRouter: Setting hostname...
==> inetRouter: Running provisioner: ansible...
    inetRouter: Running ansible-playbook...

PLAY [Настроить лабораторные интерфейсы через Netplan] *************************

TASK [Записать конфигурацию лабораторных интерфейсов] **************************
changed: [inetRouter]

RUNNING HANDLER [Применить настройки Netplan] **********************************
changed: [inetRouter]

PLAY RECAP *********************************************************************
inetRouter                 : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

==> centralRouter: Importing base box 'generic/ubuntu2204'...
==> centralRouter: Matching MAC address for NAT networking...
==> centralRouter: Checking if box 'generic/ubuntu2204' version '4.3.12' is up to date...
==> centralRouter: Setting the name of the VM: vlan-bond-centralRouter
==> centralRouter: Fixed port collision for 22 => 2222. Now on port 2200.
==> centralRouter: Clearing any previously set network interfaces...
==> centralRouter: Preparing network interfaces based on configuration...
    centralRouter: Adapter 1: nat
==> centralRouter: Forwarding ports...
    centralRouter: 22 (guest) => 2200 (host) (adapter 1)
==> centralRouter: Running 'pre-boot' VM customizations...
==> centralRouter: Booting VM...
==> centralRouter: Waiting for machine to boot. This may take a few minutes...
    centralRouter: SSH address: 127.0.0.1:2200
    centralRouter: SSH username: vagrant
    centralRouter: SSH auth method: private key
    centralRouter: Warning: Connection reset. Retrying...
    centralRouter: Warning: Connection reset. Retrying...
    centralRouter: Warning: Connection reset. Retrying...
    centralRouter: Warning: Connection reset. Retrying...
    centralRouter: Warning: Connection reset. Retrying...
    centralRouter: Warning: Remote connection disconnect. Retrying...
    centralRouter: Warning: Connection reset. Retrying...
    centralRouter: Warning: Connection reset. Retrying...
    centralRouter: Warning: Connection reset. Retrying...
    centralRouter: Warning: Connection reset. Retrying...
    centralRouter: Warning: Connection reset. Retrying...
    centralRouter: Warning: Remote connection disconnect. Retrying...
    centralRouter: Warning: Connection reset. Retrying...
    centralRouter: Warning: Connection reset. Retrying...
    centralRouter: Warning: Connection reset. Retrying...
    centralRouter: Warning: Connection reset. Retrying...
    centralRouter:
    centralRouter: Vagrant insecure key detected. Vagrant will automatically replace
    centralRouter: this with a newly generated keypair for better security.
    centralRouter:
    centralRouter: Inserting generated public key within guest...
    centralRouter: Removing insecure key from the guest if it's present...
    centralRouter: Key inserted! Disconnecting and reconnecting using new SSH key...
==> centralRouter: Machine booted and ready!
==> centralRouter: Checking for guest additions in VM...
    centralRouter: The guest additions on this VM do not match the installed version of
    centralRouter: VirtualBox! In most cases this is fine, but in rare cases it can
    centralRouter: prevent things such as shared folders from working properly. If you see
    centralRouter: shared folder errors, please make sure the guest additions within the
    centralRouter: virtual machine match the version of VirtualBox you have installed on
    centralRouter: your host and reload your VM.
    centralRouter:
    centralRouter: Guest Additions Version: 6.1.38
    centralRouter: VirtualBox Version: 7.0
==> centralRouter: Setting hostname...
==> centralRouter: Running provisioner: ansible...
    centralRouter: Running ansible-playbook...

PLAY [Настроить лабораторные интерфейсы через Netplan] *************************

TASK [Записать конфигурацию лабораторных интерфейсов] **************************
changed: [centralRouter]

RUNNING HANDLER [Применить настройки Netplan] **********************************
changed: [centralRouter]

PLAY RECAP *********************************************************************
centralRouter              : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

==> office1Router: Importing base box 'generic/ubuntu2204'...
Progress: 10%(
  set -euo pipefail
  cd /opt/docker/openclaw
  bot=bot2
  service="openclaw-$bot"
  export COMPOSE_REMOVE_ORPHANS=false
  compose=(docker compose -p openclaw -f "docker-compose-$bot.yml")

  test "$(docker inspect -f '{{.Config.Image}}' "$service")" = 'ghcr.io/openclaw/openclaw:2026.11.2'
  test "$(docker inspect -f '{{.State.Health.Status}}' "$service")" = healthy

  "${compose[@]}" stop "$service"
  trap '"${compose[@]}" start "$service"' EXIT
  "${compose[@]}" run --rm --no-deps --pull never -T \
    --name "$service-memory" --entrypoint /bin/sh "$service" -ec '
      openclaw memory status --deep
      openclaw memory index
      openclaw memory status
    '
  "${compose[@]}" start "$service"
  trap - EXIT
  docker ps --filter "name=$service" --format '{{.Names}} {{.Status}}'
==> office1Router: Matching MAC address for NAT networking...
==> office1Router: Checking if box 'generic/ubuntu2204' version '4.3.12' is up to date...
==> office1Router: Setting the name of the VM: vlan-bond-office1Router
==> office1Router: Fixed port collision for 22 => 2222. Now on port 2201.
==> office1Router: Clearing any previously set network interfaces...
==> office1Router: Preparing network interfaces based on configuration...
    office1Router: Adapter 1: nat
==> office1Router: Forwarding ports...
    office1Router: 22 (guest) => 2201 (host) (adapter 1)
==> office1Router: Running 'pre-boot' VM customizations...
==> office1Router: Booting VM...
==> office1Router: Waiting for machine to boot. This may take a few minutes...
    office1Router: SSH address: 127.0.0.1:2201
    office1Router: SSH username: vagrant
    office1Router: SSH auth method: private key
    office1Router: Warning: Connection reset. Retrying...
    office1Router: Warning: Connection reset. Retrying...
    office1Router: Warning: Connection reset. Retrying...
    office1Router: Warning: Connection reset. Retrying...
    office1Router: Warning: Connection reset. Retrying...
    office1Router: Warning: Connection reset. Retrying...
    office1Router: Warning: Connection reset. Retrying...
    office1Router: Warning: Connection reset. Retrying...
    office1Router: Warning: Connection reset. Retrying...
    office1Router: Warning: Connection reset. Retrying...
    office1Router: Warning: Connection reset. Retrying...
    office1Router: Warning: Connection reset. Retrying...
    office1Router: Warning: Connection reset. Retrying...
    office1Router: Warning: Connection reset. Retrying...
    office1Router:
    office1Router: Vagrant insecure key detected. Vagrant will automatically replace
    office1Router: this with a newly generated keypair for better security.
    office1Router:
    office1Router: Inserting generated public key within guest...
    office1Router: Removing insecure key from the guest if it's present...
    office1Router: Key inserted! Disconnecting and reconnecting using new SSH key...
==> office1Router: Machine booted and ready!
==> office1Router: Checking for guest additions in VM...
    office1Router: The guest additions on this VM do not match the installed version of
    office1Router: VirtualBox! In most cases this is fine, but in rare cases it can
    office1Router: prevent things such as shared folders from working properly. If you see
    office1Router: shared folder errors, please make sure the guest additions within the
    office1Router: virtual machine match the version of VirtualBox you have installed on
    office1Router: your host and reload your VM.
    office1Router:
    office1Router: Guest Additions Version: 6.1.38
    office1Router: VirtualBox Version: 7.0
==> office1Router: Setting hostname...
==> office1Router: Running provisioner: ansible...
    office1Router: Running ansible-playbook...

PLAY [Настроить лабораторные интерфейсы через Netplan] *************************

TASK [Записать конфигурацию лабораторных интерфейсов] **************************
changed: [office1Router]

RUNNING HANDLER [Применить настройки Netplan] **********************************
changed: [office1Router]

PLAY RECAP *********************************************************************
office1Router              : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

==> testClient1: Importing base box 'generic/ubuntu2204'...
==> testClient1: Matching MAC address for NAT networking...
==> testClient1: Checking if box 'generic/ubuntu2204' version '4.3.12' is up to date...
==> testClient1: Setting the name of the VM: vlan-bond-testClient1
==> testClient1: Fixed port collision for 22 => 2222. Now on port 2202.
==> testClient1: Clearing any previously set network interfaces...
==> testClient1: Preparing network interfaces based on configuration...
    testClient1: Adapter 1: nat
==> testClient1: Forwarding ports...
    testClient1: 22 (guest) => 2202 (host) (adapter 1)
==> testClient1: Running 'pre-boot' VM customizations...
==> testClient1: Booting VM...
==> testClient1: Waiting for machine to boot. This may take a few minutes...
    testClient1: SSH address: 127.0.0.1:2202
    testClient1: SSH username: vagrant
    testClient1: SSH auth method: private key
    testClient1: Warning: Connection reset. Retrying...
    testClient1: Warning: Connection reset. Retrying...
    testClient1: Warning: Connection reset. Retrying...
    testClient1: Warning: Remote connection disconnect. Retrying...
    testClient1: Warning: Connection reset. Retrying...
    testClient1: Warning: Connection reset. Retrying...
    testClient1: Warning: Connection reset. Retrying...
    testClient1: Warning: Remote connection disconnect. Retrying...
    testClient1: Warning: Connection reset. Retrying...
    testClient1: Warning: Connection reset. Retrying...
    testClient1: Warning: Connection reset. Retrying...
    testClient1: Warning: Remote connection disconnect. Retrying...
    testClient1: Warning: Connection reset. Retrying...
    testClient1: Warning: Connection reset. Retrying...
    testClient1: Warning: Connection reset. Retrying...
    testClient1: Warning: Remote connection disconnect. Retrying...
    testClient1: Warning: Connection reset. Retrying...
    testClient1: Warning: Connection reset. Retrying...
    testClient1:
    testClient1: Vagrant insecure key detected. Vagrant will automatically replace
    testClient1: this with a newly generated keypair for better security.
    testClient1:
    testClient1: Inserting generated public key within guest...
    testClient1: Removing insecure key from the guest if it's present...
    testClient1: Key inserted! Disconnecting and reconnecting using new SSH key...
==> testClient1: Machine booted and ready!
==> testClient1: Checking for guest additions in VM...
    testClient1: The guest additions on this VM do not match the installed version of
    testClient1: VirtualBox! In most cases this is fine, but in rare cases it can
    testClient1: prevent things such as shared folders from working properly. If you see
    testClient1: shared folder errors, please make sure the guest additions within the
    testClient1: virtual machine match the version of VirtualBox you have installed on
    testClient1: your host and reload your VM.
    testClient1:
    testClient1: Guest Additions Version: 6.1.38
    testClient1: VirtualBox Version: 7.0
==> testClient1: Setting hostname...
==> testClient1: Running provisioner: ansible...
    testClient1: Running ansible-playbook...

PLAY [Настроить лабораторные интерфейсы через Netplan] *************************

TASK [Записать конфигурацию лабораторных интерфейсов] **************************
changed: [testClient1]

RUNNING HANDLER [Применить настройки Netplan] **********************************
changed: [testClient1]

PLAY RECAP *********************************************************************
testClient1                : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

==> testServer1: Importing base box 'generic/ubuntu2204'...
==> testServer1: Matching MAC address for NAT networking...
==> testServer1: Checking if box 'generic/ubuntu2204' version '4.3.12' is up to date...
==> testServer1: Setting the name of the VM: vlan-bond-testServer1
==> testServer1: Fixed port collision for 22 => 2222. Now on port 2203.
==> testServer1: Clearing any previously set network interfaces...
==> testServer1: Preparing network interfaces based on configuration...
    testServer1: Adapter 1: nat
==> testServer1: Forwarding ports...
    testServer1: 22 (guest) => 2203 (host) (adapter 1)
==> testServer1: Running 'pre-boot' VM customizations...
==> testServer1: Booting VM...
==> testServer1: Waiting for machine to boot. This may take a few minutes...
    testServer1: SSH address: 127.0.0.1:2203
    testServer1: SSH username: vagrant
    testServer1: SSH auth method: private key
    testServer1: Warning: Connection reset. Retrying...
    testServer1: Warning: Connection reset. Retrying...
    testServer1: Warning: Connection reset. Retrying...
    testServer1: Warning: Connection reset. Retrying...
    testServer1: Warning: Connection reset. Retrying...
    testServer1: Warning: Connection reset. Retrying...
    testServer1: Warning: Connection reset. Retrying...
    testServer1: Warning: Connection reset. Retrying...
    testServer1: Warning: Connection reset. Retrying...
    testServer1: Warning: Connection reset. Retrying...
    testServer1: Warning: Connection reset. Retrying...
    testServer1: Warning: Connection reset. Retrying...
    testServer1: Warning: Connection reset. Retrying...
    testServer1: Warning: Connection reset. Retrying...
    testServer1:
    testServer1: Vagrant insecure key detected. Vagrant will automatically replace
    testServer1: this with a newly generated keypair for better security.
    testServer1:
    testServer1: Inserting generated public key within guest...
    testServer1: Removing insecure key from the guest if it's present...
    testServer1: Key inserted! Disconnecting and reconnecting using new SSH key...
==> testServer1: Machine booted and ready!
==> testServer1: Checking for guest additions in VM...
    testServer1: The guest additions on this VM do not match the installed version of
    testServer1: VirtualBox! In most cases this is fine, but in rare cases it can
    testServer1: prevent things such as shared folders from working properly. If you see
    testServer1: shared folder errors, please make sure the guest additions within the
    testServer1: virtual machine match the version of VirtualBox you have installed on
    testServer1: your host and reload your VM.
    testServer1:
    testServer1: Guest Additions Version: 6.1.38
    testServer1: VirtualBox Version: 7.0
==> testServer1: Setting hostname...
==> testServer1: Running provisioner: ansible...
    testServer1: Running ansible-playbook...

PLAY [Настроить лабораторные интерфейсы через Netplan] *************************

TASK [Записать конфигурацию лабораторных интерфейсов] **************************
changed: [testServer1]

RUNNING HANDLER [Применить настройки Netplan] **********************************
changed: [testServer1]

PLAY RECAP *********************************************************************
testServer1                : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

==> testClient2: Importing base box 'generic/ubuntu2204'...
==> testClient2: Matching MAC address for NAT networking...
==> testClient2: Checking if box 'generic/ubuntu2204' version '4.3.12' is up to date...
==> testClient2: Setting the name of the VM: vlan-bond-testClient2
==> testClient2: Fixed port collision for 22 => 2222. Now on port 2204.
==> testClient2: Clearing any previously set network interfaces...
==> testClient2: Preparing network interfaces based on configuration...
    testClient2: Adapter 1: nat
==> testClient2: Forwarding ports...
    testClient2: 22 (guest) => 2204 (host) (adapter 1)
==> testClient2: Running 'pre-boot' VM customizations...
==> testClient2: Booting VM...
==> testClient2: Waiting for machine to boot. This may take a few minutes...
    testClient2: SSH address: 127.0.0.1:2204
    testClient2: SSH username: vagrant
    testClient2: SSH auth method: private key
    testClient2: Warning: Connection reset. Retrying...
    testClient2: Warning: Connection reset. Retrying...
    testClient2: Warning: Connection reset. Retrying...
    testClient2: Warning: Connection reset. Retrying...
    testClient2: Warning: Remote connection disconnect. Retrying...
    testClient2: Warning: Connection reset. Retrying...
    testClient2: Warning: Connection reset. Retrying...
    testClient2: Warning: Connection reset. Retrying...
    testClient2: Warning: Connection reset. Retrying...
    testClient2: Warning: Connection reset. Retrying...
    testClient2: Warning: Connection reset. Retrying...
    testClient2: Warning: Connection reset. Retrying...
    testClient2: Warning: Connection reset. Retrying...
    testClient2: Warning: Remote connection disconnect. Retrying...
    testClient2: Warning: Connection reset. Retrying...
    testClient2: Warning: Connection reset. Retrying...
    testClient2:
    testClient2: Vagrant insecure key detected. Vagrant will automatically replace
    testClient2: this with a newly generated keypair for better security.
    testClient2:
    testClient2: Inserting generated public key within guest...
    testClient2: Removing insecure key from the guest if it's present...
    testClient2: Key inserted! Disconnecting and reconnecting using new SSH key...
==> testClient2: Machine booted and ready!
==> testClient2: Checking for guest additions in VM...
    testClient2: The guest additions on this VM do not match the installed version of
    testClient2: VirtualBox! In most cases this is fine, but in rare cases it can
    testClient2: prevent things such as shared folders from working properly. If you see
    testClient2: shared folder errors, please make sure the guest additions within the
    testClient2: virtual machine match the version of VirtualBox you have installed on
    testClient2: your host and reload your VM.
    testClient2:
    testClient2: Guest Additions Version: 6.1.38
    testClient2: VirtualBox Version: 7.0
==> testClient2: Setting hostname...
==> testClient2: Running provisioner: ansible...
    testClient2: Running ansible-playbook...

PLAY [Настроить лабораторные интерфейсы через Netplan] *************************

TASK [Записать конфигурацию лабораторных интерфейсов] **************************
changed: [testClient2]

RUNNING HANDLER [Применить настройки Netplan] **********************************
changed: [testClient2]

PLAY RECAP *********************************************************************
testClient2                : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

==> testServer2: Importing base box 'generic/ubuntu2204'...
==> testServer2: Matching MAC address for NAT networking...
==> testServer2: Checking if box 'generic/ubuntu2204' version '4.3.12' is up to date...
==> testServer2: Setting the name of the VM: vlan-bond-testServer2
==> testServer2: Fixed port collision for 22 => 2222. Now on port 2205.
==> testServer2: Clearing any previously set network interfaces...
==> testServer2: Preparing network interfaces based on configuration...
    testServer2: Adapter 1: nat
==> testServer2: Forwarding ports...
    testServer2: 22 (guest) => 2205 (host) (adapter 1)
==> testServer2: Running 'pre-boot' VM customizations...
==> testServer2: Booting VM...
==> testServer2: Waiting for machine to boot. This may take a few minutes...
    testServer2: SSH address: 127.0.0.1:2205
    testServer2: SSH username: vagrant
    testServer2: SSH auth method: private key
    testServer2: Warning: Connection reset. Retrying...
    testServer2: Warning: Connection reset. Retrying...
    testServer2: Warning: Remote connection disconnect. Retrying...
    testServer2: Warning: Connection reset. Retrying...
    testServer2: Warning: Connection reset. Retrying...
    testServer2: Warning: Connection reset. Retrying...
    testServer2: Warning: Connection reset. Retrying...
    testServer2: Warning: Connection reset. Retrying...
    testServer2: Warning: Connection reset. Retrying...
    testServer2: Warning: Connection reset. Retrying...
    testServer2: Warning: Connection reset. Retrying...
    testServer2: Warning: Connection reset. Retrying...
    testServer2: Warning: Remote connection disconnect. Retrying...
    testServer2: Warning: Connection reset. Retrying...
    testServer2: Warning: Connection reset. Retrying...
    testServer2: Warning: Connection reset. Retrying...
    testServer2: Warning: Connection reset. Retrying...
    testServer2:
    testServer2: Vagrant insecure key detected. Vagrant will automatically replace
    testServer2: this with a newly generated keypair for better security.
    testServer2:
    testServer2: Inserting generated public key within guest...
    testServer2: Removing insecure key from the guest if it's present...
    testServer2: Key inserted! Disconnecting and reconnecting using new SSH key...
==> testServer2: Machine booted and ready!
==> testServer2: Checking for guest additions in VM...
    testServer2: The guest additions on this VM do not match the installed version of
    testServer2: VirtualBox! In most cases this is fine, but in rare cases it can
    testServer2: prevent things such as shared folders from working properly. If you see
    testServer2: shared folder errors, please make sure the guest additions within the
    testServer2: virtual machine match the version of VirtualBox you have installed on
    testServer2: your host and reload your VM.
    testServer2:
    testServer2: Guest Additions Version: 6.1.38
    testServer2: VirtualBox Version: 7.0
==> testServer2: Setting hostname...
==> testServer2: Running provisioner: ansible...
    testServer2: Running ansible-playbook...

PLAY [Настроить лабораторные интерфейсы через Netplan] *************************

TASK [Записать конфигурацию лабораторных интерфейсов] **************************
changed: [testServer2]

RUNNING HANDLER [Применить настройки Netplan] **********************************
changed: [testServer2]

PLAY RECAP *********************************************************************
testServer2                : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

root@nfsc:~/vlan-bond-hw#

```

##  Проверка VLAN и резервирования

```bash
root@nfsc:~/vlan-bond-hw# set -o pipefail
bash verify.sh 2>&1 | tee verification.log
=== VLAN 1 и VLAN 2: связность и MAC соседей ===
VLAN 1
4: vlan1@testlan: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 02:00:00:36:21:02 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535
    vlan protocol 802.1Q id 1 <REORDER_HDR> addrgenmode none numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
PING 10.10.10.1 (10.10.10.1) from 10.10.10.254 vlan1: 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=6.21 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=8.43 ms
64 bytes from 10.10.10.1: icmp_seq=3 ttl=64 time=13.8 ms

--- 10.10.10.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2007ms
rtt min/avg/max/mdev = 6.214/9.478/13.794/3.182 ms
10.10.10.1 lladdr 02:00:00:36:22:02 REACHABLE
PING 10.10.10.254 (10.10.10.254) from 10.10.10.1 vlan1: 56(84) bytes of data.
64 bytes from 10.10.10.254: icmp_seq=1 ttl=64 time=4.65 ms
64 bytes from 10.10.10.254: icmp_seq=2 ttl=64 time=8.53 ms
64 bytes from 10.10.10.254: icmp_seq=3 ttl=64 time=6.77 ms

--- 10.10.10.254 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2008ms
rtt min/avg/max/mdev = 4.652/6.648/8.526/1.583 ms
10.10.10.254 lladdr 02:00:00:36:21:02 REACHABLE
PING 10.10.10.1 (10.10.10.1) from 10.10.10.254 vlan1: 56(84) bytes of data.

--- 10.10.10.1 ping statistics ---
2 packets transmitted, 0 received, 100% packet loss, time 1018ms

Изоляция VLAN подтверждена
VLAN 2
4: vlan2@testlan: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 02:00:00:36:31:02 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535
    vlan protocol 802.1Q id 2 <REORDER_HDR> addrgenmode none numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
PING 10.10.10.1 (10.10.10.1) from 10.10.10.254 vlan2: 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=9.15 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=7.80 ms
64 bytes from 10.10.10.1: icmp_seq=3 ttl=64 time=9.81 ms

--- 10.10.10.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2014ms
rtt min/avg/max/mdev = 7.803/8.922/9.813/0.836 ms
10.10.10.1 lladdr 02:00:00:36:32:02 REACHABLE
PING 10.10.10.254 (10.10.10.254) from 10.10.10.1 vlan2: 56(84) bytes of data.
64 bytes from 10.10.10.254: icmp_seq=1 ttl=64 time=4.51 ms
64 bytes from 10.10.10.254: icmp_seq=2 ttl=64 time=6.29 ms
64 bytes from 10.10.10.254: icmp_seq=3 ttl=64 time=17.1 ms

--- 10.10.10.254 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2007ms
rtt min/avg/max/mdev = 4.509/9.292/17.074/5.550 ms
10.10.10.254 lladdr 02:00:00:36:31:02 REACHABLE
PING 10.10.10.1 (10.10.10.1) from 10.10.10.254 vlan2: 56(84) bytes of data.

--- 10.10.10.1 ping statistics ---
2 packets transmitted, 0 received, 100% packet loss, time 1031ms

Изоляция VLAN подтверждена
=== Uplink Office1 ===
PING 192.168.255.10 (192.168.255.10) from 192.168.255.9 office-uplink: 56(84) bytes of data.
64 bytes from 192.168.255.10: icmp_seq=1 ttl=64 time=9.20 ms
64 bytes from 192.168.255.10: icmp_seq=2 ttl=64 time=6.53 ms
64 bytes from 192.168.255.10: icmp_seq=3 ttl=64 time=5.73 ms

--- 192.168.255.10 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2010ms
rtt min/avg/max/mdev = 5.731/7.153/9.201/1.484 ms
=== bond0 до отказа ===
Ethernet Channel Bonding Driver: v5.15.0-91-generic

Bonding Mode: fault-tolerance (active-backup) (fail_over_mac active)
Primary Slave: lab-a (primary_reselect always)
Currently Active Slave: lab-a
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0
Peer Notification Delay (ms): 0

Slave Interface: lab-a
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 02:00:00:36:11:02
Slave queue ID: 0

Slave Interface: lab-b
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 02:00:00:36:11:03
Slave queue ID: 0
PING 192.168.255.2 (192.168.255.2) from 192.168.255.1 bond0: 56(84) bytes of data.
64 bytes from 192.168.255.2: icmp_seq=1 ttl=64 time=38.0 ms
64 bytes from 192.168.255.2: icmp_seq=2 ttl=64 time=5.86 ms
64 bytes from 192.168.255.2: icmp_seq=3 ttl=64 time=5.13 ms

--- 192.168.255.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2019ms
rtt min/avg/max/mdev = 5.125/16.324/37.992/15.324 ms
Ethernet Channel Bonding Driver: v5.15.0-91-generic

Bonding Mode: fault-tolerance (active-backup) (fail_over_mac active)
Primary Slave: lab-a (primary_reselect always)
Currently Active Slave: lab-a
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0
Peer Notification Delay (ms): 0

Slave Interface: lab-a
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 02:00:00:36:12:02
Slave queue ID: 0

Slave Interface: lab-b
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 02:00:00:36:12:03
Slave queue ID: 0
=== Отключаем lab-a на centralRouter ===
PING 192.168.255.2 (192.168.255.2) from 192.168.255.1 bond0: 56(84) bytes of data.
64 bytes from 192.168.255.2: icmp_seq=1 ttl=64 time=36.7 ms
64 bytes from 192.168.255.2: icmp_seq=2 ttl=64 time=35.9 ms
64 bytes from 192.168.255.2: icmp_seq=3 ttl=64 time=7.57 ms
64 bytes from 192.168.255.2: icmp_seq=4 ttl=64 time=36.5 ms
64 bytes from 192.168.255.2: icmp_seq=5 ttl=64 time=8.18 ms
64 bytes from 192.168.255.2: icmp_seq=6 ttl=64 time=8.00 ms
64 bytes from 192.168.255.2: icmp_seq=7 ttl=64 time=11.6 ms
64 bytes from 192.168.255.2: icmp_seq=8 ttl=64 time=8.38 ms
64 bytes from 192.168.255.2: icmp_seq=9 ttl=64 time=4.69 ms
64 bytes from 192.168.255.2: icmp_seq=10 ttl=64 time=6.46 ms
64 bytes from 192.168.255.2: icmp_seq=11 ttl=64 time=8.59 ms
64 bytes from 192.168.255.2: icmp_seq=12 ttl=64 time=5.26 ms
64 bytes from 192.168.255.2: icmp_seq=13 ttl=64 time=7.08 ms
64 bytes from 192.168.255.2: icmp_seq=14 ttl=64 time=12.0 ms
64 bytes from 192.168.255.2: icmp_seq=15 ttl=64 time=8.79 ms
64 bytes from 192.168.255.2: icmp_seq=16 ttl=64 time=6.94 ms
64 bytes from 192.168.255.2: icmp_seq=17 ttl=64 time=8.25 ms
64 bytes from 192.168.255.2: icmp_seq=18 ttl=64 time=4.51 ms
64 bytes from 192.168.255.2: icmp_seq=19 ttl=64 time=9.88 ms
64 bytes from 192.168.255.2: icmp_seq=20 ttl=64 time=8.78 ms
64 bytes from 192.168.255.2: icmp_seq=21 ttl=64 time=4.47 ms
64 bytes from 192.168.255.2: icmp_seq=22 ttl=64 time=5.91 ms
64 bytes from 192.168.255.2: icmp_seq=23 ttl=64 time=14.9 ms
64 bytes from 192.168.255.2: icmp_seq=24 ttl=64 time=12.9 ms

--- 192.168.255.2 ping statistics ---
24 packets transmitted, 24 received, 0% packet loss, time 6995ms
rtt min/avg/max/mdev = 4.466/11.758/36.688/9.640 ms
Ethernet Channel Bonding Driver: v5.15.0-91-generic

Bonding Mode: fault-tolerance (active-backup) (fail_over_mac active)
Primary Slave: lab-a (primary_reselect always)
Currently Active Slave: lab-b
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0
Peer Notification Delay (ms): 0

Slave Interface: lab-a
MII Status: down
Speed: Unknown
Duplex: Unknown
Link Failure Count: 1
Permanent HW addr: 02:00:00:36:12:02
Slave queue ID: 0

Slave Interface: lab-b
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 02:00:00:36:12:03
Slave queue ID: 0
PING 192.168.255.1 (192.168.255.1) from 192.168.255.2 bond0: 56(84) bytes of data.
64 bytes from 192.168.255.1: icmp_seq=1 ttl=64 time=5.85 ms
64 bytes from 192.168.255.1: icmp_seq=2 ttl=64 time=9.33 ms
64 bytes from 192.168.255.1: icmp_seq=3 ttl=64 time=27.0 ms

--- 192.168.255.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2006ms
rtt min/avg/max/mdev = 5.854/14.056/26.986/9.251 ms
=== Восстанавливаем линк ===
PING 192.168.255.2 (192.168.255.2) from 192.168.255.1 bond0: 56(84) bytes of data.
64 bytes from 192.168.255.2: icmp_seq=1 ttl=64 time=18.6 ms
64 bytes from 192.168.255.2: icmp_seq=2 ttl=64 time=7.80 ms
64 bytes from 192.168.255.2: icmp_seq=3 ttl=64 time=7.13 ms

--- 192.168.255.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2005ms
rtt min/avg/max/mdev = 7.133/11.162/18.556/5.235 ms
root@nfsc:~/vlan-bond-hw#

```

просмотра статуса:

```bash
root@nfsc:~/vlan-bond-hw# vagrant ssh centralRouter -c 'ip -br addr; cat /proc/net/bonding/bond0'
vagrant ssh testClient1 -c 'ip -d link show vlan1; ip neigh show dev vlan1'
vagrant ssh testClient2 -c 'ip -d link show vlan2; ip neigh show dev vlan2'
lo               UNKNOWN        127.0.0.1/8
eth0             UP             10.0.2.15/24 metric 100 fe80::a00:27ff:fe8c:6941/64
lab-a            UP
lab-b            UP
office-uplink    UP             192.168.255.9/30
bond0            UP             192.168.255.2/30
Ethernet Channel Bonding Driver: v5.15.0-91-generic

Bonding Mode: fault-tolerance (active-backup) (fail_over_mac active)
Primary Slave: lab-a (primary_reselect always)
Currently Active Slave: lab-a
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0
Peer Notification Delay (ms): 0

Slave Interface: lab-a
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 1
Permanent HW addr: 02:00:00:36:12:02
Slave queue ID: 0

Slave Interface: lab-b
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 02:00:00:36:12:03
Slave queue ID: 0
4: vlan1@testlan: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 02:00:00:36:21:02 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535
    vlan protocol 802.1Q id 1 <REORDER_HDR> addrgenmode none numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
4: vlan2@testlan: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 02:00:00:36:31:02 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535
    vlan protocol 802.1Q id 2 <REORDER_HDR> addrgenmode none numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
root@nfsc:~/vlan-bond-hw#


```


## Дополнительно: настоящий LACP

```bash
root@nfsc:~/vlan-bond-hw# BOND_MODE=active-backup vagrant reload inetRouter centralRouter --provision &&
BOND_MODE=active-backup vagrant reload inetRouter centralRouter --no-provision
==> inetRouter: Attempting graceful shutdown of VM...
==> inetRouter: Checking if box 'generic/ubuntu2204' version '4.3.12' is up to date...
==> inetRouter: Clearing any previously set forwarded ports...
==> inetRouter: Clearing any previously set network interfaces...
==> inetRouter: Preparing network interfaces based on configuration...
    inetRouter: Adapter 1: nat
==> inetRouter: Forwarding ports...
    inetRouter: 22 (guest) => 2222 (host) (adapter 1)
==> inetRouter: Running 'pre-boot' VM customizations...
==> inetRouter: Booting VM...
==> inetRouter: Waiting for machine to boot. This may take a few minutes...
    inetRouter: SSH address: 127.0.0.1:2222
    inetRouter: SSH username: vagrant
    inetRouter: SSH auth method: private key
    inetRouter: Warning: Connection reset. Retrying...
    inetRouter: Warning: Remote connection disconnect. Retrying...
==> inetRouter: Machine booted and ready!
==> inetRouter: Checking for guest additions in VM...
    inetRouter: The guest additions on this VM do not match the installed version of
    inetRouter: VirtualBox! In most cases this is fine, but in rare cases it can
    inetRouter: prevent things such as shared folders from working properly. If you see
    inetRouter: shared folder errors, please make sure the guest additions within the
    inetRouter: virtual machine match the version of VirtualBox you have installed on
    inetRouter: your host and reload your VM.
    inetRouter:
    inetRouter: Guest Additions Version: 6.1.38
    inetRouter: VirtualBox Version: 7.0
==> inetRouter: Setting hostname...
==> inetRouter: Running provisioner: ansible...
    inetRouter: Running ansible-playbook...

PLAY [Настроить лабораторные интерфейсы через Netplan] *************************

TASK [Записать конфигурацию лабораторных интерфейсов] **************************
ok: [inetRouter]

PLAY RECAP *********************************************************************
inetRouter                 : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

==> centralRouter: Attempting graceful shutdown of VM...
==> centralRouter: Checking if box 'generic/ubuntu2204' version '4.3.12' is up to date...
==> centralRouter: Clearing any previously set forwarded ports...
==> centralRouter: Fixed port collision for 22 => 2222. Now on port 2200.
==> centralRouter: Clearing any previously set network interfaces...
==> centralRouter: Preparing network interfaces based on configuration...
    centralRouter: Adapter 1: nat
==> centralRouter: Forwarding ports...
    centralRouter: 22 (guest) => 2200 (host) (adapter 1)
==> centralRouter: Running 'pre-boot' VM customizations...
==> centralRouter: Booting VM...
==> centralRouter: Waiting for machine to boot. This may take a few minutes...
    centralRouter: SSH address: 127.0.0.1:2200
    centralRouter: SSH username: vagrant
    centralRouter: SSH auth method: private key
    centralRouter: Warning: Connection reset. Retrying...
    centralRouter: Warning: Connection reset. Retrying...
    centralRouter: Warning: Connection reset. Retrying...
    centralRouter: Warning: Connection reset. Retrying...
==> centralRouter: Machine booted and ready!
==> centralRouter: Checking for guest additions in VM...
    centralRouter: The guest additions on this VM do not match the installed version of
    centralRouter: VirtualBox! In most cases this is fine, but in rare cases it can
    centralRouter: prevent things such as shared folders from working properly. If you see
    centralRouter: shared folder errors, please make sure the guest additions within the
    centralRouter: virtual machine match the version of VirtualBox you have installed on
    centralRouter: your host and reload your VM.
    centralRouter:
    centralRouter: Guest Additions Version: 6.1.38
    centralRouter: VirtualBox Version: 7.0
==> centralRouter: Setting hostname...
==> centralRouter: Running provisioner: ansible...
    centralRouter: Running ansible-playbook...

PLAY [Настроить лабораторные интерфейсы через Netplan] *************************

TASK [Записать конфигурацию лабораторных интерфейсов] **************************
ok: [centralRouter]

PLAY RECAP *********************************************************************
centralRouter              : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

==> inetRouter: Attempting graceful shutdown of VM...
==> inetRouter: Checking if box 'generic/ubuntu2204' version '4.3.12' is up to date...
==> inetRouter: Clearing any previously set forwarded ports...
==> inetRouter: Clearing any previously set network interfaces...
==> inetRouter: Preparing network interfaces based on configuration...
    inetRouter: Adapter 1: nat
==> inetRouter: Forwarding ports...
    inetRouter: 22 (guest) => 2222 (host) (adapter 1)
==> inetRouter: Running 'pre-boot' VM customizations...
==> inetRouter: Booting VM...
==> inetRouter: Waiting for machine to boot. This may take a few minutes...
    inetRouter: SSH address: 127.0.0.1:2222
    inetRouter: SSH username: vagrant
    inetRouter: SSH auth method: private key
    inetRouter: Warning: Connection reset. Retrying...
==> inetRouter: Machine booted and ready!
==> inetRouter: Checking for guest additions in VM...
    inetRouter: The guest additions on this VM do not match the installed version of
    inetRouter: VirtualBox! In most cases this is fine, but in rare cases it can
    inetRouter: prevent things such as shared folders from working properly. If you see
    inetRouter: shared folder errors, please make sure the guest additions within the
    inetRouter: virtual machine match the version of VirtualBox you have installed on
    inetRouter: your host and reload your VM.
    inetRouter:
    inetRouter: Guest Additions Version: 6.1.38
    inetRouter: VirtualBox Version: 7.0
==> inetRouter: Setting hostname...
==> inetRouter: Machine not provisioned because `--no-provision` is specified.
==> centralRouter: Attempting graceful shutdown of VM...
==> centralRouter: Checking if box 'generic/ubuntu2204' version '4.3.12' is up to date...
==> centralRouter: Clearing any previously set forwarded ports...
==> centralRouter: Fixed port collision for 22 => 2222. Now on port 2200.
==> centralRouter: Clearing any previously set network interfaces...
==> centralRouter: Preparing network interfaces based on configuration...
    centralRouter: Adapter 1: nat
==> centralRouter: Forwarding ports...
    centralRouter: 22 (guest) => 2200 (host) (adapter 1)
==> centralRouter: Running 'pre-boot' VM customizations...
==> centralRouter: Booting VM...
==> centralRouter: Waiting for machine to boot. This may take a few minutes...
    centralRouter: SSH address: 127.0.0.1:2200
    centralRouter: SSH username: vagrant
    centralRouter: SSH auth method: private key
    centralRouter: Warning: Connection reset. Retrying...
==> centralRouter: Machine booted and ready!
==> centralRouter: Checking for guest additions in VM...
    centralRouter: The guest additions on this VM do not match the installed version of
    centralRouter: VirtualBox! In most cases this is fine, but in rare cases it can
    centralRouter: prevent things such as shared folders from working properly. If you see
    centralRouter: shared folder errors, please make sure the guest additions within the
    centralRouter: virtual machine match the version of VirtualBox you have installed on
    centralRouter: your host and reload your VM.
    centralRouter:
    centralRouter: Guest Additions Version: 6.1.38
    centralRouter: VirtualBox Version: 7.0
==> centralRouter: Setting hostname...
==> centralRouter: Machine not provisioned because `--no-provision` is specified.
root@nfsc:~/vlan-bond-hw#

```

Вторая перезагрузка пересоздаёт bond из обновлённого Netplan. Дождитесь сходимости LACP и выполните:

```bash
bash -n verify.sh && bash verify.sh 2>&1 | tee verification.log
=== VLAN 1 и VLAN 2: связность и MAC соседей ===
VLAN 1
4: vlan1@testlan: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 02:00:00:36:21:02 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535
    vlan protocol 802.1Q id 1 <REORDER_HDR> addrgenmode none numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
PING 10.10.10.1 (10.10.10.1) from 10.10.10.254 vlan1: 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=6.60 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=21.7 ms
64 bytes from 10.10.10.1: icmp_seq=3 ttl=64 time=8.50 ms

--- 10.10.10.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2006ms
rtt min/avg/max/mdev = 6.603/12.255/21.666/6.699 ms
10.10.10.1 lladdr 02:00:00:36:22:02 REACHABLE
PING 10.10.10.254 (10.10.10.254) from 10.10.10.1 vlan1: 56(84) bytes of data.
64 bytes from 10.10.10.254: icmp_seq=1 ttl=64 time=15.1 ms
64 bytes from 10.10.10.254: icmp_seq=2 ttl=64 time=4.70 ms
64 bytes from 10.10.10.254: icmp_seq=3 ttl=64 time=12.2 ms

--- 10.10.10.254 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2037ms
rtt min/avg/max/mdev = 4.697/10.662/15.114/4.385 ms
10.10.10.254 lladdr 02:00:00:36:21:02 REACHABLE
PING 10.10.10.1 (10.10.10.1) from 10.10.10.254 vlan1: 56(84) bytes of data.

--- 10.10.10.1 ping statistics ---
2 packets transmitted, 0 received, 100% packet loss, time 1032ms

Изоляция VLAN подтверждена
VLAN 2
4: vlan2@testlan: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 02:00:00:36:31:02 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535
    vlan protocol 802.1Q id 2 <REORDER_HDR> addrgenmode none numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
PING 10.10.10.1 (10.10.10.1) from 10.10.10.254 vlan2: 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=10.6 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=16.9 ms
64 bytes from 10.10.10.1: icmp_seq=3 ttl=64 time=16.9 ms

--- 10.10.10.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2018ms
rtt min/avg/max/mdev = 10.562/14.782/16.902/2.984 ms
10.10.10.1 lladdr 02:00:00:36:32:02 REACHABLE
PING 10.10.10.254 (10.10.10.254) from 10.10.10.1 vlan2: 56(84) bytes of data.
64 bytes from 10.10.10.254: icmp_seq=1 ttl=64 time=3.06 ms
64 bytes from 10.10.10.254: icmp_seq=2 ttl=64 time=6.51 ms
64 bytes from 10.10.10.254: icmp_seq=3 ttl=64 time=15.6 ms

--- 10.10.10.254 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2006ms
rtt min/avg/max/mdev = 3.055/8.393/15.617/5.298 ms
10.10.10.254 lladdr 02:00:00:36:31:02 REACHABLE
PING 10.10.10.1 (10.10.10.1) from 10.10.10.254 vlan2: 56(84) bytes of data.

--- 10.10.10.1 ping statistics ---
2 packets transmitted, 0 received, 100% packet loss, time 1028ms

Изоляция VLAN подтверждена
=== Uplink Office1 ===
PING 192.168.255.10 (192.168.255.10) from 192.168.255.9 office-uplink: 56(84) bytes of data.
64 bytes from 192.168.255.10: icmp_seq=1 ttl=64 time=6.78 ms
64 bytes from 192.168.255.10: icmp_seq=2 ttl=64 time=6.24 ms
64 bytes from 192.168.255.10: icmp_seq=3 ttl=64 time=10.4 ms

--- 192.168.255.10 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2005ms
rtt min/avg/max/mdev = 6.242/7.801/10.378/1.835 ms
=== bond0 до отказа ===
Ethernet Channel Bonding Driver: v5.15.0-91-generic

Bonding Mode: fault-tolerance (active-backup) (fail_over_mac active)
Primary Slave: lab-a (primary_reselect always)
Currently Active Slave: lab-a
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0
Peer Notification Delay (ms): 0

Slave Interface: lab-b
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 02:00:00:36:11:03
Slave queue ID: 0

Slave Interface: lab-a
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 02:00:00:36:11:02
Slave queue ID: 0
PING 192.168.255.2 (192.168.255.2) from 192.168.255.1 bond0: 56(84) bytes of data.
64 bytes from 192.168.255.2: icmp_seq=1 ttl=64 time=4.83 ms
64 bytes from 192.168.255.2: icmp_seq=2 ttl=64 time=8.68 ms
64 bytes from 192.168.255.2: icmp_seq=3 ttl=64 time=9.09 ms

--- 192.168.255.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2007ms
rtt min/avg/max/mdev = 4.825/7.530/9.091/1.920 ms
Ethernet Channel Bonding Driver: v5.15.0-91-generic

Bonding Mode: fault-tolerance (active-backup) (fail_over_mac active)
Primary Slave: lab-a (primary_reselect always)
Currently Active Slave: lab-a
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0
Peer Notification Delay (ms): 0

Slave Interface: lab-b
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 02:00:00:36:12:03
Slave queue ID: 0

Slave Interface: lab-a
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 02:00:00:36:12:02
Slave queue ID: 0
=== Отключаем lab-a на centralRouter ===
PING 192.168.255.2 (192.168.255.2) from 192.168.255.1 bond0: 56(84) bytes of data.
64 bytes from 192.168.255.2: icmp_seq=1 ttl=64 time=51.0 ms
64 bytes from 192.168.255.2: icmp_seq=2 ttl=64 time=12.1 ms
64 bytes from 192.168.255.2: icmp_seq=3 ttl=64 time=8.25 ms
64 bytes from 192.168.255.2: icmp_seq=4 ttl=64 time=6.65 ms
64 bytes from 192.168.255.2: icmp_seq=5 ttl=64 time=3.48 ms
64 bytes from 192.168.255.2: icmp_seq=6 ttl=64 time=9.09 ms
64 bytes from 192.168.255.2: icmp_seq=7 ttl=64 time=7.57 ms
64 bytes from 192.168.255.2: icmp_seq=8 ttl=64 time=5.54 ms
64 bytes from 192.168.255.2: icmp_seq=9 ttl=64 time=6.46 ms
64 bytes from 192.168.255.2: icmp_seq=10 ttl=64 time=15.3 ms
64 bytes from 192.168.255.2: icmp_seq=11 ttl=64 time=9.11 ms
64 bytes from 192.168.255.2: icmp_seq=12 ttl=64 time=6.66 ms
64 bytes from 192.168.255.2: icmp_seq=13 ttl=64 time=7.09 ms
64 bytes from 192.168.255.2: icmp_seq=14 ttl=64 time=7.50 ms
64 bytes from 192.168.255.2: icmp_seq=15 ttl=64 time=6.24 ms
64 bytes from 192.168.255.2: icmp_seq=16 ttl=64 time=9.71 ms
64 bytes from 192.168.255.2: icmp_seq=17 ttl=64 time=13.9 ms
64 bytes from 192.168.255.2: icmp_seq=18 ttl=64 time=8.61 ms
64 bytes from 192.168.255.2: icmp_seq=19 ttl=64 time=64.3 ms
64 bytes from 192.168.255.2: icmp_seq=20 ttl=64 time=23.9 ms
64 bytes from 192.168.255.2: icmp_seq=21 ttl=64 time=7.38 ms
64 bytes from 192.168.255.2: icmp_seq=22 ttl=64 time=2.06 ms
64 bytes from 192.168.255.2: icmp_seq=23 ttl=64 time=13.0 ms
64 bytes from 192.168.255.2: icmp_seq=24 ttl=64 time=9.21 ms

--- 192.168.255.2 ping statistics ---
24 packets transmitted, 24 received, 0% packet loss, time 7243ms
rtt min/avg/max/mdev = 2.059/13.085/64.297/14.227 ms
Ethernet Channel Bonding Driver: v5.15.0-91-generic

Bonding Mode: fault-tolerance (active-backup) (fail_over_mac active)
Primary Slave: lab-a (primary_reselect always)
Currently Active Slave: lab-b
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0
Peer Notification Delay (ms): 0

Slave Interface: lab-b
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 02:00:00:36:12:03
Slave queue ID: 0

Slave Interface: lab-a
MII Status: down
Speed: Unknown
Duplex: Unknown
Link Failure Count: 1
Permanent HW addr: 02:00:00:36:12:02
Slave queue ID: 0
PING 192.168.255.1 (192.168.255.1) from 192.168.255.2 bond0: 56(84) bytes of data.
64 bytes from 192.168.255.1: icmp_seq=1 ttl=64 time=4.93 ms
64 bytes from 192.168.255.1: icmp_seq=2 ttl=64 time=8.55 ms
64 bytes from 192.168.255.1: icmp_seq=3 ttl=64 time=23.0 ms

--- 192.168.255.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2010ms
rtt min/avg/max/mdev = 4.931/12.166/23.020/7.815 ms
=== Восстанавливаем линк ===
PING 192.168.255.2 (192.168.255.2) from 192.168.255.1 bond0: 56(84) bytes of data.
64 bytes from 192.168.255.2: icmp_seq=1 ttl=64 time=26.2 ms
64 bytes from 192.168.255.2: icmp_seq=2 ttl=64 time=7.76 ms
64 bytes from 192.168.255.2: icmp_seq=3 ttl=64 time=8.79 ms

--- 192.168.255.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2011ms
rtt min/avg/max/mdev = 7.764/14.252/26.199/8.458 ms
```
