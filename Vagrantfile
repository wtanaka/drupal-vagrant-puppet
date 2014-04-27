Vagrant::Config.run do |config|
   config.vm.provision :shell, :path => "priv/puppetmodule.sh"
   config.vm.provision :shell, :path => "priv/oldubuntu.sh"
   config.vm.forward_port 80, 5432, :name => "http", :auto => true

   config.vm.provision :puppet do |puppet|
      puppet.options = ["--templatedir",
         "/tmp/vagrant-puppet/manifests",
         "--environment",
         "vagrant"]
   end

   config.vm.define :myproject do |myproject|
      myproject.vm.host_name = "myproject"
      myproject.vm.box = "lucid32"
      myproject.vm.box_url = "http://files.vagrantup.com/lucid32.box"
   end

   config.vm.share_folder("v-root", "/vagrant", ".",
         :extra => "dmode=775")
end

