#!/usr/bin/env rspec

require 'spec_helper'

ssh_config_type = Puppet::Type.type(:ssh_config)

describe ssh_config_type do
  context 'when setting parameters' do
    it 'should accept a name parameter' do
      resource = ssh_config_type.new :name => 'foo'
      expect(resource[:name]).to eq('foo')
    end

    it 'should accept a key parameter' do
      resource = ssh_config_type.new :name => 'foo', :key => 'bar'
      expect(resource[:key]).to eq('bar')
    end

    it 'should accept a value array parameter' do
      resource = ssh_config_type.new :name => 'MACs', :value => ['foo', 'bar']
      expect(resource[:value]).to eq(['foo', 'bar'])
    end

    it 'should accept a target parameter' do
      resource = ssh_config_type.new :name => 'foo', :target => '/foo/bar'
      expect(resource[:target]).to eq('/foo/bar')
    end

    it 'should fail if target is not an absolute path' do
      expect {
        ssh_config_type.new :name => 'foo', :target => 'foo'
      }.to raise_error
    end

    it 'should accept a host parameter' do
      resource = ssh_config_type.new :name => 'foo', :host => 'example.net'
      expect(resource[:host]).to eq('example.net')
    end

    it 'should have * as default host value' do
      resource = ssh_config_type.new :name => 'foo'
      expect(resource[:host]).to eq('*')
    end
  end
end

