# This is a Puppetfile, which describes a collection of Puppet modules. For
# format and syntax examples, see one of the following resources:
#
# https://github.com/rodjek/librarian-puppet/blob/master/README.md
# https://github.com/adrienthebo/r10k/blob/master/README.markdown
#
# Brief example:
#
#   mod 'puppetlabs/stdlib', '4.1.0'
#
# In addition to the component modules listed here, the default production
# environment for the TSE Team also includes a role and profile module in the
# site directory.

forge "https://forgeapi.puppetlabs.com"

# LOCAL MODULES
# These modules are currently committed to the modules/ directory locally, but
# should ideally be converted to regular module references to the Forge or to a
# git repo.
# mod 'rgbank', :local => true
# mod 'http', :local => true
# mod 'database', :local => true

# PL Modules

mod 'puppetlabs/acl', '1.1.1'
mod 'puppetlabs/apache', '1.6.0'
mod 'puppetlabs/aws', '1.4.0'
mod 'puppetlabs/azure', '1.0.2'
mod 'puppetlabs/concat', '2.2.0'
mod 'puppetlabs/dism', '1.2.0'
mod 'puppetlabs/docker_platform', '2.1.0'
mod 'puppetlabs/dsc', '1.0.1'
mod 'puppetlabs/firewall', '1.8.1'
mod 'puppetlabs/git', '0.4.0'
mod 'puppetlabs/haproxy', '1.3.0'
mod 'puppetlabs/inifile', '1.5.0'
mod 'puppetlabs/java', '1.4.1'
mod 'puppetlabs/limits', '0.1.0'
mod 'puppetlabs/mount_iso', '0.1.0'
mod 'puppetlabs/mysql', '3.5.0'
mod 'puppetlabs/ntp', '4.1.0'
mod 'puppetlabs/powershell', '2.0.1'
mod 'puppetlabs/puppetserver_gem', '0.1.0'
mod 'puppetlabs/reboot', '1.2.1'
mod 'puppetlabs/registry', '1.1.2'
mod 'puppetlabs/splunk', '3.2.0'
mod 'puppetlabs/stdlib', '4.12.0'
mod 'puppetlabs/tomcat', '1.3.2'
mod 'puppetlabs/vcsrepo', '1.3.1'

# Forge Community Modules

mod 'camptocamp/archive', '0.8.1'
mod 'chocolatey/chocolatey', '1.2.5'
mod 'garethr/docker', '5.2.0'
mod 'andulla/dsc_collection', '0.2.2'
mod 'ipcrm/echo', '0.1.3'
mod 'stahnma/epel', '1.0.2'
mod 'vshn/gitlab', '1.8.0'
mod 'abrader/gms', '1.0.2'
mod 'hunner/hiera', '2.0.1'
mod 'puppet/iis', '1.4.1'
mod 'rtyler/jenkins', '1.6.1'
mod 'tse/local_yum_repo', '0.2.0'
mod 'WhatsARanjit/node_manager', '0.2.0'
mod 'biemond/oradb', '2.0.2'
mod 'cyberious/pget', '1.1.0'
mod 'pltraining/rbac', '0.0.4'
mod 'lwf/remote_file', '1.1.0'
mod 'ajjahn/samba', '0.3.1'
mod 'nanliu/staging', '1.0.3'
mod 'fiddyspence/sysctl', '1.1.0'
mod 'reidmv/unzip', '0.1.2'
mod 'andulla/vsphere_conf', '0.0.9'
mod 'biemond/wildfly', '0.5.2' # Wildfly / JBoss demo
mod 'badgerious/windows_env', '2.2.2'
mod 'puppet/windows_firewall', '1.0.0'
mod 'cyberious/windows_java', '1.0.2'
mod 'puppet/windowsfeature', '1.1.0'
mod 'hunner/wordpress', '1.0.0'

# Git TSE modules - either maintained under seteam or by individual SE's

mod 'awsenv',
  :git => 'git@github.com:puppetlabs/tse-module-awsenv.git',
  :ref => '0.1.0'
mod 'cloudshop',
  :git => 'https://github.com/velocity303/puppet-cloudshop.git',
  :ref => '1.0.0'
mod 'cmsapp',
  :git => 'git@github.com:puppetlabs/tse-module-cmsapp.git'

# This fork of puppet/dotnet includes updates to allow .NET to be idempotently
# ensured present on Server 2012, which has many .NET versions built-in. There
# is a PR to merge these changes back to the original module. As soon as a 2.0
# relase of puppet/dotnet is created we should be able to switch to that.
mod 'dotnet',
  :git => 'https://github.com/reidmv/puppet-dotnet.git',
  :ref => 'c841b36081c22de7876d85af4debf0375731d1a5'

mod 'ec2tags',
  :git => 'git@github.com:mrzarquon/puppet-ec2tags.git'
mod 'ibm_installation_manager',
  :git => 'git@github.com:ipcrm/puppetlabs-ibm_installation_manager.git',
  :ref => 'master'
mod 'ldap',
  :git => 'git@github.com:puppetlabs/tse-module-ldapserver.git'
mod 'nonpriv',
  :git => 'git@github.com:puppetlabs/tse-module-nonpriv.git',
  :ref => '0.1.0'
mod 'openssh',
  :git => 'git@github.com:puppetlabs/tse-module-openssh.git',
  :ref => '0.1.0'
mod 'pe_windows_shortcuts',
  :git => 'git@github.com:puppetlabs/tse-module-pe_windows_shortcuts.git'
mod 'puppet_vim_env',
  :git => 'git@github.com:puppetlabs/tse-module-puppet_vim_env.git',
  :ref => '2.1.2'
mod 'razordemo',
  :git => 'git@github.com:puppetlabs/tse-module-razordemo.git',
  :ref => '3.2.0'
mod 'tse_admins',
  :git => 'git@github.com:puppetlabs/tse-module-tse_admins.git'
mod 'tse_facts',
  :git => 'git@github.com:puppetlabs/tse-module-tse_facts.git',
  :ref => '0.2.0'
mod 'vsphere',
   :git => 'git@github.com:puppetlabs/puppetlabs-vsphere.git',
   :ref => '1.2.2'
mod 'vsphere_provision',
  :git => 'git@github.com:puppetlabs/tse-module-vsphere_provision.git',
  :ref => '1.0.0'
mod 'tse_windows',
  :git => 'git@github.com:puppetlabs/tse-module-tse_windows.git',
  :ref => '0.1.0'
mod 'tse_sqlserver',
  :git => 'https://github.com/puppetlabs/tse-module-tse_sqlserver.git',
  :ref => '1.0.1'
mod 'sqlserver',
  :git => 'git@github.com:puppetlabs/puppetlabs-sqlserver.git',
  :ref => '1.1.2'
mod 'sqlwebapp',
  :git => 'https://github.com/velocity303/puppet-sqlwebapp.git',
  :ref => '1.0.0'
mod 'websphere',
  :git => 'git@github.com:ipcrm/puppetlabs-websphere.git',
  :ref => 'master'
mod 'wordpress_app',
  :git => 'git@github.com:ipcrm/apporchestration-wordpress.git'
mod 'zabbix_app',
  :git => 'git@github.com:ipcrm/appmgmt-module-zabbix_app.git'
mod 'zabbix',
  :git => 'git@github.com:ipcrm/puppet-zabbix.git'
