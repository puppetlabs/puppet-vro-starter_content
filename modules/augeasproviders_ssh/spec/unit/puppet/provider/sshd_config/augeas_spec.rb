#!/usr/bin/env rspec

require 'spec_helper'

provider_class = Puppet::Type.type(:sshd_config).provider(:augeas)

describe provider_class do
  before :each do
    FileTest.stubs(:exist?).returns false
    FileTest.stubs(:exist?).with('/etc/ssh/sshd_config').returns true
  end

  context "with empty file" do
    let(:tmptarget) { aug_fixture("empty") }
    let(:target) { tmptarget.path }

    it "should create simple new entry" do
      apply!(Puppet::Type.type(:sshd_config).new(
        :name     => "PermitRootLogin",
        :value    => "yes",
        :target   => target,
        :provider => "augeas"
      ))

      aug_open(target, "Sshd.lns") do |aug|
        expect(aug.get("PermitRootLogin")).to eq("yes")
      end
    end

    it "should create an array entry" do
      apply!(Puppet::Type.type(:sshd_config).new(
        :name     => "AllowGroups",
        :value    => ["sshgroups", "admins"],
        :target   => target,
        :provider => "augeas"
      ))

      aug_open(target, "Sshd.lns") do |aug|
        expect(aug.get("AllowGroups/1")).to eq("sshgroups")
        expect(aug.get("AllowGroups/2")).to eq("admins")
      end
    end

    it "should create new entry in a Match block" do
      apply!(Puppet::Type.type(:sshd_config).new(
        :name      => "X11Forwarding",
        :condition => "Host foo User root",
        :value     => "yes",
        :target    => target,
        :provider  => "augeas"
      ))

      aug_open(target, "Sshd.lns") do |aug|
        expect(aug.get("Match[1]/Condition/Host")).to eq("foo")
        expect(aug.get("Match[1]/Condition/User")).to eq("root")
        expect(aug.get("Match[1]/Settings/X11Forwarding")).to eq("yes")
      end
    end

    context "when declaring two resources with same key" do
      it "should fail with same name" do
        expect do 
          apply!(
            Puppet::Type.type(:sshd_config).new(
              :name      => "X11Forwarding",
              :value     => "no",
              :target    => target,
              :provider  => "augeas"
            ),
            Puppet::Type.type(:sshd_config).new(
              :name      => "X11Forwarding",
              :condition => "Host foo User root",
              :value     => "yes",
              :target    => target,
              :provider  => "augeas"
            )
          )
        end.to raise_error(Puppet::Resource::Catalog::DuplicateResourceError)
      end

      it "should fail with different names, same key and no conditions" do
        expect do 
          apply!(
            Puppet::Type.type(:sshd_config).new(
              :name      => "X11Forwarding",
              :value     => "no",
              :target    => target,
              :provider  => "augeas"
            ),
            Puppet::Type.type(:sshd_config).new(
              :name      => "Global X11Forwarding",
              :key       => "X11Forwarding",
              :value     => "yes",
              :target    => target,
              :provider  => "augeas"
            )
          )
        end.to raise_error
      end

      it "should not fail with different names, same key and different conditions" do
        expect do 
          apply!(
            Puppet::Type.type(:sshd_config).new(
              :name      => "X11Forwarding",
              :value     => "no",
              :target    => target,
              :provider  => "augeas"
            ),
            Puppet::Type.type(:sshd_config).new(
              :name      => "Global X11Forwarding",
              :key       => "X11Forwarding",
              :condition => "User foo",
              :value     => "yes",
              :target    => target,
              :provider  => "augeas"
            )
          )
        end.not_to raise_error
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
          :name => p.get(:name),
          :ensure => p.get(:ensure),
          :value => p.get(:value),
          :condition => p.get(:condition),
        }
      }

      expect(inst.size).to eq(16)
      expect(inst[0]).to eq({:name=>"ListenAddress", :ensure=>:present, :value=>["0.0.0.0", "::"], :condition=>:absent})
      expect(inst[1]).to eq({:name=>"SyslogFacility", :ensure=>:present, :value=>["AUTHPRIV"], :condition=>:absent})
      expect(inst[2]).to eq({:name=>"AllowGroups", :ensure=>:present, :value=>["sshusers", "admins"], :condition=>:absent})
      expect(inst[3]).to eq({:name=>"PermitRootLogin", :ensure=>:present, :value=>["without-password"], :condition=>:absent})
      expect(inst[4]).to eq({:name=>"PasswordAuthentication", :ensure=>:present, :value=>["yes"], :condition=>:absent})
      expect(inst[8]).to eq({:name=>"UsePAM", :ensure=>:present, :value=>["yes"], :condition=>:absent})
      expect(inst[9]).to eq({:name=>"AcceptEnv", :ensure=>:present, :value=>["LANG", "LC_CTYPE", "LC_NUMERIC", "LC_TIME", "LC_COLLATE", "LC_MONETARY", "LC_MESSAGES", "LC_PAPER", "LC_NAME", "LC_ADDRESS", "LC_TELEPHONE", "LC_MEASUREMENT", "LC_IDENTIFICATION", "LC_ALL", "LANGUAGE", "XMODIFIERS"], :condition=>:absent})
      expect(inst[11]).to eq({:name=>"X11Forwarding", :ensure=>:present, :value=>["no"], :condition=> "User anoncvs"})
      expect(inst[14]).to eq({:name=>"AllowAgentForwarding", :ensure=>:present, :value=>["no"], :condition=> "Host *.example.net User *"})
    end

    describe "when creating settings" do
      it "should add it before Match block" do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "Banner",
          :value    => "/etc/issue",
          :target   => target,
          :provider => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.get("Banner")).to eq("/etc/issue")
        end
      end

      it "should insert Port before the first ListenAddress in a Match block" do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name      => "Port",
          :condition => "Host *.example.net User *",
          :value     => "2222",
          :target    => target,
          :provider  => "augeas"
        ))
  
        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("Match[2]/Settings/ListenAddress[preceding-sibling::Port]").size).to eq(1)
        end
      end

      it "should add it next to commented out entry" do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "Banner",
          :value    => "/etc/issue",
          :target   => target,
          :provider => "augeas"
        ))

        augparse_filter(target, "Sshd.lns", '*[preceding-sibling::#comment[.="no default banner path"]][label()!="Match"]', '
          { "#comment" = "Banner none" }
          { "Banner" = "/etc/issue" }
          { "#comment" = "override default of no subsystems" }
          { "Subsystem"
            { "sftp" = "/usr/libexec/openssh/sftp-server" } }
          { "#comment" = "Example of overriding settings on a per-user basis" }
        ')
      end

      it "should add it next to commented out entry with different case when on Augeas >= 1.0.0", :if => provider_class.supported?(:regexpi) do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "usedns",
          :value    => "no",
          :target   => target,
          :provider => "augeas"
        ))

        augparse_filter(target, "Sshd.lns", '*[preceding-sibling::#comment[.="ShowPatchLevel no"]][label()!="Match"]', '
          { "#comment" = "UseDNS yes" }
          { "usedns" = "no" }
          { "#comment" = "PidFile /var/run/sshd.pid" }
          { "#comment" = "MaxStartups 10" }
          { "#comment" = "PermitTunnel no" }
          { "#comment" = "ChrootDirectory none" }
          { "#comment" = "no default banner path" }
          { "#comment" = "Banner none" }
          { "#comment" = "override default of no subsystems" }
          { "Subsystem"
            { "sftp" = "/usr/libexec/openssh/sftp-server" }
          }
          { "#comment" = "Example of overriding settings on a per-user basis" }
        ')
      end

      it "should create an array entry" do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "AllowUsers",
          :value    => ["ssh", "foo"],
          :target   => target,
          :provider => "augeas"
        ))
  
        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.get("AllowUsers/1")).to eq("ssh")
          expect(aug.get("AllowUsers/2")).to eq("foo")
        end
      end

      it "should match the entire Match conditions and create new block" do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name      => "AllowAgentForwarding",
          :condition => "Host *.example.net",
          :value     => "yes",
          :target    => target,
          :provider  => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.get("Match[3]/Settings/AllowAgentForwarding")).to eq("yes")
        end
      end
    end

    describe "when deleting settings" do
      it "should delete a setting" do
        expr = "PermitRootLogin"
        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match(expr)).not_to eq([])
        end

        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "PermitRootLogin",
          :ensure   => "absent",
          :target   => target,
          :provider => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match(expr)).to eq([])
        end
      end

      it "should delete all instances of a setting" do
        expr = "ListenAddress"
        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match(expr)).not_to eq([])
        end

        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "ListenAddress",
          :ensure   => "absent",
          :target   => target,
          :provider => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match(expr)).to eq([])
        end
      end

      it "should delete from a Match block" do
        expr = "Match[*]/Settings/AllowAgentForwarding"
        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match(expr)).not_to eq([])
        end

        apply!(Puppet::Type.type(:sshd_config).new(
          :name      => "AllowAgentForwarding",
          :condition => "Host *.example.net User *",
          :ensure    => "absent",
          :target    => target,
          :provider  => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match(expr)).to eq([])
        end
      end
    end

    describe "when updating settings" do
      it "should replace a setting" do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "PermitRootLogin",
          :value    => "yes",
          :target   => target,
          :provider => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("*[label()='PermitRootLogin']").size).to eq(1)
          expect(aug.get("PermitRootLogin")).to eq("yes")
        end
      end

      it "should replace a setting in a Match block" do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name      => "X11Forwarding",
          :condition => "User anoncvs",
          :value     => "yes",
          :target    => target,
          :provider  => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.get("Match[*]/Settings/X11Forwarding")).to eq("yes")
        end
      end

      it "should replace the array setting" do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "AcceptEnv",
          :value    => ["BAR", "LC_FOO"],
          :target   => target,
          :provider => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("AcceptEnv/*").size).to eq(2)
          expect(aug.get("AcceptEnv/1")).to eq("BAR")
          expect(aug.get("AcceptEnv/2")).to eq("LC_FOO")
        end
      end

      it "should replace and add to multiple single-value settings" do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "ListenAddress",
          :value    => ["192.168.1.1", "192.168.2.1", "192.168.3.1"],
          :target   => target,
          :provider => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("ListenAddress").size).to eq(3)
          expect(aug.get("ListenAddress[1]")).to eq("192.168.1.1")
          expect(aug.get("ListenAddress[2]")).to eq("192.168.2.1")
          expect(aug.get("ListenAddress[3]")).to eq("192.168.3.1")
        end
      end

      it "should replace multiple single-value settings with one" do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "ListenAddress",
          :value    => "192.168.1.1",
          :target   => target,
          :provider => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("ListenAddress").size).to eq(1)
          expect(aug.get("ListenAddress")).to eq("192.168.1.1")
        end
      end

      it "should replace settings case insensitively when on Augeas >= 1.0.0", :if => provider_class.supported?(:regexpi) do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "PaSswordaUtheNticAtion",
          :value    => "no",
          :target   => target,
          :provider => "augeas"
        ))
  
        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("*[label()=~regexp('PasswordAuthentication', 'i')]").size).to eq(1)
          expect(aug.get("PasswordAuthentication")).to eq("no")
        end
      end
  
      it "should not replace settings case insensitively when on Augeas < 1.0.0" do
        provider_class.stubs(:supported?).with(:post_resource_eval)
        provider_class.stubs(:supported?).with(:regexpi).returns(false)
        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "GSSAPIauthentIcAtion",
          :value    => "no",
          :target   => target,
          :provider => "augeas"
        ))
  
        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("GSSAPIAuthentication").size).to eq(1)
          expect(aug.match("GSSAPIauthentIcAtion").size).to eq(1)
          expect(aug.get("GSSAPIAuthentication")).to eq("yes")
          expect(aug.get("GSSAPIauthentIcAtion")).to eq("no")
        end
      end
    end
  end

  context "with no Match block file" do
    let(:tmptarget) { aug_fixture("nomatch") }
    let(:target) { tmptarget.path }

    describe "when creating settings" do
      it "should replace multiple single-value settings" do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "ListenAddress",
          :value    => ["192.168.1.1", "192.168.2.1", "192.168.3.1"],
          :target   => target,
          :provider => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("ListenAddress").size).to eq(3)
          expect(aug.get("ListenAddress[1]")).to eq("192.168.1.1")
          expect(aug.get("ListenAddress[2]")).to eq("192.168.2.1")
          expect(aug.get("ListenAddress[3]")).to eq("192.168.3.1")
        end
      end

      it "should replace the array setting" do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "AcceptEnv",
          :value    => ["BAR", "LC_FOO"],
          :target   => target,
          :provider => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("AcceptEnv/*").size).to eq(2)
          expect(aug.get("AcceptEnv/1")).to eq("BAR")
          expect(aug.get("AcceptEnv/2")).to eq("LC_FOO")
        end
      end

      it "should replace and add to multiple single-value settings" do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "ListenAddress",
          :value    => ["192.168.1.1", "192.168.2.1", "192.168.3.1"],
          :target   => target,
          :provider => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("ListenAddress").size).to eq(3)
          expect(aug.get("ListenAddress[1]")).to eq("192.168.1.1")
          expect(aug.get("ListenAddress[2]")).to eq("192.168.2.1")
          expect(aug.get("ListenAddress[3]")).to eq("192.168.3.1")
        end
      end

      it "should replace multiple single-value settings with one" do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "ListenAddress",
          :value    => "192.168.1.1",
          :target   => target,
          :provider => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("ListenAddress").size).to eq(1)
          expect(aug.get("ListenAddress")).to eq("192.168.1.1")
        end
      end

      it "should add it next to commented out entry" do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "Banner",
          :value    => "/etc/issue",
          :target   => target,
          :provider => "augeas"
        ))

        augparse_filter(target, "Sshd.lns", '*[preceding-sibling::#comment[.="no default banner path"]]', '
          { "#comment" = "Banner none" }
          { "Banner" = "/etc/issue" }
          { "#comment" = "override default of no subsystems" }
          { "Subsystem"
            { "sftp" = "/usr/libexec/openssh/sftp-server" } }
        ')
      end

      it "should insert Port before the first ListenAddress" do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "Port",
          :value    => "2222",
          :target   => target,
          :provider => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("ListenAddress[preceding-sibling::Port]").size).to eq(2)
        end
      end
    end

    describe "when updating settings" do
      it "should replace a setting" do
        apply!(Puppet::Type.type(:sshd_config).new(
          :name     => "PermitRootLogin",
          :value    => "yes",
          :target   => target,
          :provider => "augeas"
        ))

        aug_open(target, "Sshd.lns") do |aug|
          expect(aug.match("*[label()='PermitRootLogin']").size).to eq(1)
          expect(aug.get("PermitRootLogin")).to eq("yes")
        end
      end
    end
  end

  context "with broken file" do
    let(:tmptarget) { aug_fixture("broken") }
    let(:target) { tmptarget.path }

    it "should fail to load" do
      txn = apply(Puppet::Type.type(:sshd_config).new(
        :name     => "PermitRootLogin",
        :value    => "yes",
        :target   => target,
        :provider => "augeas"
      ))

      expect(txn.any_failed?).not_to eq(nil)
      expect(@logs.first.level).to eq(:err)
      expect(@logs.first.message.include?(target)).to eq(true)
    end
  end
end
