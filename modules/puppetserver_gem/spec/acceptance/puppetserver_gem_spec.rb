require 'spec_helper_acceptance'

describe 'installing a gem with the pe_puppetserver_gem provider' do
  it 'should work with no errors' do
    pp = <<-EOS
      package { 'hocon':
        ensure => present,
        provider => puppetserver_gem,
      }
    EOS

    # Run it twice to test for idempotency
    apply_manifest(pp, :catch_failures => true)
    expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
  end

  it 'should successfully install the desired gem' do
    shell("/opt/puppetlabs/bin/puppetserver gem list | grep hocon", :acceptable_exit_codes => 0)
  end
end

describe 'removing a gem with the pe_puppetserver_gem provider' do
  it 'should work with no errors' do
    pp = <<-EOS
      package { 'hocon':
        ensure => absent,
        provider => puppetserver_gem,
      }
    EOS

    # Run it twice to test for idempotency
    apply_manifest(pp, :catch_failures => true)
    expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
  end

  it 'should successfully remove the desired gem' do
    shell("/opt/puppetlabs/bin/puppetserver gem list | grep hocon", :acceptable_exit_codes => 1)
  end
end
