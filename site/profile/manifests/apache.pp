# Installs apache
class profile::apache {

  class { 'apache':
    default_vhost => false,
  }

}
