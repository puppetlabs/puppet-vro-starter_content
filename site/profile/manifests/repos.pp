# this is the offline class, it gets applied to all agents
# and ensures they are able to work with local on networks
class profile::repos (
  Boolean $offline = false,
) {
  include stdlib::stages

  case "$::osfamily $::operatingsystemmajrelease" {
    "RedHat 6": {
      class { '::profile::tse_repo':
        stage => 'setup',
      }
      if $offline {
        class { '::profile::el6_repo_disabled':
          stage => 'setup',
        }
      }
    }
  }
}
