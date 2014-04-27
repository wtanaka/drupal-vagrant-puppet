Vagrant for Drupal using Puppet
===============================

See [Vagrant Puppet setup for Drupal homepage](
http://wtanaka.com/drupal/vagrant-puppet) for up to date instructions.

1. `wget -O - http://ftp.drupal.org/files/projects/drupal-6.31.tar.gz |
gzip -dc | tar xvf -`
2. `mv drupal-6.31 pub`
3. Either: `vagrant up precise`   OR   `vagrant up lucid`
4. Visit `http://localhost:5432/install.php`
