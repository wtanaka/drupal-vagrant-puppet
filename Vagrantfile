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

   config.vm.share_folder("vagrant-root", "/vagrant", ".",
         :extra => "dmode=775")
end

