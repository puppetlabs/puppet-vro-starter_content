# The `puppetmaster` profile sets up a master system, synchronizes files from
# Amazon, and generally enables SE Team specific patterns dependent on master
# capabilities.
#
class profile::master::puppetserver {
  include 'git'
  contain 'profile::master::puppetserver::demo_user'
  contain 'profile::master::puppetserver::deploy_user'

  # Puppet master firewall rules
  Firewall {
    chain  => 'INPUT',
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '110 puppetmaster allow all': dport  => '8140';  }
  firewall { '110 console allow all':      dport  => '443';   }
  firewall { '110 mcollective allow all':  dport  => '61613'; }
  firewall { '110 pxp orch allow all':     dport  => '8142';  }

  ##################
  # Configure Puppet
  ##################

  class { 'hiera':
    datadir_manage => false,
    datadir        => '/etc/puppetlabs/code/environments/%{environment}/hieradata',
    eyaml          => true,
    hierarchy      => [
      'nodes/%{clientcert}',
      'environment/%{environment}',
      'datacenter/%{datacenter}',
      'virtual/%{virtual}',
      'common',
    ],
  }

  # We cannot simply set notify => Service['pe-puppetserver'] on Class['hiera']
  # because this profile is sometimes used by `puppet apply`, and other times
  # used in combination with pe-provided roles. So instead we'll collect the
  # service and add a subscribe relationship.
  Service <| title == 'pe-puppetserver' |> {
    subscribe => Class['hiera'],
  }

  # We have to manage this file like this because of ROAD-706
  $key = file('profile/license.key')
  exec { 'Create License':
    command => "/bin/echo \"${key}\" > /etc/puppetlabs/license.key",
    creates => '/etc/puppetlabs/license.key',
  }

  # Provide an environment command to automatically commit code from
  # code-staging and sync it to the live codedir. We can remove this command
  # when PE-15438 and CODEMGMT-697 are resolved.
  file { '/opt/puppetlabs/bin/puppet-code-commit':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '755',
    source => 'puppet:///modules/profile/puppet-code-commit',
  }

}
