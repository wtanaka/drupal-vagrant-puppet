if Vagrant::VERSION.start_with?('1.0.')
   # Vagrant versions older than 1.1 use a file for .vagrant -- if a
   # newer version of Vagrant has upgraded that to a directory,
   # running vagrant up will create an orphan VM that can't be halted
   # or destroyed through Vagrant
   if File.directory?(File.dirname(__FILE__) + "/.vagrant")
      $stderr.puts "Vagrant 1.0.x does not support .vagrant as a "\
         "directory.  If you do not have any virtual machines running "\
         "on other computers, you can delete the .vagrant directory "\
         "and try again."
      Process.exit(false)
   end
end

Vagrant::Config.run do |config|
   config.vm.provision :shell, :path => "priv/puppetmodule.sh"

   config.vm.define :lucid do |lucid|
      lucid.vm.provision :shell, :path => "priv/oldubuntu.sh"
      lucid.vm.host_name = "drupal-lucid"
      lucid.vm.box = "lucid32"
      lucid.vm.box_url = "http://files.vagrantup.com/lucid32.box"
   end

   config.vm.define :precise do |precise|
      precise.vm.host_name = "drupal-precise"
      precise.vm.box = "precise32"
      precise.vm.box_url = "http://files.vagrantup.com/precise32.box"
   end

   config.vm.provision :puppet do |puppet|
      puppet.options = ["--templatedir",
         "/tmp/vagrant-puppet/manifests",
         "--environment",
         "vagrant"]
   end

   config.vm.forward_port 80, 5432, :name => "http", :auto => true
   config.vm.share_folder("vagrant-root", "/vagrant", ".",
         :extra => "dmode=775")
end

