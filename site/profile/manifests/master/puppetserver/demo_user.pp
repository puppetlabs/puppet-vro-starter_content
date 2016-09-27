class profile::master::puppetserver::demo_user (
  String $demo_username = 'demo',
  String $demo_password = 'puppetlabs',
  String $demo_password_hash = '$1$Fq9vkV1h$4oMRtIjjjAhi6XQVSH6.Y.', #puppetlabs
  String $demo_home_dir = "/home/${demo_username}",
  String $demo_key_dir = "${demo_home_dir}/.ssh",
  String $demo_key_file = "${demo_key_dir}/id.rsa",
  String $demo_token_dir = "${demo_home_dir}/.puppetlabs",
  String $demo_token_file = "${demo_token_dir}/token",
  String $root_token_dir = '/root/.puppetlabs',
  String $root_token_file = "${root_token_dir}/token",
) {
  # demo user's ssh keys
  file { $demo_key_dir:
    ensure => directory,
    owner  => $demo_username,
    group  => $demo_username,
    mode   => '0700',
    require => File[$demo_home_dir],
  }

  exec { "create ${demo_username} ssh key":
    command => "/usr/bin/ssh-keygen -t rsa -b 2048 -C '${demo_username}' -f ${demo_key_file} -q -N ''",
    creates => $demo_key_file,
    require => File[$demo_key_dir],
  }

  # private key
  file { $demo_key_file:
    ensure  => file,
    owner   => $demo_username,
    group   => $demo_username,
    mode    => '0600',
    require => Exec["create ${demo_username} ssh key"],
  }

  # public key
  file { "${demo_key_file}.pub":
    ensure  => file,
    owner   => $demo_username,
    group   => $demo_username,
    mode    => '0644',
    require => Exec["create ${demo_username} ssh key"],
  }

  $ruby_mk_demo_user = epp('profile/create_user_role.rb.epp', {
    'username'    => $demo_username,
    'password'    => $demo_password,
    'rolename'    => 'Orchestration and Code Management',
    'touchfile'   => '/opt/puppetlabs/puppet/cache/tse_demo_user_created',
    'permissions' => [
      { 'action'      => 'deploy_code',
        'instance'    => '*',
        'object_type' => 'environment',
      },
      { 'action'      => 'override_lifetime',
        'instance'    => '*',
        'object_type' => 'tokens',
      },
      { 'action'      => 'use',
        'instance'    => '*',
        'object_type' => 'orchestration',
      },
    ],
  })

  exec { 'create demo user and role':
    command => "/opt/puppetlabs/puppet/bin/ruby -e ${shellquote($ruby_mk_demo_user)}",
    creates => '/opt/puppetlabs/puppet/cache/tse_demo_user_created',
  }

  # The puppet-access command will create any needed directories and make root their owner. So for the demo and deploy users we have to run the command
  # first and then manage the ownership later so pe-puppet can read during template file() function evaluation.
  exec { "create ${demo_username} rbac token":
    command => "/bin/echo ${shellquote($demo_password)} | \
                  /opt/puppetlabs/bin/puppet-access login \
                  --username ${demo_username} \
                  --service-url https://${clientcert}:4433/rbac-api \
                  --lifetime 1y \
                  --token-file ${demo_token_file}",
    creates => $demo_token_file,
    require => Exec['create demo user and role'],
  }

  user { $demo_username:
    ensure   => present,
    home     => $demo_home_dir,
    shell    => '/bin/bash',
    password => $demo_password_hash,
    require  => Exec["create ${demo_username} rbac token"],
  }

  file { $demo_home_dir:
    ensure  => directory,
    owner   => $demo_username,
    group   => $demo_username,
    require => User[$demo_username],
  }

  file { "${demo_home_dir}/.profile":
    ensure  => file,
    require => File[$demo_home_dir],
    owner   => $demo_username,
    group   => $demo_username,
    content => epp('profile/demo_user_dotprofile.epp', {
      'demo_key_file' => $demo_key_file
    }),
  }

  file { $demo_token_dir:
    ensure  => directory,
    owner   => $demo_username,
    group   => $demo_username,
    require => File[$demo_home_dir],
  }

  file { $demo_token_file:
    ensure  => file,
    owner   => $demo_username,
    group   => $demo_username,
    mode    => '0600',
    require => Exec["create ${demo_username} rbac token"],
  }

  file { $root_token_dir:
    ensure  => directory,
    owner   => root,
    group   => root,
    require => Exec["create ${demo_username} rbac token"],
  }

  file { $root_token_file:
    ensure => link,
    target => $demo_token_file,
  }
}
