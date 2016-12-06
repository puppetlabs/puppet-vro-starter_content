# myfirewall

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)

## Overview

This module is meant to provide a simple interface to manage firewalld (currently)
and eventually iptables.

The module currently only supports RedHat (7) and Debian (14.04) family, but 
I am working to allow this module to work with other OSes.

## Module Description

This module provides a provider and type for the firewalld service.  Currently,
firewalld is the only firewall supported, however, I am in the process of creating
an iptables provider.

This module manages the firewalld service and configures the rules for the
firewall.

## Usage

###Create firewall rule for https service in public zone:

<pre>
myfirewall { 'Firewall Test':
    ensure          => present,
    name            => 'public',
    zone            => 'public',
    service         => 'https',
    permanent       => true,
   }
</pre>

###Adding a permanent port/protocol firewall rule in public zone:

<pre>
myfirewall { 'Firewall Rule':
    ensure     => present,
    name       => 'public',
    zone       => 'public',
    port       => '3000',
    protocol   => 'tcp',
    permanent  => true,
   }
</pre>

###Remove a service

<pre>
myfirewall { 'Second richrule':
    ensure     => absent,
    zone       => 'public',
    protocol   => 'tcp',
    port       => '1534',
    notify     =>  Exec['Reloading firewall rules'],
   }
</pre>

### Add firewall richrule:

<pre>
myfirewall { 'Firewall Rule':
    ensure     => present,
    zone       => 'public',
    richrule   => 'rule family="ipv4" source address="192.168.10.0/24" port port="3001" protocol="tcp" accept',
    permanent  => true,
   }
</pre>


### Add icmp message blocking:

<pre>
myfirewall { 'ICMP block echo-reply':
    ensure     => present,
    zone       => 'public',
    block_icmp => 'echo-reply',
    permanent  => true,
   }
</pre>

### Create a new zone
<pre>
myfirewall { 'Create a new zone':
    ensure       => present,
    zone         => 'testing',
    myzones      => true,
    permanent    => true,
    notify       =>  Exec['Reloading firewall rules'],
  }
</pre>

### Advanced example with heira:
This example will create multiple rules in the firewall
that will use only tcp.

### Adding multiple ports with a single protocol
<pre>
 myfirewall { 'Multiple ports':
    ensure     => present,
    zone       => 'public',
    port       => $myports,
    protocol   => 'tcp',
    notify     =>  Exec['Reloading firewall rules'],
   }
</pre>

### Use tcp_udp to add tcp and udp protocol for all ports:

<pre>
myfirewall { 'Multiple ports':
    ensure     => present,
    zone       => 'public',
    port       => $myports,
    tcp_udp    => true,
    notify     =>  Exec['Reloading firewall rules'],
   }
</pre>

## myfirewall/hieradata/test02.familyguy.local.yaml
<pre>
myfirewall::myports:
    - 53
    - 22
    - 21
    - 110
</pre>


### Example with multiple richrules:
<pre>
myfirewall { 'Multiple richrules':
    ensure     => present,
    zone       => 'public',
    richrule   => $myrichrules,
    notify     =>  Exec['Reloading firewall rules'],
   }
</pre>


## myfirewall/hieradata/test02.familyguy.local.yaml
<pre>
myfirewall::myrichrules: 
    - rule family="ipv4" source address="192.168.10.0/24" port port="3001" protocol="tcp" accept
    - rule family="ipv4" source address="192.168.10.0/24" port port="3051" protocol="tcp" accept
</pre>


### Add multiple icmp messages for blocking:

<pre>
myfirewall { 'ICMP block multiple messages':
    ensure     => present,
    zone       => 'public',
    block_icmp => $myicmpmessages, 
    permanent  => true,
   }
</pre>

## myfirewall/hieradata/test02.familyguy.local.yaml
<pre>
myfirewall::myicmpmessages: 
  - echo-reply
  - echo-request
</pre>

## Reference

The following providers and types are created within this module:

### Types and Providers
- `myfirewall`
- `firewalld`

## Limitations

Currently this module is compatible with RedHat (7) and Debian (14.04)family.  I am working on 
other OSes and will update this accordingly.  The module currently
supports the following options:

- `name`
- `zone` 
- `protocol` (tcp|udp)
- `tcp_udp` (true|false)
- `port` (allows string or array)
- `service` (allows string or array)
- `source` (192.168.1.0/24)
- `richrule` (allows string or array)
- `block_icmp` (allows string or array)
- `permanent` (true|false) if `false` myfirewall will only create a temporary rule
- `myzones` (true|false) `note: This option has to be used with the permanent => true`


### Issues

1. myzones for Debian systems may not work as the firewall-cmd command does not have
`--new-zone=` option.  However, if the firewall-cmd does have the `--new-zone` option
then it should work as normal.


### Vagrant setup

1.  git clone https://github.com/nohtyp/myfirewall.git
2.  cd into directory
3.  vagrant up test02
    * vagrant provision test02 (can be used to retest new options in your puppet manifest)

## Release Notes/Contributors/Etc
There seems to be a bug with using arrays for creating zones.  I will have to put a bug report
in with RH to see if there is truly an issue.
