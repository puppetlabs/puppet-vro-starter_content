class profile::razor::centos67 {
  require razordemo

  razor_repo { 'centos67_repo':
    ensure  => present,
    iso_url => 'https://s3-us-west-2.amazonaws.com/tse-builds/razor-images/CentOS-6.7-x86_64-minimal.iso',
    task    => 'centos/6',
  }

  razor_policy { 'centos67_policy':
    ensure        => 'present',
    repo          => 'centos67_repo',
    task          => 'centos/6',
    broker        => 'puppet-enterprise',
    hostname      => 'centos-razor${id}',
    root_password => 'puppet',
    max_count     => 20,
    node_metadata => {},
    tags          => ['virtual'],
  }
}
