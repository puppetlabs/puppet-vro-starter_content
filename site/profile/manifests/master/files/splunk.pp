class profile::master::files::splunk (
  $srv_root = '/opt/tse-files',
) {

  $dir_root   = "${srv_root}/demo_offline_splunk"
  $version    = '6.0'
  $build      = '182037'
  $src_root   = "http://download.splunk.com/releases/${version}"

  Remote_file {
    require => File[$dir_root],
    mode    => '0644',
  }

  # There are a bunch of packages that need to be retrieved, but luckily the
  # naming is algorithmic. This hash is a list of all platforms we need
  # installers for, and what architectures.
  $platforms = {
    'windows' => {
      'x64' => "${version}-${build}-x64-release.msi",
    },
    'linux'   => {
      'rpm_x86_64' => "${version}-${build}-linux-2.6-x86_64.rpm",
      'rpm_x86'    => "${version}-${build}.i386.rpm",
      'deb_x86_64' => "${version}-${build}-linux-2.6-amd64.deb",
      'deb_x86'    => "${version}-${build}-linux-2.6-intel.deb",
    },
    'solaris' => {
      'solaris_64' => "${version}-${build}-solaris-10-intel.pkg.Z",
    },
  }

  # Splunk places each kind of installer in a dir (hash key below) and prefixes
  # the filename with a potentially different string (hash value below).
  $kinds = {
    'splunk'             => 'splunk',
    'universalforwarder' => 'splunkforwarder',
  }

  file { $dir_root:
    ensure => directory,
    mode   => '0755',
  }

  $kinds.each |$dir,$prefix| {
    file { "${dir_root}/${dir}":
      ensure => directory,
      mode   => '0755',
    }
  }

  $platforms.each |$platform,$architecture| {
    # Make sure directories exist for the platform's splunk installers and
    # universalforwarders
    $kinds.each |$dir,$prefix| {
      file { "${dir_root}/${dir}/${platform}":
        ensure => directory,
        mode   => '0755',
      }
    }

    $architecture.each |$arch,$file| {
      # Ensure splunk and universalforwarder packages are present for each listed
      # architecture and file
      $kinds.each |$dir,$prefix| {
        remote_file { "${prefix}-${file}":
          source => "${src_root}/${dir}/${platform}/${prefix}-${file}",
          path   => "${dir_root}/${dir}/${platform}/${prefix}-${file}",
        }
      }
    }
  }

  # Solaris is special and needs the package to be decompressed
  $platforms['solaris'].each |$arch,$file| {
    $kinds.each |$dir,$prefix| {
      exec { "extract ${prefix}-${file}":
        path     => '/usr/bin:/bin',
        cwd      => "${dir_root}/${dir}/solaris",
        provider => shell,
        command  => "gzip -dc ${prefix}-${file} > ${prefix}-${file[0,-3]}",
        creates  => "${dir_root}/${dir}/solaris/${prefix}-${file[0,-3]}",
        require  => Remote_file["${prefix}-${file}"],
      }
    }
  }

}
