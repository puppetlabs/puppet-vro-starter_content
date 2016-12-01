# vro_plugin_sshd
#


#### Table of Contents

1. [Description](#description)
2. [What is managed](#what)
3. [Requirements](#requirements)


## Description

This module manages the /etc/ssh/sshd_config file to enable a few key options.

## What
These are the options that are changed/managed

* PermitRootLogin = yes
    * (If you are using root then enable root login, else use vro-plugin_user created by vro-plugin_user.)
* PasswordAuthentication = yes
* ChallengeResponseAuthentication = no

## Requirements

* puppetlabs/stdlib (>= 3.2.0 <5.0.0) - https://forge.puppet.com/puppetlabs/stdlib

* Augeas bindings are installed and working as normal.
  * mod 'augeasproviders_core',
  :git => 'https://github.com/hercules-team/augeasproviders_core.git',

* Augeas Providers for SSH
  * mod 'augeasproviders_ssh',
  :git => 'https://github.com/hercules-team/augeasproviders_ssh.git',
