# This profile provides minimum configuation for a Linux server
#
# @summary Linux server baseline
class profile::linux_baseline {

  package { 'unzip':
    ensure => installed,
  }

  package { 'git':
    ensure => installed,
  }

}
