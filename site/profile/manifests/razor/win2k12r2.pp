class profile::razor::win2k12r2 {
  require razordemo

  razor_repo { 'win2012r2_repo':
    ensure => present,
    iso_url => 'https://s3-us-west-2.amazonaws.com/tse-builds/razor-images/win2012r2_razor.iso',
    task => 'windows/2012r2'
  }

  razor_policy { 'win2012r2_policy':
    ensure        => 'present',
    repo          => 'win2012r2_repo',
    task          => 'windows/2012r2',
    broker        => 'puppet-enterprise',
    hostname      => 'win2012r2-${id}',
    root_password => 'puppet',
    max_count     => 20,
    node_metadata => {},
    tags          => ['virtual'],
  }

  class { 'samba::server':
    interfaces => "eth0 eth1",
    security   => 'share',
  }

  samba::server::share { 'razor':
    comment   => 'Windows Installers',
    path      => '/opt/puppetlabs/server/data/razor-server/repo',
    guest_ok  => true,
    writable  => false,
    browsable => true,
  }

  firewall { '100 Allow Samba TCP':
    proto  => 'tcp',
    port   => [139, 445],
    action => 'accept',
  }

  firewall { '110 Allow Samba UDP':
    proto  => 'udp',
    port   => [137, 138],
    action => 'accept',
  }

  package { 'unix2dos':
    ensure => present,
  }

}
