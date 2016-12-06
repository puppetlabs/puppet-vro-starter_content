#!/usr/bin/ruby
#
#
# author: Liam Bennett
#
# Written to determine the architecture from the SystemType 
#   http://msdn.microsoft.com/en-us/library/windows/desktop/aa394102(v=vs.85).aspx

Facter.add("windows_systemtype") do
  confine :kernel => :windows
  
  systemtype = "unknown"
  begin
    
    if RUBY_PLATFORM.downcase.include?("mswin") or RUBY_PLATFORM.downcase.include?("mingw32")
      systemtype = Facter::Util::Resolution.exec('wmic ComputerSystem get SystemType | FindStr /i x')
      systemtype.gsub!(/-based PC/,'')
      systemtype.gsub!(/\s/,'')
      systemtype.downcase!
    end
  rescue

  end

  setcode do
    systemtype
  end
end
