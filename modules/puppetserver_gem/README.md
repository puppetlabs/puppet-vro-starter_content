#puppetserver_gem module

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with ntp](#setup)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module provides management of Ruby gems for both PE and FOSS Puppet Server. It supercedes the deprecated pe_puppetserver_gem.

##Setup

###Usage
For PE Puppet Server:

    package { 'json':
      ensure   => present,
      provider => puppetserver_gem,
    }

This uses gem as a parent and uses `puppetserver gem` command for all gem operations.

##Reference

##Limitations

This module has been tested on PE and FOSS, and no issues have been identified.

##Development

Puppet Labs modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. We can’t access the huge number of platforms and myriad of hardware, software, and deployment configurations that Puppet is intended to serve.

We want to keep it as easy as possible to contribute changes so that our modules work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things.

For more information, see our [module contribution guide.](https://docs.puppetlabs.com/forge/contributing.html)

## Testing

At the minute, there is only an acceptance test for FOSS Puppet Server. 
