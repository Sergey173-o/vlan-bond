# Разворачивает Office1 и стенд VLAN/bonding в VirtualBox.
bond_mode = ENV.fetch("BOND_MODE", "active-backup")
unless ["active-backup", "802.3ad"].include?(bond_mode)
  abort "BOND_MODE: допустимы active-backup и 802.3ad"
end

bond_a = "vlanlab-router-a"
bond_b = bond_mode == "802.3ad" ? "vlanlab-router-b" : bond_a

machines = {
  "inetRouter" => {
    links: { "lab-a" => [bond_a, "020000361102"], "lab-b" => [bond_b, "020000361103"] },
    config: { bond_ip: "192.168.255.1/30" }
  },
  "centralRouter" => {
    links: { "lab-a" => [bond_a, "020000361202"], "lab-b" => [bond_b, "020000361203"],
             "office-uplink" => ["vlanlab-office1-central", "020000361204"] },
    config: { bond_ip: "192.168.255.2/30", office_ip: "192.168.255.9/30" }
  },
  "office1Router" => {
    links: { "office-uplink" => ["vlanlab-office1-central", "020000361302"] },
    config: { office_ip: "192.168.255.10/30" }
  },
  "testClient1" => {
    links: { "testlan" => ["vlanlab-testLAN", "020000362102"] },
    config: { vlan_id: 1, vlan_ip: "10.10.10.254/24" }
  },
  "testServer1" => {
    links: { "testlan" => ["vlanlab-testLAN", "020000362202"] },
    config: { vlan_id: 1, vlan_ip: "10.10.10.1/24" }
  },
  "testClient2" => {
    links: { "testlan" => ["vlanlab-testLAN", "020000363102"] },
    config: { vlan_id: 2, vlan_ip: "10.10.10.254/24" }
  },
  "testServer2" => {
    links: { "testlan" => ["vlanlab-testLAN", "020000363202"] },
    config: { vlan_id: 2, vlan_ip: "10.10.10.1/24" }
  }
}

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2204"
  config.vm.boot_timeout = 600
  config.vm.synced_folder ".", "/vagrant", disabled: true

  machines.each do |name, machine|
    config.vm.define name do |node|
      node.vm.hostname = name.downcase
      node.vm.provider "virtualbox" do |vb|
        vb.name = "vlan-bond-#{name}"
        vb.memory = 768
        vb.cpus = 1

        # Настраиваем только виртуальные кабели. IP задаёт Ansible.
        machine[:links].each_with_index do |(_link, (network, mac)), index|
          slot = index + 2
          vb.customize ["modifyvm", :id, "--nic#{slot}", "intnet",
                        "--intnet#{slot}", network, "--macaddress#{slot}", mac,
                        "--cableconnected#{slot}", "on"]
          if bond_mode == "802.3ad" && network.start_with?("vlanlab-router-")
            vb.customize ["modifyvm", :id, "--nicpromisc#{slot}", "allow-vms"]
          end
        end
      end

      node.vm.provision "ansible" do |ansible|
        ansible.playbook = "ansible/provision.yml"
        ansible.extra_vars = machine[:config].merge(
          bond_mode: bond_mode,
          lab_links: machine[:links].transform_values { |(_network, mac)| mac.scan(/../).join(":") }
        )
      end
    end
  end
end
