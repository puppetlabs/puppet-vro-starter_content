class profile::windows::dotnet (
  Enum['present', 'absent']
  $ensure = 'present',

  Variant[String, Array[String, 1]]
  $version = '4.0',

  Boolean
  $reboot = true,
) {

  include dotnet::params

  if $reboot {
    # Ensure that the system is rebooted after any .NET install/uninstall
    # activity.
    reboot { 'Finalize .NET installation': }
    $notify = Reboot['Finalize .NET installation']
  }
  else {
    $notify = undef
  }

  # For each version specified in the $version parameter, ensure that version
  # of .NET is present or absent (as specified by the user).
  [$version].flatten.each |$ver| {

    # For some versions we have a local copy of the package. Use a local copy
    # for those versions. For any other version, try to download the package
    # from Microsoft.
    case $ver {
      '4.0': {
        $dotnetexe   = $dotnet::params::version[$ver]['exe']
        $package_dir = 'C:/Windows/Temp'
        remote_file { "C:/Windows/Temp/${dotnetexe}":
          ensure => present,
          source => "http://${::servername}/dotnetcms/${dotnetexe}",
          before => Dotnet[".NET Framework ${ver}"],
        }
      }
      default: {
        # If the installer isn't in C:/Windows/Temp the dotnet module will
        # automatically try to download it from Microsoft.
        $package_dir = undef
      }
    }

    dotnet { ".NET Framework ${ver}":
      ensure      => $ensure,
      version     => $ver,
      notify      => $notify,
      package_dir => $package_dir,
    }
  }

}
