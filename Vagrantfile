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

drupal_ver = ENV['DRUPAL'].to_i
if !([6, 7].include?(drupal_ver))
   $stderr.puts "Neither DRUPAL=6 nor DRUPAL=7 was set in environment.  "\
      "Assuming Drupal 7."
   drupal_ver = 7
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

   config.vm.define :trusty do |trusty|
      trusty.vm.host_name = "drupal-trusty"
      trusty.vm.box = "trusty32"
      trusty.vm.box_url =\
        "http://cloud-images.ubuntu.com/vagrant/trusty/"\
        "current/trusty-server-cloudimg-i386-vagrant-disk1.box"
   end

   config.vm.provision :puppet do |puppet|
      puppet.options = ["--templatedir",
         "/tmp/vagrant-puppet/manifests",
         "--environment",
         "vagrant"]
      puppet.facter = {
         'drupal_version' => drupal_ver
      }
   end

   config.vm.forward_port 80, 5432, :name => "http", :auto => true
   # Using "v-root" instead of "vagrant-root" causes a warning in
   # Vagrant 1.1, but is necessary for correct functioning of Vagrant
   # 1.0.x
   config.vm.share_folder("v-root", "/vagrant", ".", :extra => "dmode=775")
end

