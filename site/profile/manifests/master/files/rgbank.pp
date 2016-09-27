class profile::master::files::rgbank (
  $srv_root     = '/opt/tse-files',
  $download_src = 'https://s3.amazonaws.com/saleseng/files/demo',
  $rmt_file     = 'rgbank.tgz',
  $local_dir    = 'rgbank',
)
{
  $directories = [
    "${srv_root}/${local_dir}",
  ]

  file { $directories:
    ensure => directory,
    mode   => '0755',
  } ->

  remote_file { "${download_src}/${rmt_file}":
    source => "${download_src}/${rmt_file}",
    path   => "${srv_root}/${local_dir}/${rmt_file}",
  } ->

  file { "${srv_root}/${local_dir}/${rmt_file}":
    mode    => '0644',
    require => [ File[$directories], Remote_file["${download_src}/${rmt_file}"] ]
  }

}
