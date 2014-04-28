#!/bin/sh
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
# This file installs puppet modules necessary for the project
mkdir -p /etc/puppet/modules
(puppet module list | grep puppetlabs-mysql) ||
   puppet module install -v 2.1.0 puppetlabs/mysql
(puppet module list | grep jamtur01-puppet-apache-modules) ||
   puppet module install -v 0.0.1 jamtur01-apachemodules
(puppet module list | grep wtanaka-mkdir) ||
   puppet module install -v 0.0.2 wtanaka-mkdir
