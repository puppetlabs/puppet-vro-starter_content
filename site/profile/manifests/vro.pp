#
class profile::vro {

  case $kernel {
    'Linux': {
      file { '/etc/puppetlabs/puppet/csr_attributes.yaml':
        ensure => absent,
      }
    }
    'windows': { }
    default: {}
  }

}
