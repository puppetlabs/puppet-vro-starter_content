#
class profile::windows_baseline {

  include chocolatey

  package { 'git':
    ensure   => installed,
    provider => chocolatey,
  }

}
