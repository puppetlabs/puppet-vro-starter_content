# Example generic iis app class
class profile::app::basic_iis (
  $version = 'app-1.0.0',
){
  $iis_app = 'C:\inetpub\wwwroot\iis_app'
  remote_file { 'app_files':
    ensure  => present,
    path    => "${iis_app}\\${version}.zip",
    source  => "http://master/app/${version}.zip",
    require => [ Iis::Manage_site[$::fqdn] ],
  }
  unzip { $version:
    source  => "${iis_app}\\${version}.zip",
    creates => "${iis_app}\\${version}\\index.html",
    require => Remote_file['app_files'],
  }

  windowsfeature { 'IIS':
    feature_name => [
      'Web-Server',
      'Web-WebServer',
      'Web-Http-Redirect',
      'Web-Mgmt-Console',
      'Web-Mgmt-Tools'
    ]
  }

  iis::manage_site {'Default Web Site':
    ensure => absent,
  }

  iis::manage_app_pool {'generic_website':
    require => [
      Windowsfeature['IIS'],
      Iis::Manage_site['Default Web Site'],
    ]
  }

  iis::manage_site { $::fqdn:
    site_path  => "${iis_app}\\${version}",
    port       => '80',
    ip_address => '*',
    app_pool   => 'generic_website',
    require    => [
                      Windowsfeature['IIS'],
                      Iis::Manage_app_pool['generic_website']
                    ]
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
