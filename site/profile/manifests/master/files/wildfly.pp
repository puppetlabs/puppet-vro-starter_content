class profile::master::files::wildfly (
  $srv_root = '/opt/tse-files',
) {

  $directories = [
    "${srv_root}/wildfly",
    "${srv_root}/jboss-helloworld",
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
  remote_file { 'jboss-helloworld.war':
    source => 'https://s3-us-west-2.amazonaws.com/tseteam/files/jboss-helloworld.war',
    path   => "${srv_root}/jboss-helloworld/jboss-helloworld.war",
  }
  remote_file { 'wildfly-8.0.0.Final.tar.gz':
    source => 'http://download.jboss.org/wildfly/8.0.0.Final/wildfly-8.0.0.Final.tar.gz',
    path   => "${srv_root}/wildfly/wildfly-8.0.0.Final.tar.gz",
  }

}
