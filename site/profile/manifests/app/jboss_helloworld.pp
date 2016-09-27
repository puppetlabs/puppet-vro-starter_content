class profile::app::jboss_helloworld (
  $source = 'https://s3-us-west-2.amazonaws.com/tseteam/files/jboss-helloworld.war'
) {
  wildfly::deployment { 'jboss-helloworld.war':
    source   => $source,
  }
}
