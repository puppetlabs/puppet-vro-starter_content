class profile::windows::iis {
  require profile::windows::dotnet

  Dism {
    ensure => present,
  }

  if $kernelmajversion == '6.1' {

    dism { "IIS-WebServerRole":            } ->
    dism { "IIS-WebServer":                } ->
    dism { "IIS-CommonHttpFeatures":       } ->
    dism { "IIS-RequestFiltering":         } ->
    dism { "IIS-StaticContent":            } ->
    dism { "IIS-DefaultDocument":          } ->
    dism { "IIS-DirectoryBrowsing":        } ->
    dism { "IIS-HttpErrors":               } ->
    dism { "IIS-HttpRedirect":             } ->
    dism { "IIS-ApplicationDevelopment":   } ->
    dism { "IIS-NetFxExtensibility":       } ->
    dism { "IIS-CGI":                      } ->
    dism { "IIS-ISAPIExtensions":          } ->
    dism { "IIS-ISAPIFilter":              } ->
    dism { "IIS-ServerSideIncludes":       } ->
    dism { "IIS-ASPNET":                   } ->
    dism { "IIS-ASP":                      } ->
    dism { "IIS-HealthAndDiagnostics":     } ->
    dism { "IIS-HttpLogging":              } ->
    dism { "IIS-LoggingLibraries":         } ->
    dism { "IIS-RequestMonitor":           } ->
    dism { "IIS-HttpTracing":              } ->
    dism { "IIS-CustomLogging":            } ->
    dism { "IIS-ODBCLogging":              } ->
    dism { "IIS-Security":                 } ->
    dism { "IIS-BasicAuthentication":      } ->
    dism { "IIS-URLAuthorization":         } ->
    dism { "IIS-IPSecurity":               } ->
    dism { "IIS-Performance":              } ->
    dism { "IIS-HttpCompressionStatic":    } ->
    dism { "IIS-HttpCompressionDynamic":   } ->
    dism { "IIS-WebServerManagementTools": } ->
    dism { "IIS-ManagementConsole":        } ->
    dism { "IIS-ManagementScriptingTools": } ->
    dism { "IIS-ManagementService":
      notify => Exec["register_net_with_iis"],
    }

  }

  exec { 'register_net_with_iis':
    command     => 'C:\Windows\Microsoft.NET\Framework64\v4.0.30319\aspnet_regiis.exe -i',
    refreshonly => true,
    subscribe   => Package['Microsoft .NET Framework 4 Extended'],
  }

  iis::manage_site { 'Default Web Site':
    ensure    => absent,
    site_path => 'C:\inetpub\wwwroot',
    app_pool  => 'Default Web Site',
  }

  iis::manage_app_pool { 'Default Web Site':
    ensure => absent,
  }

}
