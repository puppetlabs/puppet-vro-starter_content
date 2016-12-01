#!/usr/bin/env rspec

require 'spec_helper'

sshd_config_type = Puppet::Type.type(:sshd_config)

describe sshd_config_type do
  context 'when setting parameters' do
    it 'should accept a name parameter' do
      resource = sshd_config_type.new :name => 'foo'
      expect(resource[:name]).to eq('foo')
    end

    it 'should accept a condition parameter' do
      resource = sshd_config_type.new :name => 'foo', :condition => 'Host foo'
      expect(resource[:condition]).to eq({'Host' => 'foo'})
    end

    it 'should accept a target parameter' do
      resource = sshd_config_type.new :name => 'foo', :target => '/foo/bar'
      expect(resource[:target]).to eq('/foo/bar')
    end
  end
end

