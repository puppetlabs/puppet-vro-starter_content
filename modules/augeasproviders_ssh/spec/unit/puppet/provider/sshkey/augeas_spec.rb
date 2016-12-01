#!/usr/bin/env rspec

require 'spec_helper'

provider_class = Puppet::Type.type(:sshkey).provider(:augeas)

describe provider_class do
  context "with empty file" do
    let(:tmptarget) { aug_fixture("empty") }
    let(:target) { tmptarget.path }

    it "should create simple new hashed entry" do
      apply!(Puppet::Type.type(:sshkey).new(
        :name          => "foo.example.com",
        :type          => "ssh-rsa",
        :key           => "DEADMEAT",
        :hash_hostname => :true,
        :target        => target,
        :provider      => "augeas"
      ))

      aug_open(target, "Known_Hosts.lns") do |aug|
        aug.match('./*[label()!="#comment"]').size.should == 1
        aug.get('./1').should =~ /^\|1\|/
        aug.get('./1/type').should == 'ssh-rsa'
        aug.get('./1/key').should == 'DEADMEAT'
      end
    end

    it "should create simple new hashed entry with aliases" do
      apply!(Puppet::Type.type(:sshkey).new(
        :name          => "foo.example.com",
        :type          => "ssh-rsa",
        :key           => "DEADMEAT",
        :hash_hostname => :true,
        :host_aliases  => [ 'foo', 'bar' ],
        :target        => target,
        :provider      => "augeas"
      ))

      aug_open(target, "Known_Hosts.lns") do |aug|
        aug.match('./*[label()!="#comment"]').size.should == 3
        aug.get('./1').should =~ /^\|1\|/
        aug.get('./1/type').should == 'ssh-rsa'
        aug.get('./1/key').should == 'DEADMEAT'
        aug.get('./2/key').should == 'DEADMEAT'
        aug.get('./3/key').should == 'DEADMEAT'
      end
    end

    it "should create simple new clear entry" do
      apply!(Puppet::Type.type(:sshkey).new(
        :name          => "bar.example.com",
        :type          => "ssh-rsa",
        :key           => "DEADMEAT",
        :hash_hostname => :false,
        :target        => target,
        :provider      => "augeas"
      ))

      aug_open(target, "Known_Hosts.lns") do |aug|
        aug.match('./*[label()!="#comment"]').size.should == 1
        aug.get('./1').should == 'bar.example.com'
        aug.get('./1/type').should == 'ssh-rsa'
        aug.get('./1/key').should == 'DEADMEAT'
      end
    end

    it "should create simple new clear entry with aliases" do
      apply!(Puppet::Type.type(:sshkey).new(
        :name          => "bar.example.com",
        :type          => "ssh-rsa",
        :key           => "DEADMEAT",
        :host_aliases  => [ 'foo', 'bar' ],
        :hash_hostname => :false,
        :target        => target,
        :provider      => "augeas"
      ))

      aug_open(target, "Known_Hosts.lns") do |aug|
        aug.match('./*[label()!="#comment"]').size.should == 1
        aug.get('./1').should == 'bar.example.com'
        aug.get('./1/type').should == 'ssh-rsa'
        aug.get('./1/alias[1]').should == 'foo'
        aug.get('./1/alias[2]').should == 'bar'
      end
    end
  end

  context "with full file" do
    let(:tmptarget) { aug_fixture("full") }
    let(:target) { tmptarget.path }

    it "should list instances" do
      provider_class.stubs(:target).returns(target)
      inst = provider_class.instances.map { |p|
        {
          :name         => p.get(:name),
          :type         => p.get(:type),
          :key          => p.get(:key),
          :host_aliases => p.get(:host_aliases)
        }
      }

      expect(inst.size).to eq(1)
      expect(inst[0]).to eq({:name=>"foo.example.com", :type=>"ssh-rsa", :key=>"AAAAB3NzaC1yc2EAAAADAQABAAABAQDl1Lw2S7Vgl36/TfP+oeHsoPei1UEl9E8DO2KmSLcf+8HFxPMd/9K0gJwJHKLdNBPwpi/YTsgY0hY7JmrWaZzv6CmrfKTYr/xpCP0yF6hKTv/2JX499CH4Q8rx2mqvI8jI/aQhtRSgWolNMc84jLMwdborGMWGXpIGuneF/hn9BkMTCCWSig8MYcR2IAHzb4rpva3wqH/RpczWRuEtCBPkcvoCFrdBbkpFNSihexIM+y1MPq2a18qA2IcCwl/KUfip16tyrCWkr7tMNBbjx6b1EDurlUX75Gk8KuOVNZcjdgYNQLAC+JeYQkynYz/0hQMBZaHDPrHjhz62WFNdGC+B", :host_aliases=>["foo"]})
    end

    it "should modify clear value" do
      apply!(Puppet::Type.type(:sshkey).new(
        :name     => "foo.example.com",
        :type     => "ssh-dss",
        :key      => "DEADMEAT",
        :target   => target,
        :provider => "augeas"
      ))

      aug_open(target, "Known_Hosts.lns") do |aug|
        aug.get('./2/type').should == 'ssh-dss'
        aug.get('./2/key').should == 'DEADMEAT'
      end
    end

    it "should modify aliases of clear value" do
      apply!(Puppet::Type.type(:sshkey).new(
        :name         => "foo.example.com",
        :host_aliases => ['foo', 'bar'],
        :target       => target,
        :provider     => "augeas"
      ))

      aug_open(target, "Known_Hosts.lns") do |aug|
        aug.match('./2/alias').size.should == 2
        aug.get('./2/alias[1]').should == 'foo'
        aug.get('./2/alias[2]').should == 'bar'
      end
    end

    it "should modify hashed value" do
      apply!(Puppet::Type.type(:sshkey).new(
        :name     => "bar.example.com",
        :type     => "ssh-dss",
        :key      => "DEADMEAT",
        :target   => target,
        :provider => "augeas"
      ))

      aug_open(target, "Known_Hosts.lns") do |aug|
        aug.get('./1/type').should == 'ssh-dss'
        aug.get('./1/key').should == 'DEADMEAT'
      end
    end

    it "should add an alias to hashed value" do
      apply!(Puppet::Type.type(:sshkey).new(
        :name         => "bar.example.com",
        :type         => "ssh-rsa",
        :key          => "DEADMEAT",
        :host_aliases => ['foo'],
        :target       => target,
        :provider     => "augeas"
      ))

      aug_open(target, "Known_Hosts.lns") do |aug|
        # Should not add an alias node
        aug.match('./1/alias').size.should == 0
        # Should add a new entry
        aug.match('./*[label()!="#comment"]').size.should == 4
        aug.get('./4/key').should == 'DEADMEAT'
      end
    end

    it "should update alias of hashed value" do
      apply!(Puppet::Type.type(:sshkey).new(
        :name         => "bar.example.com",
        :type         => "ssh-dss",
        :key          => "ABCDE",
        :host_aliases => [ 'qux' ],
        :target       => target,
        :provider     => "augeas"
      ))

      aug_open(target, "Known_Hosts.lns") do |aug|
        aug.match('./*[label()!="#comment"]').size.should == 3
        aug.get('./1/type').should == 'ssh-dss'
        aug.get('./1/key').should == 'ABCDE'
        aug.get('./3/type').should == 'ssh-dss'
        aug.get('./3/key').should == 'ABCDE'
      end
    end

    it "should hash existing clear value" do
      apply!(Puppet::Type.type(:sshkey).new(
        :name     => "foo.example.com",
        :ensure   => "hashed",
        :target   => target,
        :provider => "augeas"
      ))

      aug_open(target, "Known_Hosts.lns") do |aug|
        aug.match('./*[label()!="#comment"]').size.should == 4
        aug.get('./2').should =~ /^\|1\|/
        aug.get('./2/type').should == 'ssh-rsa'
        aug.get('./2/key').should =~ /^AAAAB3NzaC1yc2/
        aug.match('./2/alias').size.should == 0
        aug.get('./4').should =~ /^\|1\|/
        aug.get('./4/type').should == 'ssh-rsa'
        aug.get('./4/key').should =~ /^AAAAB3NzaC1yc2/
      end
    end

    it "should remove clear entry" do
      apply!(Puppet::Type.type(:sshkey).new(
        :name     => "foo.example.com",
        :ensure   => "absent",
        :target   => target,
        :provider => "augeas"
      ))

      aug_open(target, "Known_Hosts.lns") do |aug|
        aug.match('./*[label()!="#comment"]').size.should == 2
      end
    end

    it "should remove hashed entry with aliases" do
      apply!(Puppet::Type.type(:sshkey).new(
        :name         => "bar.example.com",
        :ensure       => "absent",
        :host_aliases => [ 'qux' ],
        :target       => target,
        :provider     => "augeas"
      ))

      aug_open(target, "Known_Hosts.lns") do |aug|
        aug.match('./*[label()!="#comment"]').size.should == 1
      end
    end
  end

  context "with broken file" do
    let(:tmptarget) { aug_fixture("broken") }
    let(:target) { tmptarget.path }

    it "should fail to load" do
      txn = apply(Puppet::Type.type(:sshkey).new(
        :name     => "foo.example.com",
        :key      => "DEADMEAT",
        :target   => target,
        :provider => "augeas"
      ))

      expect(txn.any_failed?).not_to eq(nil)
      expect(@logs.first.level).to eq(:err)
      expect(@logs.first.message.include?(target)).to eq(true)
    end
  end
end
