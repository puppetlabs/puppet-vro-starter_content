class profile::master::files::dotnetcms (
  $srv_root = '/opt/tse-files',
) {

  $directories = [
    "${srv_root}/dotnetcms",
    "${srv_root}/7zip",
  ]

  Remote_file {
    require => File[$directories],
    mode    => '0644',
  }

  file { $directories:
    ensure => directory,
    mode   => '0755',
  }

  # dotnetcms
  remote_file { 'dotNetFx40_Full_x86_x64.exe':
    source => 'https://s3.amazonaws.com/saleseng/files/dotnetcms/dotNetFx40_Full_x86_x64.exe',
    path   => "${srv_root}/dotnetcms/dotNetFx40_Full_x86_x64.exe",
  }
  remote_file { 'CMS4.06.zip':
    source => 'https://s3.amazonaws.com/saleseng/files/dotnetcms/CMS4.06.zip',
    path   => "${srv_root}/dotnetcms/CMS4.06.zip",
  }

  # 7zip
  remote_file { '7z920-x64.msi':
    source => 'https://s3.amazonaws.com/saleseng/files/7zip/7z920-x64.msi',
    path   => "${srv_root}/7zip/7z920-x64.msi",
  }

}
