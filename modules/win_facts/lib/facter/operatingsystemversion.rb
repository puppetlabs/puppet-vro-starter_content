#!/usr/bin/ruby
#
#
# author: Liam Bennett
#
# Written to work out the version of windows that the client is currently being run on.
#
Facter.add("operatingsystemversion") do
  confine :kernel => :windows
  
  operatingsystemversion = "unknown"
  begin
    
    if RUBY_PLATFORM.downcase.include?("mswin") or RUBY_PLATFORM.downcase.include?("mingw32")
      require 'win32/registry'
    
      Win32::Registry::HKEY_LOCAL_MACHINE.open('Software\Microsoft\Windows NT\CurrentVersion') do |reg|
        reg.each do |name,type,data|
          if name.eql?("ProductName")
            operatingsystemversion = data
          end
        end
      end
    end
  rescue

  end

  setcode do
    operatingsystemversion
  end
end