#
class profile::linux_baseline {

  package { 'unzip':
    ensure => installed,
  }

  package { 'git':
    ensure => installed,
  }

}
