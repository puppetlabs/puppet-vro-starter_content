#
class profile::linux_baseline {

  package { 'unzip':
    ensure => present,
  }

  case $::osfamily {
    default: { } # for OS's not listed, do nothing
    'RedHat': {
      include epel
    }
  }

}
