class profile::razor::esxi6 {
  require razordemo

  razor_repo { 'esxi6_repo':
    ensure  => present,
    iso_url => 'https://s3-us-west-2.amazonaws.com/tse-builds/razor-images/VMware-VMvisor-Installer-6.0.0.update01-3029758.x86_64.iso',
    task    => 'vmware_esxi',
  }

  razor_policy { 'esxi6_policy':
    ensure        => 'present',
    repo          => 'esxi6_repo',
    task          => 'vmware_esxi',
    broker        => 'puppet-enterprise',
    hostname      => 'esxi-razor${id}',
    root_password => 'puppet',
    max_count     => 20,
    node_metadata => {},
    tags          => ['virtual'],
  }
}
