Vagrant.configure('2') do |config|
  config.vm.provider "virtualbox" do |vb|
     vb.customize ["createhd", "--filename", "disk.vdi", "--size", "1024"]
     vb.customize ["storageattach", :id, "--storagectl", "IDE Controller", "--medium", "disk.vdi", "--port", "0", "--device", "1", "--type", "hdd"]
  end

  config.vm.provision "shell", inline: "pvcreate /dev/sdb && vgcreate vg_scratch /dev/sdb"
end