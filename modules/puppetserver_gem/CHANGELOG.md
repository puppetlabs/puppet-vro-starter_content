## 0.2.0
### Features:
This adds the ability to use install & uninstall options as in the parent provider.

## 2015-05-28 - 0.1.0
### Summary:
This module provides management of Ruby gems on puppet. This is the initial release 
of the puppetserver_gem it supersedes the module pe_puppetserver_gem. This module 
will support both FOSS and PE. With Puppet 4 the path to the puppetserver binary has
changed. 

### Notes:
To test manually against the default nodeset. Run the acceptance test as normal.
curl -O http://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb ; dpkg -i puppetlabs-release-pc1-trusty.deb
apt-get update
apt-get install puppetserver
optional, make sure that the puppetserver_gem is in the correct place
  cp -r /etc/puppet/modules/puppetserver_gem /etc/puppetlabs/code/environments/production/modules/
/opt/puppetlabs/bin/puppet apply apply_manifest.pp.****  
