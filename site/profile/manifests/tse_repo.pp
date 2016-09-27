class profile::tse_repo {

  $releasever = $::os['release']['major']
  $basearch   = $::os['architecture']

  yumrepo { 'tse-repo':
    baseurl  => "http://${::servername}/mirrors/centos/${releasever}/${basearch}",
    descr    => 'TSE Cached Files',
    enabled  => 1,
    gpgcheck => 1,
    gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${releasever}",
  }
}
