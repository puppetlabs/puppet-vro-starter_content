# vRO Starter Content Pack

## Introduction

This repository provides starter content for the Puppet plugin for VMware vRealize Orchestrator (vRO). Please see the [complete documentation](https://docs.puppet.com/pe/latest/vro_intro.html) for more information on how to install the Puppet plugin and use the content provided in this repository.

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

Special thanks to Abir Majumdar, Tommy Speigner, Jeremy Adams and the whole Puppet TSE team for inspiration and bulk of contributions.
