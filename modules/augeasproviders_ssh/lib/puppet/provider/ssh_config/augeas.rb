# Alternative Augeas-based providers for Puppet
#
# Copyright (c) 2012 Raphaël Pinson
# Licensed under the Apache License, Version 2.0


Puppet::Type.type(:ssh_config).provide(:augeas, :parent => Puppet::Type.type(:augeasprovider).provider(:default)) do
  desc "Uses Augeas API to update an ssh_config parameter"

  default_file { '/etc/ssh/ssh_config' }

  lens { 'Ssh.lns' }

  confine :feature => :augeas

  resource_path do |resource|
    base = self.base_path(resource)
    key = resource[:key] ? resource[:key] : resource[:name]
    if supported?(:regexpi)
      "#{base}/*[label()=~regexp('#{key}', 'i')]"
    else
      debug "Warning: Augeas >= 1.0.0 is required for case-insensitive support in ssh_config resources"
      "#{base}/#{key}"
    end
  end

  def self.base_path(resource)
    "$target/Host[.='#{resource[:host]}']"
  end

  def self.instances
    augopen do |aug,path|
      resources = []
      aug.match('$target/Host').each do |hpath|
        aug.match("#{hpath}/*").each do |kpath|
          label = path_label(aug, kpath)
          next if label.start_with?("#")

          host = aug.get(hpath)
          value = self.get_value(aug, kpath)

          resources << new({
            :ensure => :present,
            :name   => label,
            :key    => label,
            :value  => value,
            :host   => host
          })
        end
      end
      resources
    end
  end

  def self.get_value(aug, pathx)
    aug.match(pathx).map do |vp|
      # Augeas lens does transparent multi-node (no counte reset) so check for any int
      if aug.match("#{vp}/*[label()=~regexp('[0-9]*')]").empty?
        aug.get(vp)
      else
        aug.match("#{vp}/*").map do |svp|
          aug.get(svp)
        end
      end
    end.flatten
  end

  def self.set_value(aug, base, path, label, value)
    if label =~ /Ciphers|SendEnv|MACs/i
      aug.rm("#{path}/*")
      # In case there is more than one entry, keep only the first one
      aug.rm("#{path}[position() != 1]")
      count = 0
      value.each do |v|
        count += 1
        aug.set("#{path}/#{count}", v)
      end
    else
      # Normal setting: one value per entry
      value = value.clone

      # Change any existing settings with this name
      lastsp = nil
      aug.match(path).each do |sp|
        val = value.shift
        if val.nil?
          aug.rm(sp)
        else
          aug.set(sp, val)
          lastsp = sp
        end
      end

      # Insert new values for the rest
      value.each do |v|
        if lastsp
          # After the most recent same setting (lastsp)
          aug.insert(lastsp, label, false)
          aug.set("#{path}[last()]", v)
        else
          # Prefer to create the node next to a commented out entry
          commented = aug.match("#{base}/#comment[.=~regexp('#{label}([^a-z\.].*)?')]")
          unless commented.empty?
            aug.insert(commented.first, label, false)
          end
          aug.set("#{path}[last()]", v)
        end
        lastsp = aug.match("#{path}[last()]")[0]
      end
    end
  end

  def create
    base_path = self.class.base_path(resource)
    augopen! do |aug|
      key = resource[:key] ? resource[:key] : resource[:name]
      # create base_path
      aug.set(base_path, resource[:host])
      self.class.set_value(aug, base_path, "#{base_path}/#{key}", key, resource[:value])
    end
  end

  def value
    augopen do |aug|
      self.class.get_value(aug, '$resource')
    end
  end

  def value=(value)
    augopen! do |aug|
      key = resource[:key] ? resource[:key] : resource[:name]
      self.class.set_value(aug, self.class.base_path(resource), resource_path, key, value)
    end
  end
end
