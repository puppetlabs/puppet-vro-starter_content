class profile::app::jboss_helloworld {

  wildfly::deployment { 'jboss-helloworld.war':
    source   => 'puppet:///modules/profile/jboss-helloworld.war',
  }

}
