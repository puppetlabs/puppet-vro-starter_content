class profile::master::yum_repository {
  include local_yum_repo::dependencies

  $mirror_dirs = [
    '/opt/tse-files',
    '/opt/tse-files/mirrors/',
    '/opt/tse-files/mirrors/centos',
    '/opt/tse-files/mirrors/centos/6',
    '/opt/tse-files/mirrors/centos/6/x86_64',
    '/opt/tse-files/mirrors/centos/7',
    '/opt/tse-files/mirrors/centos/7/x86_64',
  ]

  file { $mirror_dirs:
    ensure => directory,
  }

  $centos6_x64_packages = [
    'tomcat6-docs-webapp',
    'tomcat6-webapps',
    'tomcat6',
    'fontconfig',
    'dejavu-fonts-common',
    'java',
    'java-1.7.0-openjdk',
    'java-1.7.0-openjdk-devel',
    'tomcat6-admin-webapps',
  ]

  $centos6_x64_packages.each |$package| {
    local_yum_repo::package { "${package}.el6.x86_64":
      directory    => '/opt/tse-files/mirrors/centos/6/x86_64',
      package_name => $package,
      releasever   => '6',
      basearch     => 'x86_64',
    }
  }

#  $centos7_x64_packages = [
#    'java',
#  ]

#  $centos7_x64_packages.each |$package| {
#    local_yum_repo::package { "${package}.el7.x86_64":
#      directory    => '/opt/tse-files/mirrors/centos/7/x86_64',
#      package_name => $package,
#      releasever   => '7',
#      basearch     => 'x86_64',
#    }
#  }

}
