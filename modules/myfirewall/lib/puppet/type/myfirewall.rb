require 'puppet/property/boolean'
require 'puppet/type'

Puppet::Type.newtype(:myfirewall) do
  @doc = 'This Firewall module will modify the firewalld firewall.'

  ensurable do
  
  newvalue(:present) do
    provider.create
  end

  newvalue(:absent) do
    provider.destroy
  end

  def insync?(is)
    @should.each do |should|
      case should
        when :present
          return true if is == :present
        when :absent
          return true if is == :absent
      end
    end
    return false
  end

  defaultto :present
 end

  newparam(:flush) do
    desc 'Flush the rules for firewall zone. (Not implemented)'
  end

  newparam(:name, :namevar => true) do
    desc 'Name for firewall rule. (required)'
  end

  #Will have to come back and revisit arrays for zones.
  #newparam(:zone, :array_matching => :all) do
  newparam(:zone) do
    desc 'Zone to add/delete/modify firewall rules. (required)'
  end

  newparam(:protocol) do
    desc 'Protocol to use. Required if using port (tcp or udp)'
  end

  newparam(:tcp_udp, :parent => Puppet::Property::Boolean) do
    desc 'Adds both protocols to firewall. values: (true|false)'
 
    defaultto false
  end
  
  newparam(:port, :array_matching => :all) do
    desc 'Port to configure'
  end

  newparam(:service, :array_matching => :all) do
     desc 'Service to add to firewall'
  end

  newparam(:block_icmp, :array_matching => :all) do
     desc 'icmp messages to block in firewall'
  end

  newparam(:source) do
    desc 'Ip source to allow'
  end

  newparam(:richrule, :array_matching => :all) do
    desc 'Add richrule to firewall'
  end

  newparam(:permanent, :parent => Puppet::Property::Boolean) do
    desc 'Configure rule as a permanent rule. values: (true|false)'

    defaultto true
  end

  newparam(:myzones, :parent => Puppet::Property::Boolean) do
    desc 'Modify zones in firewall.  values: (true|false)'

    defaultto false
  end
end
