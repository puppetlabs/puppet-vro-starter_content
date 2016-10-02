#
class profile::sample_website {

  case $::kernel {
    'windows': {
#      staging::deploy { 'sample_website.zip':
#        source  => 'puppet:///modules/profile/sample_website.zip',
#        target  => 'C:\inetpub\wwwroot\sample_website',
#        require => [ Iis::Manage_site[$::fqdn], Package['unzip'] ],
#        creates => 'C:\inetpub\wwwroot\sample_website\index.html',
#      }
      file { 'C:\sample_website.zip':
        ensure => file,
        source  => 'puppet:///modules/profile/sample_website.zip',
      }

      unzip { 'sample_website.zip':
        source      => 'C:\sample_website.zip',
        destination => 'C:\inetpub\wwwroot\sample_website',
        creates     => 'C:\inetpub\wwwroot\sample_website\index.html',
      }
    }
    'linux':   {
      staging::deploy { 'sample_website.zip':
        source  => 'puppet:///modules/profile/sample_website.zip',
        target  => '/var/www/sample_website',
        require => [ Apache::Vhost[$::fqdn], Package['unzip'] ],
        creates => '/var/www/sample_website/index.html',
      }
    }
    default: { }
  }

}
