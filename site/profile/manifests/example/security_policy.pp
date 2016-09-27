# Example of a baseline security policy based on a real life customer requirement
# Tested on Centos 6
class profile::example::security_policy {
  service { 'iptables':
    ensure => stopped,
    enable => false,
  }
  user { 'secmgr':
    ensure   => present,
    password => '$1$5MHNlTvS$agM4g7DCvjGuJ9vCdjm5E0', # Clear text also supported, value is 'password'
    uid      => '505',
    shell    => '/bin/bash',
  }
  class { 'login_defs':
    options => {
      'PASS_MIN_DAYS'   => '0',
      'PASS_MAX_DAYS'   => '30',
      'PASS_MIN_LEN'    => '8',
      'PASS_WARN_AGE'   => '7',
     },
  }
  class { 'motd':
    content => "############################################################################
# IT IS AN OFFENSE TO CONTINUE WITHOUT PROPER AUTHORIZATION.               #
# this system is restricted to authorized users. Individuals attempting    #
# unauthorized access will be prosecuted.If unauthorized terminate access  #
# now!                                                                     #
############################################################################
",
  }
  sshd_config { 'PermitRootLogin':
    ensure => present,
    value  => 'no',
    notify => Service['sshd'],
  }
  sshd_config { 'PrintMotd':
    ensure => present,
    value  => 'yes',
    notify => Service['sshd'],
  }
  service { 'sshd':
    ensure => running,
  }
  pam { "Set cracklib limits in password-auth":
    ensure    => present,
    service   => 'password-auth',
    type      => 'password',
    module    => 'pam_cracklib.so',
    arguments => ['try_first_pass','retry=3', 'minlen=8', 'lcredit=-1', 'ucredit=-1', 'dcredit=-1', 'ocredit=-1', 'remember=10'],
  }
  file_line { 'login-timeout-1':
    ensure => present,
    path   => '/etc/profile',
    line   => 'export TMOUT=600',
  }
  file_line { 'login-timeout-2':
    ensure => present,
    path   => '/etc/profile',
    line   => 'typeset -r TMOUT',
  }
}
