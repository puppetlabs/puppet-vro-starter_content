# Installs apache and opens port in firewall
class profile::apache (
    $webserver_port
) {

  class { 'apache':
    default_vhost => false,
  }

  firewalld_port { 'Open port for web':
    ensure   => present,
    zone     => 'public',
    port     => $webserver_port,
    protocol => 'tcp',
  }

}
