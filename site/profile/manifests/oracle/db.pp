# See Doc
class profile::oracle::db {
  $install_type        = hiera('oracle_install_type', 'EE')
  $install_version     = hiera('oracle_install_version', '12.1.0.2')
  $oracle_base         = hiera('oracle_base', '/oracle')
  $oracle_home         = hiera('oracle_home', '/oracle/product/12.1/db')
  $ora_data_loc        = hiera('oracle_data_loc', '/oracle/oradata')
  $ora_rec_area_loc    = hiera('oracle_recovery_loc',
                          '/oracle/flash_recovery_area')
  $install_file_prefix = hiera('oracle_install_file_prefix',
                          'linuxamd64_12102_database')
  $download_dir        = hiera('oracle_download_dir', '/install')
  $download_src        = hiera('oracle_download_src',
                          'http://master.inf.puppet.vm/oracle_db_install')
  $ora_groups          = hiera('oracle_groups', ['oinstall','dba' ,'oper'])
  $ora_gid             = hiera('oracle_gid', 'oinstall')
  $ora_user            = hiera('oracle_user', 'oracle')
  $ora_passwd          = hiera('oracle_passwd',
                          '$1$F5Wa7ShT$.Fw8FDdwHLY8027fYIQGE0')
  $ora_sys_passwd      = hiera('oracle_sys_password', 'default')
  $ora_sid             = hiera('oracle_sid', $::hostname)
  $ora_db_name         = hiera('oracle_db_name', 'TESTDB')
  $ora_domain          = hiera('oracle_domain', $::domain)
  $ora_compatible      = hiera('oracle_compatbile', '')
  $install             = [  'binutils.x86_64', 'compat-libstdc++-33.x86_64',
                            'glibc.x86_64','ksh.x86_64',
                            'libaio.x86_64', 'compat-libcap1.x86_64',
                            'libgcc.x86_64','libstdc++.x86_64','make.x86_64',
                            'gcc.x86_64','gcc-c++.x86_64',
                            'glibc-devel.x86_64','libaio-devel.x86_64',
                            'libstdc++-devel.x86_64',
                            'sysstat.x86_64','unixODBC-devel',
                            'glibc.i686','libXext.x86_64','libXtst.x86_64',
                            'unzip'
                          ]

  # Defaults
  Sysctl {
    ensure => 'present',
    permanent => 'yes',
  }

  # Check ora_db_name, can't exceed 8 chars
  validate_slength($ora_db_name, 8)

  # Set Short Version
  $version_array = split($install_version, '[.]')
  $short_version = "${version_array[0]}.${version_array[1]}"

  # Setup User/group
  group { $ora_groups :
    ensure => present,
  }

  user { $ora_user:
    ensure     => present,
    gid        => $ora_gid,
    groups     => $ora_groups,
    shell      => '/bin/bash',
    password   => $ora_passwd,
    home       => '/home/oracle',
    managehome => true,
  }

  # Ensure download path exists
  file{$download_dir:
    ensure => directory,
    owner  => $ora_user,
    group  => $ora_gid,
    mode   => '0755',
  }

  # Download Files
  $dwn_files = [
    "${install_file_prefix}_1of2.zip",
    "${install_file_prefix}_2of2.zip"
  ]

  $dwn_files.each |$f| {
    remote_file { $f:
      source => "${download_src}/${f}",
      path   => "${download_dir}/${f}",
    }

    file { "${download_dir}/${f}":
      owner   => $ora_user,
      group   => $ora_gid,
      mode    => '0644',
      require => Remote_file[$f],
    }
  }

  sysctl {
    'kernel.msgmnb':
      value => '65536';
    'kernel.msgmax':
      value => '65536';
    'kernel.shmmax':
      value => '2588483584';
    'kernel.shmall':
      value => '2097152';
    'fs.file-max':
      value => '6815744';
    'net.ipv4.tcp_keepalive_time':
      value => '1800';
    'net.ipv4.tcp_keepalive_intvl':
      value => '30';
    'net.ipv4.tcp_keepalive_probes':
      value => '5';
    'net.ipv4.tcp_fin_timeout':
      value => '30';
    'kernel.shmmni':
      value => '4096';
    'fs.aio-max-nr':
      value => '1048576';
    'kernel.sem':
      value => '250 32000 100 128';
    'net.ipv4.ip_local_port_range':
      value => '9000 65500';
    'net.core.rmem_default':
      value => '262144';
    'net.core.rmem_max':
      value => '4194304';
    'net.core.wmem_default':
      value => '262144';
    'net.core.wmem_max':
      value => '1048576';
  }

