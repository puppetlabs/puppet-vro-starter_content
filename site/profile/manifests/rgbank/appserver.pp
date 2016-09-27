class profile::rgbank::appserver {

  class { 'apache':
    default_vhost => false,
  }

  include apache::mod::php
  include git
  include mysql::bindings::php
  include mysql::client

  # Just make sure that Apache doesn't crash due to no vhosts being available
  file { '/etc/httpd/conf.d/50-default.conf':
    ensure  => file,
    mode    => '0644',
    content => 'Listen *:8050',
  }

}
