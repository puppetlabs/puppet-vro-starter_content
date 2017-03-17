# This profile installs the Apache webserver
#
# @summary Apache webserver
class profile::apache {

  class { 'apache':
    default_vhost => false,
  }

}
