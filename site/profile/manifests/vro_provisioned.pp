# This profile manages any operating system-specific state for VRO-provisioned machines. It's common to change the Administrator user name on Windows, for example.
#
# @summary OS-specific configuration for VRO-provisioned machines
class profile::vro_provisioned {

  case $kernel {
    'Linux': {
      $agent_confdir = '/etc/puppetlabs/puppet'
    }
    'windows': {
      $agent_confdir = 'C:/ProgramData/PuppetLabs/puppet/etc'

      #exec { 'rename-Administrator':
      #  command   => '$(Get-WMIObject Win32_UserAccount -Filter "Name=\'Administrator\'").Rename("puppet#adm1n")',
      #  unless    => 'if (Get-WmiObject Win32_UserAccount -Filter "Name=\'Administrator\'") { exit 1 }',
      #  provider  => powershell,
      #}

    }
    default: {}
  }

  # ensure that the csr_attributes.yaml file containing the shared
  # autosign secret is removed on the first puppet agent run.
  file { "${agent_confdir}/csr_attributes.yaml":
    ensure => absent,
    backup => false,
  }

}
