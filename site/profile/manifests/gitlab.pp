class profile::gitlab {
  include profile::firewall
  
  firewall { '100 allow https':
    proto  => 'tcp',
    dport  => '443',
    action => 'accept',
  }

  #Install gitlab
  file { ['/etc/gitlab', '/etc/gitlab/ssl'] :
    ensure => directory,
  }

  file { "/etc/gitlab/ssl/${::fqdn}.key" :
    ensure => file,
    source => "${::settings::privatekeydir}/${::trusted['certname']}.pem",
    notify => Exec['gitlab_reconfigure'],
  }

  file { "/etc/gitlab/ssl/${::fqdn}.crt" :
    ensure => file,
    source => "${::settings::certdir}/${::trusted['certname']}.pem",
    notify => Exec['gitlab_reconfigure'],
  }

  class { 'gitlab':
    external_url => hiera( 'gms_server_url', "https://${::fqdn}") ,
    require      => File["/etc/gitlab/ssl/${::fqdn}.key", "/etc/gitlab/ssl/${::fqdn}.key"],
  }

  #Initialize gitlab
  file { '/etc/gitlab/init.sh':
    ensure  => file,
    mode    => '0700',
    owner   => root,
    group   => root,
    content => epp('profile/gitlab-init.sh.epp', { 'gitlab_server' => $clientcert } ),
    require => Class['gitlab'],
  }

  remote_file { '/etc/gitlab/pe-demo-repos.tar.gz':
    ensure => present,
    source => "http://${::settings::server}/pe-demo-repos.tar.gz",
  }

  exec { '/etc/gitlab/init.sh && touch /etc/gitlab/init':
    creates => '/etc/gitlab/init',
    require => [
      Remote_file['/etc/gitlab/pe-demo-repos.tar.gz'],
      File['/etc/gitlab/init.sh'],
    ],
  }
}
