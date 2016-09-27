class profile::master::files::pe_demo_repos {
  require profile::master::fileserver

  # Because the /opt/tse-files directory is loaded on persistent shared storage
  # in some of our deployments, we just make sure the persistent storage
  # contains a link to the local, non-shared data file.
  file { '/opt/tse-files/pe-demo-repos.tar.gz':
    ensure => symlink,
    target => '/opt/pe-demo-repos.tar.gz',
    force  => true,
  }

  # Creates and serves a tarball containing all of the git repositories used to
  # bootstrap the master. This will be consumed later by a gitlab server when
  # it is configured.
  exec { "ensure repos tarball" :
    cwd     => "/opt/puppetlabs",
    command => "/bin/tar -czf /opt/pe-demo-repos.tar.gz repos",
    creates => "/opt/pe-demo-repos.tar.gz",
  }

}
