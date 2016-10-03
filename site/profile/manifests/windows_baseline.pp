#
class profile::windows_baseline {

  include chocolatey
  
  package { 'unzip':
    ensure   => installed,
    provider => chocolatey,
  }
      
  package { 'git':
    ensure   => installed,
    provider => chocolatey,
  }

}
