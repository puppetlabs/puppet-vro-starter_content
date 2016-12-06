#!/usr/bin/ruby
#
#
# author: Liam Bennett
#
# Written to determine the computer SID for the current windows machine.
#
Facter.add("windows_sid") do
  confine :kernel => :windows
  
  productkey = "unknown"
  begin
    
    if RUBY_PLATFORM.downcase.include?("mswin") or RUBY_PLATFORM.downcase.include?("mingw32")
      require 'win32/registry'
      
      KEY_WOW64_64KEY = 0x100 unless defined? KEY_WOW64_64KEY
      access = Win32::Registry::KEY_READ | KEY_WOW64_64KEY
      key = 'Software\Microsoft\Windows\CurrentVersion\Group Policy'
    
      Win32::Registry::HKEY_LOCAL_MACHINE.open(key, access) do |reg|
        reg.keys.each do |key|
          if key.start_with?('S-1-5-21')
            productkey = key.gsub(/-500$/,"")   
          end
        end
      end
    end
  rescue

  end

  setcode do
    productkey
  end
end