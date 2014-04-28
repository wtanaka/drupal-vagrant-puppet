# Copyright 2014 Wesley Tanaka <http://wtanaka.com/>
#
# This file is part of drupal-vagrant-puppet
# <http://wtanaka.com/drupal/vagrant-puppet>
#
# drupal-vagrant-puppet is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# drupal-vagrant-puppet is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
#
# This file edits /etc/apt/sources.list to make apt-get update work on
# unsupported Ubuntu releases like 10.04
#
$project_name = 'myproject'
$path_to_project = "/path/to/${project_name}"
$path_to_project_parents = all_parents($path_to_project)
# Vagrant-specific variables
$path_to_settings_file = "/vagrant/pub/sites/localhost/settings.php"
$settings_directories = all_parents($path_to_settings_file)

case $operatingsystem {
   Ubuntu: {
      if versioncmp($operatingsystemrelease, '12.04') > 0 {
         $apache_version = '2.4'
      }
      else {
         $apache_version = '2.2'
      }
   }
   default: { $apache_version = '2.2' }
}

exec { 'apt-update':
   command => '/usr/bin/apt-get update'
}

Exec['apt-update'] -> Package <| |>

host { $project_name:
   ensure => 'present',
   ip => '127.0.0.1',
}

case $environment {
   vagrant: { $server_name = "${project_name}.com" }
   default: { $server_name = "${project_name}.com" }
}

case $environment {
   vagrant: {
      file { $path_to_project_parents:
         ensure => 'directory',
         mode => 775,
      }
      file { $path_to_project:
         ensure => 'link',
         target => '/vagrant',
      }

      file { $settings_directories:
         ensure => 'directory',
         mode => 775,
      }
      file { $path_to_settings_file:
         ensure => 'present',
         content => template('localhost-settings.php.erb'),
      }

      user { 'www-data':
         groups => ['vagrant'],
      }
   }
}

# Install MySQL, add database, database user, and PHP bindings

class { '::mysql::server':
   databases => {
      "${project_name}" => {
         ensure  => 'present',
         charset => 'utf8',
      },
   },

   users => {
      "${project_name}@localhost" => {
         ensure => 'present',
         password_hash => '*2470C0C06DEE42FD1618BB99005ADCA2EC9D1E19',
      },
   },

   grants => {
      "${project_name}@localhost/${project_name}.*" => {
         ensure => 'present',
         privileges => ['ALL'],
         table => "${project_name}.*",
         user => "${project_name}@localhost",
      },
   },
}

# Install MySQL PHP bindings

class { '::mysql::bindings':
   php_enable => true,
}

# Install Apache and virtualhost

package { 'apache2':
   ensure => 'present',
}

file { "/etc/apache2/sites-available/${project_name}.conf":
   ensure => 'present',
   content => template('virtualhost.conf.erb'),
   require => Package['apache2'],
}

exec { "/usr/sbin/a2ensite ${project_name}.conf":
   subscribe => File["/etc/apache2/sites-available/${project_name}.conf"],
}

service { 'apache2':
   ensure => running,
   enable => true,
   subscribe => Exec["/usr/sbin/a2ensite ${project_name}.conf"],
}

# Install Apache mod_rewrite needed for clean URLs

a2mod { 'rewrite':
  ensure => present,
}

# Install Apache PHP bindings

package { 'libapache2-mod-php5':
   ensure => 'present',
}

# Install MTA, needed for sending email

package { 'exim4':
   ensure => 'present',
}

# Install GD library for PHP

package { 'php5-gd':
   ensure => 'present',
}

# Create files/ directory needed for file uploads

file { "${path_to_project}/pub/files":
   ensure => 'directory',
}
