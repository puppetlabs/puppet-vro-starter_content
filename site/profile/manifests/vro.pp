#
class profile::vro_provisioned {

  # ensure that the csr_attributes.yaml file containing the shared
  # autosign secret is removed on the first puppet agent run.
  file { "${settings::confdir}/csr_attributes.yaml":
    ensure => absent,
    backup => false,
  }

  # any operating system-specific state for vro-provisioned machines.
  # it's common to change the Administrator user name on Windows, for example.
  case $kernel {
    'Linux': {}
    'windows': {
      exec { 'rename-admin':
        command  => '$(Get-WMIObject Win32_UserAccount -Filter "Name=\'Administrator\'").Rename("puppet#adm1n")',
        unless   => 'if (Get-WmiObject Win32_UserAccount -Filter "Name=\'Administrator\'") { exit 1 }',
        provider => powershell,
      }
    }
    default: {}
  }

}
