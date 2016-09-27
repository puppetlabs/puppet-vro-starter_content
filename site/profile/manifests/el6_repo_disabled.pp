class profile::el6_repo_disabled {
  yumrepo { 'base':
    descr      => 'CentOS-$releasever - Base',
    gpgcheck   => '1',
    enabled    => '0',
    gpgkey     => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6',
    mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os',
  }
  yumrepo { 'extras':
    descr      => 'CentOS-$releasever - Extras',
    gpgcheck   => '1',
    enabled    => '0',
    gpgkey     => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6',
    mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras',
  }
  yumrepo { 'updates':
    descr      => 'CentOS-$releasever - Updates',
    gpgcheck   => '1',
    enabled    => '0',
    gpgkey     => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6',
    mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates',
  }
}
