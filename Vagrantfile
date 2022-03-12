# to make sure the nodes are created in order, we
# have to force a --no-parallel execution.
ENV['VAGRANT_NO_PARALLEL'] = 'yes'

$router_ip_address = '10.100.100.254'
$node_ip_addresses = [
  '10.100.100.201',
  '10.100.100.202',
]

Vagrant.configure(2) do |config|
  config.vm.box = 'windows-2022-amd64'

  config.vm.provider 'libvirt' do |lv, config|
    lv.memory = 2*1024
    lv.cpus = 2
    lv.cpu_mode = 'host-passthrough'
    lv.nested = false # nested virtualization.
    lv.keymap = 'pt'
    config.vm.synced_folder '.', '/vagrant', type: 'smb', smb_username: ENV['USER'], smb_password: ENV['VAGRANT_SMB_PASSWORD']
  end

  config.vm.define 'router' do |config|
    config.vm.hostname = 'router'
    config.vm.network :private_network,
      ip: $router_ip_address,
      libvirt__forward_mode: 'none',
      libvirt__dhcp_enabled: false
    config.vm.provision "shell", path: "provision/ps.ps1", args: "provision-network-interface-names.ps1"
    provision_common(config)
    config.vm.provision "shell", path: "provision/ps.ps1", args: "provision-router.ps1"
  end

  $node_ip_addresses.each_with_index do |ip_address, n|
    vm_name = "node#{n+1}"
    config.vm.define vm_name do |config|
      config.vm.hostname = vm_name
      config.vm.network :private_network,
        ip: ip_address,
        libvirt__forward_mode: 'none',
        libvirt__dhcp_enabled: false
      config.vm.provision "shell", path: "provision/ps.ps1", args: "provision-network-interface-names.ps1"
      config.vm.provision "shell", path: "provision/ps.ps1", args: ["provision-default-gateway.ps1", $router_ip_address]
      provision_common(config)
    end
  end
end

def provision_common(config)
  config.vm.provision "shell", path: "provision/ps.ps1", args: "locale.ps1"
  config.vm.provision "shell", inline: "$env:chocolateyVersion='0.12.1'; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))", name: "Install Chocolatey"
  config.vm.provision "shell", path: "provision/ps.ps1", args: "provision-google-chrome.ps1"
  config.vm.provision "shell", path: "provision/ps.ps1", args: "provision-wireshark.ps1"
end
