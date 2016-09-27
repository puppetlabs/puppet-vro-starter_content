#
# This profile is intended to set a common platform for all nodes in the
# environment. As soon as there is a "one-off" node that needs to not have some
# configuration that's defined in here, then that configuration isn't common
# and shouldn't be here.
#
class profile::common {

  case $::osfamily {
    default: { } # for OS's not listed, do nothing
    'RedHat': {
      include epel
    }
  }

}
