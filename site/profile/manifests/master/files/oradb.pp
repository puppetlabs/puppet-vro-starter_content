class profile::master::files::oradb (
  $srv_root     = '/opt/tse-files',
  $download_src = 'https://s3.amazonaws.com/saleseng/files/oracle',
)
{
  $directories = [
    "${srv_root}/oracle_db_install",
  ]

  file { $directories:
    ensure => directory,
    mode   => '0755',
  }

  $rmt_files = [
    'linuxamd64_12102_database_1of2.zip',
    'linuxamd64_12102_database_2of2.zip'
  ]

  $rmt_files.each |$r| {
    remote_file { $r:
      source  => "${download_src}/${r}",
      path    => "${srv_root}/oracle_db_install/${r}",
      mode    => '0644',
      require => File[$directories],
    }
  }

}
