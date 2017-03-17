# This profile provides minimum configuration for Windows servers
#
# @summary Windows server baseline 
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
