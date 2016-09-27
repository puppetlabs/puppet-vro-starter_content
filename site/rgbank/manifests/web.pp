define rgbank::web (
  $db_name,
  $db_host,
  $db_user,
  $db_password,
  $listen_port = '8060',
  $install_dir = undef,
) {

  if $install_dir {
    $install_dir_real = $install_dir
  } else {
    $install_dir_real = "/opt/rgbank-${name}"
  }

  vcsrepo { "${install_dir_real}/wp-content/themes/rgbank":
    ensure   => present,
    source   => 'https://github.com/puppetlabs-pmmteam/rgbank.git',
    revision => 'b6c0c2c8597d549c66aa320216ea667e94f7ec9d',
    provider => git,
    require  => Wordpress::Instance::App["rgbank_${name}"],
    notify   => Service['httpd'],
  }

  wordpress::instance::app { "rgbank_${name}":
    install_dir          => $install_dir_real,
    install_url          => 'http://wordpress.org',
    version              => '4.3.1',
    db_host              => $db_host,
    db_name              => $db_name,
    db_user              => $db_user,
    db_password          => $db_password,
    wp_owner             => 'root',
    wp_group             => '0',
    wp_lang              => '',
    wp_config_content    => undef,
    wp_plugin_dir        => 'DEFAULT',
    wp_additional_config => 'DEFAULT',
    wp_table_prefix      => 'wp_',
    wp_proxy_host        => '',
    wp_proxy_port        => '',
    wp_multisite         => false,
    wp_site_domain       => '',
    wp_debug             => false,
    wp_debug_log         => false,
    wp_debug_display     => false,
    notify               => Service['httpd'],
  }

  file { "${install_dir_real}/wp-content/uploads":
    ensure  => directory,
    owner   => apache,
    group   => apache,
    recurse => true,
    require => Wordpress::Instance::App["rgbank_${name}"],
  }

  firewall { "000 accept rgbank web connections on ${listen_port}":
    dport  => $listen_port,
    proto  => tcp,
    action => accept,
  }

  apache::listen { $listen_port: }

  apache::vhost { $::fqdn:
    docroot => $install_dir_real,
    port    => $listen_port,
  }
}

Rgbank::Web produces Http {
  name => $name,
  ip   => $::networking['interfaces']['enp0s8']['ip'],
  port => $listen_port,
  host => $::hostname,
}

Rgbank::Web consumes Mysqldb {
  db_name     => $database,
  db_host     => $host,
  db_user     => $user,
  db_password => $password,
}