  # Set Req Limits for Oracle installation/operation
  limits::fragment {
    '*/soft/nofile':
      value => '2048';
    '*/hard/nofile':
      value => '8192';
    "${ora_user}/soft/nofile":
      value => '65536';
    "${ora_user}/hard/nofile":
      value => '65536';
    "${ora_user}/soft/nproc":
      value => '2048';
    "${ora_user}/hard/nproc":
      value => '16384';
    "${ora_user}/soft/stack":
      value => '10240';
  }

  package { $install:
    ensure  => present,
  }

  oradb::installdb{ "${install_version}-${install_file_prefix}":
    version                   => $install_version,
    file                      => $install_file_prefix,
    database_type             => $install_type,
    oracle_base               => $oracle_base,
    oracle_home               => $oracle_home,
    bash_profile              => true,
    user                      => $ora_user,
    group                     => $ora_gid,
    group_install             => $ora_gid,
    group_oper                => $ora_gid,
    download_dir              => $download_dir,
    zip_extract               => true,
    remote_file               => false,
    puppet_download_mnt_point => $download_dir,
  }

  oradb::net{ 'config net8':
    oracle_home  => $oracle_home,
    version      => $short_version,
    user         => $ora_user,
    group        => $ora_gid,
    download_dir => $download_dir,
    db_port      => '1521',
  }

  file {"${oracle_home}/dbs/init${ora_sid}.ora":
    ensure  => present,
    owner   => $ora_user,
    group   => $ora_gid,
    mode    => '0640',
    content => template('profile/oracle/init.ora.erb'),
  }

  oradb::database{ "${ora_db_name}_create":
    oracle_base               => $oracle_base,
    oracle_home               => $oracle_home,
    version                   => '12.1', # Param
    user                      => $ora_user,
    group                     => 'dba',
    download_dir              => $download_dir,
    action                    => 'create',
    db_name                   => $ora_db_name,
    db_domain                 => $ora_domain,
    db_port                   => '1521',
    sys_password              => $ora_sys_passwd,
    system_password           => $ora_sys_passwd,
    data_file_destination     => $ora_data_loc,
    recovery_area_destination => $ora_rec_area_loc,
    character_set             => 'AL32UTF8',
    nationalcharacter_set     => 'UTF8',
    init_params               => {'open_cursors'        => '1000',
                                  'processes'           => '600',
                                  'job_queue_processes' => '4',
                                },
    sample_schema             => 'TRUE',
    memory_percentage         => '40',
    memory_total              => '800',
    database_type             => 'MULTIPURPOSE',
    em_configuration          => 'NONE',
  }

  oradb::tnsnames{$ora_db_name:
    oracle_home          => $oracle_home,
    user                 => $ora_user,
    group                => $ora_gid,
    server               => {
      "${ora_db_name}" =>
          {
            host     => $::fqdn,
            port     => '1521',
            protocol => 'TCP'
          }
    },
    connect_service_name => $::fqdn,
    connect_server       => 'DEDICATED',
  }

  oradb::autostartdatabase {"${ora_db_name}_autostart":
    oracle_home => $oracle_home,
    db_name     => $ora_db_name,
    user        => $ora_user,
  }

  db_control{"${ora_db_name}_start":
    ensure                  => 'running',
    instance_name           => $ora_db_name,
    oracle_product_home_dir => $oracle_home,
    os_user                 => $ora_user,
  }

User[$ora_user]
  -> File[$download_dir]
  -> Remote_file["${install_file_prefix}_1of2.zip"]
  -> Remote_file["${install_file_prefix}_2of2.zip"]
  -> Sysctl <| |>
  -> Limits::Fragment <| |>
  -> Package[$install]
  -> Oradb::Installdb["${install_version}-${install_file_prefix}"]
  -> Oradb::Net['config net8']
  -> File["${oracle_home}/dbs/init${ora_sid}.ora"]
  -> Oradb::Database["${ora_db_name}_create"]
  -> Oradb::Tnsnames[$ora_db_name]
  -> Oradb::Autostartdatabase["${ora_db_name}_autostart"]
  -> Db_control["${ora_db_name}_start"]

}
