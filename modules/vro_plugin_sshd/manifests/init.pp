## Include augeasproviders_ssh module from forge or github.
#### https://forge.puppet.com/herculesteam/augeasproviders_ssh
## Include augeasproviders_core from forge or github.
#### https://github.com/hercules-team/augeasproviders_core

class vro_plugin_sshd {
  
  ## If you are using root then enable root login, else use vro-plugin_user created by vro-plugin.
  sshd_config { "PermitRootLogin":
    ensure => present,
    value  => "yes",
  }

## Allow PasswordAuthentication for users and not just keys

  sshd_config { "PasswordAuthentication":
    ensure    => present,
    value     => "yes",
  }

  sshd_config { "ChallengeResponseAuthentication":
    ensure    => present,
    value     => "no",

  }

}
