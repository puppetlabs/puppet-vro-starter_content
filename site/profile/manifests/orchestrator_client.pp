class profile::orchestrator_client {

  $puppet_conf = $::kernel ? {
    'windows' => 'C:/ProgramData/PuppetLabs/puppet/etc/puppet.conf',
    default   => '/etc/puppetlabs/puppet/puppet.conf',
  }

  ini_setting { 'puppet agent use_cached_catalog':
    ensure  => present,
    path    => $puppet_conf,
    section => 'agent',
    setting => 'use_cached_catalog',
    value   => 'true',
  }

  ini_setting { 'puppet agent pluginsync':
    ensure  => present,
    path    => $puppet_conf,
    section => 'agent',
    setting => 'pluginsync',
    value   => 'false',
  }

}
