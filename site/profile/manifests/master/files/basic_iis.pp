# App files for profile::app::basic_iis
class profile::master::files::basic_iis (
  $srv_root = '/opt/tse-files',
) {

  $directories = [
    "${srv_root}/app",
  ]

  Remote_file {
    require => File[$directories],
    mode    => '0644',
  }

  file { $directories:
    ensure => directory,
    mode   => '0755',
  }

  # App files for profile::app::basic_iis
  remote_file { 'app-1.0.0.zip':
    source => 'https://s3.amazonaws.com/saleseng/files/app/app-1.0.0.zip',
    path   => "${srv_root}/app/app-1.0.0.zip",
  }
  remote_file { 'app-1.0.1.zip':
    source => 'https://s3.amazonaws.com/saleseng/files/app/app-1.0.1.zip',
    path   => "${srv_root}/app/app-1.0.1.zip",
  }

}
