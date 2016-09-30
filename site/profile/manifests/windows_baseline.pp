#
class profile::windows_baseline {

  include chocolatey

  package { 'unzip':
    ensure   => installed,
    provider => chocolatey,
  }
  
}
