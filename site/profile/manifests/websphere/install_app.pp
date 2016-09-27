class profile::websphere::install_app (
  $appname         = 'HelloWorld',
  $appserver       = 'centos6b_appserver',
  $appfile         = '/vagrant/ibm/apps/helloworld.war',
  $cell            = 'CELL_01',
  $cluster         = 'MyCluster01',
  $user            = 'websphere',
	$profile_base    = '/opt/IBM/WebSphere/AppServer/profiles',
	$dmgr_profile    = 'PROFILE_DMGR_01',
	$webmodule       = "Hello, World Application",
	$webmodule_uri   = "helloworld.war,WEB-INF/web.xml",
	$webmodule_vhost = "default_host"
){

  # Require DMGR Profile BEFORE Installing any apps incase there are Node changes 
  Class['profile::websphere::dmgr'] -> Class['profile::websphere::install_app']

	websphere_app{$appname:
    ensure          => present,
    appsource       => $appfile,
    cell            => $cell,
    cluster         => $cluster,
    user            => $user,
    profile_base    => $profile_base,
    dmgr_profile    => $dmgr_profile,
    webmodule       => $webmodule,
    webmodule_uri   => $webmodule_uri,
    webmodule_vhost => $webmodule_vhost,
	}
}
