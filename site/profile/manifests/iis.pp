#
class profile::iis {

  $doc_root = 'C:\inetpub\wwwroot\sample_website'

  windowsfeature { 'IIS':
    feature_name => [
      'Web-Server',
      'Web-WebServer',
      'Web-Http-Redirect',
      'Web-Mgmt-Console',
      'Web-Mgmt-Tools',
    ],
  }

  iis::manage_site {'Default Web Site':
    ensure => absent,
  }

  iis::manage_app_pool {'sample_website':
    require => [
      Windowsfeature['IIS'],
      Iis::Manage_site['Default Web Site'],
    ],
  }

  iis::manage_site { $::fqdn:
    site_path  => $doc_root,
    port       => '80',
    ip_address => '*',
    app_pool   => 'sample_website',
    require    => [
      Windowsfeature['IIS'],
      Iis::Manage_app_pool['sample_website']
    ],
  }

  windows_firewall::exception { 'WINRM':
    ensure       => present,
    direction    => 'in',
    action       => 'Allow',
    enabled      => 'yes',
    protocol     => 'TCP',
    local_port   => '80',
    display_name => 'HTTP Inbound',
    description  => 'Inbound rule for HTTP Server - Port 80',
  }

}
