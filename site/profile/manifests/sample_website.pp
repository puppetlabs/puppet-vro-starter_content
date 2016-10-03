#
class profile::sample_website {

  case $::kernel {
    'windows': {      
      $staging_dir = 'C:\staging'

      file { $staging_dir:
        ensure => directory,
      }
      file { "${staging_dir}\\sample_website.zip":
        ensure => file,
        source  => 'puppet:///modules/profile/sample_website.zip',
      }
      unzip { 'sample_website.zip':
        source      => "${staging_dir}\\sample_website.zip",
        destination => 'C:\inetpub\wwwroot\sample_website',
        creates     => 'C:\inetpub\wwwroot\sample_website\index.html',
      }
    }
    'linux':   {
      staging::deploy { 'sample_website.zip':
        source  => 'puppet:///modules/profile/sample_website.zip',
        target  => '/var/www/sample_website',
        creates => '/var/www/sample_website/index.html',
      }
    }
    default: { }
  }

}
