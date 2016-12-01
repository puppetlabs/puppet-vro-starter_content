#!/usr/bin/env rspec

require 'spec_helper'

sshd_config_match_type = Puppet::Type.type(:sshd_config_match)

describe sshd_config_match_type do
  context 'when setting parameters' do
    it 'should accept a name parameter' do
      resource = sshd_config_match_type.new :name => 'foo'
      expect(resource[:name]).to eq('foo')
    end

    it 'should accept a condition parameter' do
      resource = sshd_config_match_type.new :name => 'foo', :condition => 'Host foo'
      expect(resource[:condition]).to eq({'Host' => 'foo'})
    end

    it 'should accept a target parameter' do
      resource = sshd_config_match_type.new :name => 'foo', :target => '/foo/bar'
      expect(resource[:target]).to eq('/foo/bar')
    end

    it 'should accept a position parameter' do
      resource = sshd_config_match_type.new :name => 'foo', :position => 'before Host bar'
      expect(resource[:position]).to eq({:before => true, :match => 'Host bar'})
    end

    it 'should have a full composite namevar' do
      resource = sshd_config_match_type.new :title => 'Host foo User bar in /tmp/sshd_config'
      expect(resource[:name]).to eq('Host foo User bar in /tmp/sshd_config')
      expect(resource[:condition]).to eq({'Host' => 'foo', 'User' => 'bar'})
      expect(resource[:target]).to eq('/tmp/sshd_config')
    end

    it 'should have a partial composite namevar' do
      resource = sshd_config_match_type.new :title => 'Host foo User bar'
      expect(resource[:name]).to eq('Host foo User bar')
      expect(resource[:condition]).to eq({'Host' => 'foo', 'User' => 'bar'})
    end
  end
end
