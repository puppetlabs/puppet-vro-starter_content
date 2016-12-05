# vRealize Automation Plugin Starter Content Pack

## Introduction 

This repository provides starter Puppet content for the [Puppet plugin for vRealize Automation](https://solutionexchange.vmware.com/admin/products/133777) (VRO and VRA). It shows you how Puppet code is organized to make self-provisioning easy and can create 5 different machine types out of the box:
- Linux base server
- Linux MySQL server
- Linux web server
- Windows base server
- Windows web server

Please see the [complete documentation](https://docs.puppet.com/pe/latest/vro_intro.html) for more information on how to install the Puppet plugin and use the content provided in this repository.

Installation with git
```
git clone https://github.com/puppetlabs/puppet-vro-starter_content.git
cd puppet-vro-starter_content
sudo bash scripts/vra_nc_setup.sh
```

Installation with curl
```
curl -sSL https://github.com/puppetlabs/puppet-vro-starter_content/archive/production.tar.gz | tar -zx
cd puppet-vro-starter_content-production
sudo bash scripts/vra_nc_setup.sh
```

Special thanks for creation and testing of this starter content go to Abir Majumdar, Tommy Speigner, Erik Dasher, Kai Pak, Tyler Pace, Garrett Guillotte, Colin Brock, Justin May, Bryan Jen, Lindsey Smith, Jeremy Adams and the whole Puppet TSE team.
