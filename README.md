# vRO Starter Content Pack

## Introduction

This repository provides starter content for the Puppet plugin for VMware vRealize Orchestrator (vRO). Please see the [complete documentation](https://docs.puppet.com/pe/latest/vro_intro.html) for more information on how to install the Puppet plugin and use the content provided in this repository.

## Installation with git
```
cd /etc/puppetlabs/code/environments/production; rm -rf *
git clone git@github.com:puppetlabs/puppet-vro-starter_content.git
```

## Installation with curl

For private repo's you need add `-u <GITHUB_USERNAME>:<GITHUB_PERSONAL_APITOKEN>` to the curl command. Get token from https://github.com/settings/tokens

```
rm -rf /etc/puppetlabs/code/environments/production/*
curl -sSL https://github.com/puppetlabs/puppet-vro-starter_content/archive/production.tar.gz | tar --strip-components 1 -zx -C /etc/puppetlabs/code/environments/production
```

Special thanks to Abir Majumdar, and the Puppet TSE team for inspiration and bulk of contributions.
Jeremy Adams was a more minor contributor but a major commit squasher.
