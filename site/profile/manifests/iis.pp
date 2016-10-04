# Installs iis and opens port in firewall
class profile::iis (
  $webserver_port
) {

  $iis_features = [
    'Web-Server',
    'Web-WebServer',
    'Web-Http-Redirect',
    'Web-Mgmt-Console',
    'Web-Mgmt-Tools'
  ]

  windowsfeature { $iis_features:
    ensure => present,
  }

  iis::manage_site {'Default Web Site':
    ensure => absent,
  }

  windows_firewall::exception { 'WINRM':
    ensure       => present,
    direction    => 'in',
    action       => 'Allow',
    enabled      => 'yes',
    protocol     => 'TCP',
    local_port   => '$webserver_port',
    display_name => 'HTTP Inbound',
    description  => 'Inbound rule for HTTP Server',
  }

}
