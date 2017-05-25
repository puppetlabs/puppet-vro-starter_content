##/vro_plugin_user/manifests/vro-plugin-user.pp
## VRO Plugin user gets created here as well as assigned RBAC privileges,
## as well as the /etc/sudoers.d/vro-plugin-user file, with the allowed
## and disallowed commands required to manage/purge node certificates.

class vro_plugin_user (
  String $vro_plugin_user = 'vro-plugin-user',
  String $vro_password = 'puppetlabs',
  String $vro_password_hash = '$1$Fq9vkV1h$4oMRtIjjjAhi6XQVSH6.Y.', #puppetlabs
 ){

  $ruby_mk_vro_plugin_user = epp('vro_plugin_user/create_user_role.rb.epp', {
    'username'    => $vro_plugin_user,
    'password'    => $vro_password,
    'rolename'    => 'VRO Plugin User',
    'touchfile'   => '/opt/puppetlabs/puppet/cache/vro_plugin_user_created',
    'permissions' => [
      { 'action'      => 'view_data',
        'instance'    => '*',
        'object_type' => 'nodes',
      },
    ],
  })

  exec { 'create vro user and role':
    command => "/opt/puppetlabs/puppet/bin/ruby -e ${shellquote($ruby_mk_vro_plugin_user)}",
    creates => '/opt/puppetlabs/puppet/cache/vro_plugin_user_created',
  }

##Create system user.

  user { $vro_plugin_user:
    ensure     => present,
    shell      => '/bin/bash',
    password   => $vro_password_hash,
    managehome => true,
  }

## Manage /etc/sudoers.d/vro-plugin-user file.  This allows and disallows sudo commands.

  file { '/etc/sudoers.d/vro-plugin-user':
    ensure  => file,
    mode    => '0440',
    owner   => 'root',
    group   => 'root',
    content => epp('vro_plugin_user/vro_sudoer_file.epp'),
  }
}
