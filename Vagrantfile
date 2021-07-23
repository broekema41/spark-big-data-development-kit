# Enable the experimental disks feature
ENV['VAGRANT_EXPERIMENTAL'] = 'disks'

# Set vagrant resources dynamically with default values
$virtualbox_name = "dev-spark"
$amount_cpu = 4
$amount_mem = 10240
$nfsver = 4

Vagrant.configure("2") do |config|
  # Base box definitions
  config.vm.box = "ilionx/centos7-minikube"
  config.vm.box_version = "1.3.2-20210616"
  config.vm.box_check_update = true
  config.vm.hostname = $virtualbox_name

  # Add an extra disk for the Docker container storage in direct-lvm mode
  config.vm.disk :disk, size: "20GB", name: "docker_storage"

  # Virtualbox specific settings
  config.vm.provider "virtualbox" do |vb|
    # CPU and memory settings
    vb.cpus = $amount_cpu
    vb.memory = $amount_mem

    # Make sure the VirtualBox clock remains in sync, full paranoia mode
    # (Stolen from: https://gist.github.com/aboutte/f4adcbfc33cc7309791e0d21102c3d38)
    vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-interval", 10000 ]
    vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-min-adjust", 100 ]
    vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-on-restore", 1 ]
    vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-start", 1 ]
    vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]

    # Fixes bug with audio stack on MacOS
    vb.customize [ "modifyvm", :id, "--audio", "null", "--audioin", "off", "--audioout", "off" ]

    # Fixes bug with video stack on MacOS
    vb.customize [ "modifyvm", :id, '--graphicscontroller', 'vmsvga' ]
    vb.customize [ "modifyvm", :id, '--vram', '20' ]

    # Use NAT host DNS resolver to fix potential DHCP issues
    vb.customize [ "modifyvm", :id, "--natdnshostresolver1", "on" ]

    vb.name = config.vm.hostname
  end

  config.vm.network "private_network", ip: "172.28.127.137"
  config.vm.network "forwarded_port", guest: 7077, host: 7077 # spark master port in not http or proxyable

  # Mount repos of supported projects
  config.vm.synced_folder "..", "/projects", type: "nfs", nfs_version: $nfsver, mount_options: [ "nolock", "fsc" ]
  config.vm.synced_folder "/var/www/spark-big-data-development-kit/getting-started-spark-app/", "/var/www/spark-big-data-development-kit/getting-started-spark-app/", type: "nfs", nfs_version: $nfsver, mount_options: [ "nolock", "fsc" ]

  # Provision using ansible playbook, ansible should be installed on the image already
  config.vm.provision :ansible_local do |ansible|
    ansible.playbook = "/vagrant/provisioning/provision.yml"
    ansible.install = false
    ansible.compatibility_mode = "2.0"
    ansible.become = true
  end

  # On-boot provisioning using ansible playbook, ansible should be installed on the image already
  config.vm.provision 'ansible', run: 'always', type: :ansible_local do |ansible|
    ansible.playbook = "/vagrant/provisioning/on-boot-provision.yml"
    ansible.install = false
    ansible.compatibility_mode = "2.0"
    # This provisioning block should NOT run as root, as it sets values for the vagrant user.
    # If you need on-boot stuff to be done as root, add another on-boot provisioning block below here.
    ansible.become = false
  end

  # Make sure we have a clean Vagrant ssh session. By pointing to a different (empty) file
  config.ssh.config = ".empty_ssh_config"
end
