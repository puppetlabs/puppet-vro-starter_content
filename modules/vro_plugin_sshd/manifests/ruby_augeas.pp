class vro_plugin_sshd::ruby_augeas {

## Install EPEL yum repo
## https://forge.puppet.com/stahnma/epel
## mod 'stahnma-epel', '1.2.2'
require epel

## Install ruby-augeas for use with augeasproviders_ssh
  package { 'ruby-augeas':
    ensure => 'installed',
  }

}
