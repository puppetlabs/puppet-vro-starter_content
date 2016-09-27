# Include a default set of pre and post firewall rules. This class is
# implemented using stages in order to ensure that you will be able to declare
# firewall rules in other classes and be assured proper order configuration of
# the firewall without ever accidentally cutting off connectivity (even
# temporarily).
class profile::firewall {
  include stdlib::stages

  case $::osfamily {
    default: {

      class { '::firewall':                stage => 'setup'  }
      class { '::profile::firewall::pre':  stage => 'setup'  }
      class { '::profile::firewall::post': stage => 'deploy' }

      resources { 'firewall':
        purge => true,
      }

    }
    'windows', 'Solaris': {
      warning("osfamily ${::osfamily} not supported by profile::firewall")
    }
  }

}
