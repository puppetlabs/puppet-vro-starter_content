#
class profile::linux_baseline {

  case $::osfamily {
    default: { } # for OS's not listed, do nothing
    'RedHat': {
      include epel
    }
  }

}
