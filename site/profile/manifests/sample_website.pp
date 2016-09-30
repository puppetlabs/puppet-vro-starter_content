#
class profile::sample_website {

  case $::kernel {
    'windows': {
      staging::deploy { 'sample_website.zip':
        source  => 'puppet:///modules/profile/sample_website.zip',
        target  => 'C:\inetpub\wwwroot\sample_website',
        require => Iis::Manage_site[$::fqdn],
        creates => 'C:\inetpub\wwwroot\sample_website\index.html',
      }
    }
    'linux':   {
      staging::deploy { 'sample_website.zip':
        source  => 'puppet:///modules/profile/sample_website.zip',
        target  => '/var/www/sample_website',
        require => Apache::Vhost[$::fqdn],
        creates => '/var/www/sample_website/index.html',
      }
    }
    default: { }
  }

}
