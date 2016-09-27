class profile::linux::selinux {
  include stdlib

  class { 'profile::linux::selinux::setup':
    stage => 'setup',
  }

  reboot { 'selinux':
    apply     => finished,
    subscribe => Class['profile::linux::selinux::setup'],
  }

}
