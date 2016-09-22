module Puppet::Parser::Functions
  newfunction(:unzip_dirname, :type => :rvalue, :arity => 1, :doc => <<-EOS
    Returns the dirname of a path. Sensitive to the target node platform.
    EOS
  ) do |arguments|
    os  = self.lookupvar('::osfamily')
    arg = arguments[0]

    case os
    when 'windows'
      separator = %r{[/\\]}
      firstsep  = arg.match(/#{separator}/)
      root = firstsep ? firstsep[0] : '\\'
    else
      separator = %r{[/]}
      root      = '/'
    end

    string = arg.sub(/#{separator}+$/, '')
    file   = string.split(separator).last
    dir    = string.sub(/#{separator}+#{Regexp.escape(file)}$/, '')

    # Special cases
    if dir == string
      dir = '.'
    elsif dir == ''
      dir = root
    elsif (os == 'windows' and dir =~ /^\w:$/)
      dir = dir + root
    end

    return dir
  end
end
