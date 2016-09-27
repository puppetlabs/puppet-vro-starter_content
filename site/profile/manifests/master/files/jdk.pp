class profile::master::files::jdk (
  $srv_root = '/opt/tse-files',
) {
  file { "${srv_root}/jdk":
    ensure => directory,
    mode   => '0755',
  }

  remote_file { 'jdk-8u45-windows-x64.exe':
    source  => 'http://download.oracle.com/otn-pub/java/jdk/8u45-b15/jdk-8u45-windows-x64.exe',
    path    => "${srv_root}/jdk/jdk-8u45-windows-x64.exe",
    headers => {
      'user-agent' => 'Mozilla/5.0 (Windows NT 6.3; Trident/7.0; rv:11.0) like Gecko',
      'Cookie'     => 'oraclelicense=accept-securebackup-cookie;gpw_e24=http://edelivery.oracle.com'
    }, # Oracle makes you accept the license agreement -_-
    mode    => '0644',
    require => File["${srv_root}/jdk"],
  }
}
