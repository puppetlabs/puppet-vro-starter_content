[![Puppet Forge Version](http://img.shields.io/puppetforge/v/herculesteam/augeasproviders_ssh.svg)](https://forge.puppetlabs.com/herculesteam/augeasproviders_ssh)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/herculesteam/augeasproviders_ssh.svg)](https://forge.puppetlabs.com/herculesteam/augeasproviders_ssh)
[![Puppet Forge Endorsement](https://img.shields.io/puppetforge/e/herculesteam/augeasproviders_ssh.svg)](https://forge.puppetlabs.com/herculesteam/augeasproviders_ssh)
[![Build Status](https://img.shields.io/travis/hercules-team/augeasproviders_ssh/master.svg)](https://travis-ci.org/hercules-team/augeasproviders_ssh)
[![Coverage Status](https://img.shields.io/coveralls/hercules-team/augeasproviders_ssh.svg)](https://coveralls.io/r/hercules-team/augeasproviders_ssh)
[![Gemnasium](https://img.shields.io/gemnasium/hercules-team/augeasproviders_ssh.svg)](https://gemnasium.com/hercules-team/augeasproviders_ssh)


# ssh: type/provider for ssh files for Puppet

This module provides a new type/provider for Puppet to read and modify ssh
config files using the Augeas configuration library.

The advantage of using Augeas over the default Puppet `parsedfile`
implementations is that Augeas will go to great lengths to preserve file
formatting and comments, while also failing safely when needed.

This provider will hide *all* of the Augeas commands etc., you don't need to
know anything about Augeas to make use of it.

## Requirements

Ensure both Augeas and ruby-augeas 0.3.0+ bindings are installed and working as
normal.

See [Puppet/Augeas pre-requisites](http://docs.puppetlabs.com/guides/augeas.html#pre-requisites).

## Installing

On Puppet 2.7.14+, the module can be installed easily ([documentation](http://docs.puppetlabs.com/puppet/latest/reference/modules_installing.html)):

    puppet module install herculesteam/augeasproviders_ssh

You may see an error similar to this on Puppet 2.x ([#13858](http://projects.puppetlabs.com/issues/13858)):

    Error 400 on SERVER: Puppet::Parser::AST::Resource failed with error ArgumentError: Invalid resource type `sshd_config` at ...

Ensure the module is present in your puppetmaster's own environment (it doesn't
have to use it) and that the master has pluginsync enabled.  Run the agent on
the puppetmaster to cause the custom types to be synced to its local libdir
(`puppet master --configprint libdir`) and then restart the puppetmaster so it
loads them.

## Compatibility

### Puppet versions

Minimum of Puppet 2.7.

### Augeas versions

Augeas Versions           | 0.10.0  | 1.0.0   | 1.1.0   | 1.2.0   |
:-------------------------|:-------:|:-------:|:-------:|:-------:|
**FEATURES**              |
case-insensitive keys     | no      | **yes** | **yes** | **yes** |
**PROVIDERS**             |
ssh\_config               | **yes** | **yes** | **yes** | **yes** |
sshd\_config              | **yes** | **yes** | **yes** | **yes** |
sshd\_config\_match       | **yes** | **yes** | **yes** | **yes** |
sshd\_config\_subsystem   | **yes** | **yes** | **yes** | **yes** |
sshkey                    | **yes** | **yes** | **yes** | **yes** |

## Documentation and examples

Type documentation can be generated with `puppet doc -r type` or viewed on the
[Puppet Forge page](http://forge.puppetlabs.com/herculesteam/augeasproviders_ssh).

### ssh_config provider

#### manage simple entry

    ssh_config { "ForwardAgent":
      ensure => present,
      value  => "yes",
    }

#### manage array entry

    ssh_config { "SendEnv":
      ensure => present,
      value  => ["LC_*", "LANG"],
    }

#### manage entry for a specific host

    ssh_config { "X11Forwarding":
      ensure    => present,
      host      => "example.net",
      value     => "yes",
    }

#### manage entries with same name for different hosts

    ssh_config { "ForwardAgent global":
      ensure => present,
      key    => "ForwardAgent",
      value  => "no",
    }

    ssh_config { "ForwardAgent on example.net":
      ensure    => present,
      key       => "ForwardAgent",
      host      => "example.net",
      value     => "yes",
    }

#### delete entry

    ssh_config { "HashKnownHosts":
      ensure => absent,
    }

    ssh_config { "BatchMode":
      ensure    => absent,
      host      => "example.net",
    }

#### manage entry in another ssh_config location

    ssh_config { "CheckHostIP":
      ensure => present,
      value  => "yes",
      target => "/etc/ssh/another_sshd_config",
    }

### sshd_config provider

#### manage simple entry

    sshd_config { "PermitRootLogin":
      ensure => present,
      value  => "yes",
    }

#### manage array entry

    sshd_config { "AllowGroups":
      ensure => present,
      value  => ["sshgroups", "admins"],
    }

#### manage entry in a Match block

    sshd_config { "X11Forwarding":
      ensure    => present,
      condition => "Host foo User root",
      value     => "yes",
    }

    sshd_config { "AllowAgentForwarding":
      ensure    => present,
      condition => "Host *.example.net",
      value     => "yes",
    }

#### manage entries with same name in different blocks

    sshd_config { "X11Forwarding global":
      ensure => present,
      key    => "X11Forwarding",
      value  => "no",
    }

    sshd_config { "X11Forwarding foo":
      ensure    => present,
      key       => "X11Forwarding",
      condition => "User foo",
      value     => "yes",
    }

    sshd_config { "X11Forwarding root":
      ensure    => present,
      key       => "X11Forwarding",
      condition => "User root",
      value     => "no",
    }

#### delete entry

    sshd_config { "PermitRootLogin":
      ensure => absent,
    }

    sshd_config { "AllowAgentForwarding":
      ensure    => absent,
      condition => "Host *.example.net User *",
    }

#### manage entry in another sshd_config location

    sshd_config { "PermitRootLogin":
      ensure => present,
      value  => "yes",
      target => "/etc/ssh/another_sshd_config",
    }

### sshd_config_match provider

#### manage entry

    sshd_config_match { "Host *.example.net":
      ensure => present,
    }

#### manage entry with position

    sshd_config_match { "Host *.example.net":
      ensure   => present,
      position => "before first match",
    }

    sshd_config_match { "User foo":
      ensure   => present,
      position => "after Host *.example.net",
    }

#### delete entry

    sshd_config_match { "User foo Host *.example.net":
      ensure => absent,
    }

#### manage entry in another sshd_config location

    sshd_config_match { "Host *.example.net":
      ensure => present,
      target => "/etc/ssh/another_sshd_config",
    }

### sshd_config_subsystem provider

#### manage entry

    sshd_config_subsystem { "sftp":
      ensure  => present,
      command => "/usr/lib/openssh/sftp-server",
    }

#### delete entry

    sshd_config_subsystem { "sftp":
      ensure => absent,
    }

#### manage entry in another sshd_config location

    sshd_config_subsystem { "sftp":
      ensure  => present,
      command => "/usr/lib/openssh/sftp-server",
      target  => "/etc/ssh/another_sshd_config",
    }

### sshkey provider

#### manage entry

    sshkey { "foo.example.com":
      ensure  => present,
      type    => "ssh-rsa",
      key     => "AAADEADMEAT",
    }

#### manage entry with aliases

    sshkey { "foo.example.com":
      ensure       => present,
      type         => "ssh-rsa",
      key          => "AAADEADMEAT",
      host_aliases => [ 'foo', '192.168.0.1' ],
    }

#### manage hashed entry

    sshkey { "foo.example.com":
      ensure        => present,
      type          => "ssh-rsa",
      key           => "AAADEADMEAT",
      hash_hostname => true,
    }

#### hash existing entry

    sshkey { "foo.example.com":
      ensure        => hashed,
      type          => "ssh-rsa",
      key           => "AAADEADMEAT",
      hash_hostname => true,
    }

#### delete entry

    sshkey { "foo.example.com":
      ensure => absent,
    }

#### manage entry in another ssh_known_hosts location

    sshkey { "foo.example.com":
      ensure  => present,
      type    => "ssh-rsa",
      key     => "AAADEADMEAT",
      target  => "/root/.ssh/known_hosts",
    }

## Issues

Please file any issues or suggestions [on GitHub](https://github.com/hercules-team/augeasproviders_ssh/issues).
