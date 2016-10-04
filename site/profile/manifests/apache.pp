# Installs apache and opens port in firewall
class profile::apache {

  class { 'apache':
    default_vhost => false,
  }

}
