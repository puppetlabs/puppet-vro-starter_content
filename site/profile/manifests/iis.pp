#
class profile::iis {

  $doc_root = $profile::sample_website::doc_root
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

  iis::manage_app_pool {'sample_website':
    require => [
      Windowsfeature[$iis_features],
      Iis::Manage_site['Default Web Site'],
    ],
  }

  iis::manage_site { $::fqdn:
    site_path  => $doc_root,
    port       => "${webserver_port}",
    ip_address => '*',
    app_pool   => 'sample_website',
    require    => [
      Windowsfeature[$iis_features],
      Iis::Manage_app_pool['sample_website']
    ],
  }

  windows_firewall::exception { 'WINRM':
    ensure       => present,
    direction    => 'in',
    action       => 'Allow',
    enabled      => 'yes',
    protocol     => 'TCP',
    local_port   => "${webserver_port}",
    display_name => 'HTTP Inbound',
    description  => 'Inbound rule for HTTP Server',
  }

}
