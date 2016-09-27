# This class is intended to be declared to run in the setup stage
class profile::linux::selinux::setup {

  ini_setting { 'selinux':
    ensure            => present,
    path              => '/etc/selinux/config',
    section           => '',
    setting           => 'SELINUX',
    value             => 'disabled',
    key_val_separator => '=',
  }

  exec { 'ensure selinux not enforcing':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    command => 'setenforce Permissive',
    unless  => 'getenforce | grep -i disabled',
    require => Ini_setting['selinux'],
    notify  => Reboot['selinux'],
  }

}
