class profile::master::files::tomcat (
  $srv_root = '/opt/tse-files',
) {

  $directories = [
    "${srv_root}/tomcat",
    "${srv_root}/war",
    "${srv_root}/war/1.400",
    "${srv_root}/war/1.449",
    "${srv_root}/war/1.525",
    "${srv_root}/war/latest",
  ]

  Remote_file {
    require => File[$directories],
    mode    => '0644',
  }

  file { $directories:
    ensure => directory,
    mode   => '0755',
  }

  remote_file { 'apache-tomcat-6.0.44.tar.gz':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/apache-tomcat-6.0.44.tar.gz',
    path   => "${srv_root}/tomcat/apache-tomcat-6.0.44.tar.gz",
  }
  remote_file { 'apache-tomcat-7.0.64.tar.gz':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/apache-tomcat-7.0.64.tar.gz',
    path   => "${srv_root}/tomcat/apache-tomcat-7.0.64.tar.gz",
  }
  remote_file { 'apache-tomcat-8.0.26.tar.gz':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/apache-tomcat-8.0.26.tar.gz',
    path   => "${srv_root}/tomcat/apache-tomcat-8.0.26.tar.gz",
  }
  remote_file { 'apache-tomcat-6.0.44.exe':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/apache-tomcat-6.0.44.exe',
    path   => "${srv_root}/tomcat/apache-tomcat-6.0.44.exe",
  }
  remote_file { 'apache-tomcat-7.0.64.exe':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/apache-tomcat-7.0.64.exe',
    path   => "${srv_root}/tomcat/apache-tomcat-7.0.64.exe",
  }
  remote_file { 'apache-tomcat-8.0.26.exe':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/apache-tomcat-8.0.26.exe',
    path   => "${srv_root}/tomcat/apache-tomcat-8.0.26.exe",
  }
  remote_file { 'jenkins-1.400.war':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/jenkins-1.400.war',
    path   => "${srv_root}/war/1.400/jenkins.war",
  }
  remote_file { 'jenkins-1.449.war':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/jenkins-1.449.war',
    path   => "${srv_root}/war/1.449/jenkins.war",
  }
  remote_file { 'jenkins-1.525.war':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/jenkins-1.525.war',
    path   => "${srv_root}/war/1.525/jenkins.war",
  }
  remote_file { 'jenkins-latest.war':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/jenkins-latest.war',
    path   => "${srv_root}/war/latest/jenkins.war",
  }
  remote_file { 'sample-1.0.war':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/sample-1.0.war',
    path   => "${srv_root}/tomcat/plsample-1.0.war",
  }
  remote_file { 'sample-1.2.war':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/sample-1.2.war',
    path   => "${srv_root}/tomcat/plsample-1.2.war",
  }
}
