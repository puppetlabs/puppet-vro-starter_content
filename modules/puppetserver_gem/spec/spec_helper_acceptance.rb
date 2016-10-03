require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

unless ENV['RS_PROVISION'] == 'no'
#  if default.is_pe?; then
#    install_pe;
#  else
     install_puppet;
#  end
  pp=<<-EOS
  package { 'puppetserver': ensure => present, }
  EOS
  apply_manifest(pp)

  hosts.each do |host|
    if host['platform'] =~ /debian/
      on host, 'echo \'export PATH=/var/lib/gems/1.8/bin/:${PATH}\' >> ~/.bashrc'
      on host, "mkdir -p #{host['distmoduledir']}"
    end
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    hosts.each do |host|
      if host['platform'] !~ /windows/i
        copy_root_module_to(host, :source => proj_root, :module_name => 'puppetserver_gem')
      end
    end
  end

  c.treat_symbols_as_metadata_keys_with_true_values = true
end
