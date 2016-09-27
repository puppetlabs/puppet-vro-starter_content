class profile::app::jenkins_original (
  $version = 'latest',
  $ensure  = undef,
  $package = undef,
) {
  include profile::tomcat
  include profile::staging

  $version_string = $version ? {
    undef    => '-unspecified',
    'latest' => '-unspecified',
    default  => "-${version}",
  }

  # This directory is used by the Jenkins app, and should exist
  file { "${tomcat::params::user_homedir}/.jenkins":
    ensure => directory,
    owner  => $tomcat::params::user,
    group  => $tomcat::params::group,
    mode   => '0750',
    before => Tomcat::War['jenkins'],
  }

  # The Jenkins app should be deployed
  tomcat::war { 'jenkins':
    ensure  => $ensure,
    warfile => "jenkins${version_string}.war",
    source  => "http://${::servername}/war/${version}/jenkins.war",
  }

}
