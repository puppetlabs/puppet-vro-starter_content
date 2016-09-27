class profile::windows::applications (
  Variant[Boolean, Enum['true', 'false', 'installed', 'absent']]
    $firefox = false,
    $notepadpp = false,
) {

case $firefox {
    'true','installed',true,installed: {
           $firefox_status = installed
         }
    'false',false,'absent',absent: {
           $firefox_status = absent
         }
  }

case $notepadpp {
    'true','installed',true,installed: {
           $notepadpp_status = installed
         }
    'false',false,'absent',absent: {
           $notepadpp_status = absent
         }
  }

  #require registry
  contain 'chocolatey'


  reboot { 'before install':
    when => pending,
  }

  Package {
#    ensure   => installed,
    provider => chocolatey,
    require => Class['chocolatey'],
  }

  package { 'firefox':
    ensure => $firefox_status,
 }

  package { 'notepadplusplus':
    ensure => $notepadpp_status,
 }
 # package { 'notepadplusplus': }
 # package { '7zip': }
 # package { 'git': }

}
