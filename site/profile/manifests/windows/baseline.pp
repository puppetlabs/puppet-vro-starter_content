class profile::windows::baseline {
  include chocolatey

  reboot { 'baseline reboot for pending':
    when => pending,
  }

  Package {
    ensure   => installed,
    provider => chocolatey,
    require  => Class['chocolatey'],
  }

  package { 'Firefox': }

  package { 'notepadplusplus': }

  package { '7zip': }

  package { 'git': }

}
