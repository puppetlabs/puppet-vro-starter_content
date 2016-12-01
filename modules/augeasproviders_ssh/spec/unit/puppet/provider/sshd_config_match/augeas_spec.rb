#!/usr/bin/env rspec

require 'spec_helper'

provider_class = Puppet::Type.type(:sshd_config_match).provider(:augeas)

describe provider_class do
  before :each do
    FileTest.stubs(:exist?).returns false
    FileTest.stubs(:exist?).with('/etc/ssh/sshd_config').returns true
  end

  context "with empty file" do
    let(:tmptarget) { aug_fixture("empty") }
    let(:target) { tmptarget.path }

    it "should create simple new entry" do
      apply!(Puppet::Type.type(:sshd_config_match).new(
        :name      => "Host foo",
        :target    => target,
        :ensure    => :present,
        :provider  => "augeas"
      ))

      aug_open(target, "Sshd.lns") do |aug|
        expect(aug.get("Match/Condition/Host")).to eq("foo")
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
          :condition => p.get(:condition),
          :ensure => p.get(:ensure),
          :condition => p.get(:condition),
        }
      }

      expect(inst.size).to eq(2)
      expect(inst[0]).to eq({:condition=>"User anoncvs", :ensure=>:present})
      expect(inst[1]).to eq({:condition=>"Host *.example.net User *", :ensure=>:present})
    end

    context "when creating settings" do
      it "should add a new Match group at the end" do
        apply!(Puppet::Type.type(:sshd_config_match).new(
          :name      => "Foo bar",
          :target    => target,
          :ensure    => :present,
          :provider  => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("Match/Condition/Foo")[0]).to end_with("/Match[3]/Condition/Foo")
          expect(aug.get("Match/Condition/Foo")).to eq("bar")
        end
      end

      it "should add a new Match group before first group" do
        apply!(Puppet::Type.type(:sshd_config_match).new(
          :name      => "Bar baz",
          :position  => "before first match",
          :target    => target,
          :ensure    => :present,
          :provider  => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("Match/Condition/Bar")[0]).to end_with("/Match[1]/Condition/Bar")
          expect(aug.get("Match/Condition/Bar")).to eq("baz")
        end
      end

      it "should add a new Match group before specific group" do
        apply!(Puppet::Type.type(:sshd_config_match).new(
          :name      => "Fooz bar",
          :position  => "before User * Host *.example.net",
          :target    => target,
          :ensure    => :present,
          :provider  => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("Match/Condition/Fooz")[0]).to end_with("/Match[2]/Condition/Fooz")
          expect(aug.get("Match/Condition/Fooz")).to eq("bar")
        end
      end
    end

    context "when deleting settings" do
      it "should delete a Match group" do
        apply!(Puppet::Type.type(:sshd_config_match).new(
          :name      => "User anoncvs",
          :target    => target,
          :ensure    => :absent,
          :provider  => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("Match/Condition/User[.='anoncvs']").size).to eq(0)
        end
      end
    end

    context "when updating settings" do
      it "should move existing Match group to the end" do
        apply!(Puppet::Type.type(:sshd_config_match).new(
          :name      => "User anoncvs",
          :position  => "after last match",
          :target    => target,
          :ensure    => :positioned,
          :provider  => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("Match/Condition/User[.='anoncvs']")[0]).to end_with("/Match[2]/Condition/User")
          expect(aug.get("Match[2]/Condition/User")).to eq("anoncvs")
          expect(aug.get("Match[2]/Settings/X11Forwarding")).to eq("no")
        end
      end
    end
  end

  context "with broken file" do
    let(:tmptarget) { aug_fixture("broken") }
    let(:target) { tmptarget.path }

    it "should fail to load" do
      txn = apply(Puppet::Type.type(:sshd_config_match).new(
        :name     => "Host foo",
        :target   => target,
        :provider => "augeas"
      ))

      expect(txn.any_failed?).not_to eq(nil)
      expect(@logs.first.level).to eq(:err)
      expect(@logs.first.message.include?(target)).to eq(true)
    end
  end
end
