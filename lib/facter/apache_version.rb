# apache_version.rb

def parse_apache_version(version_string)
  version = ""
  version_string.each_line do |line|
    if line.match(/^Server version/)
      version = line.scan(/Apache\/(.*) /)
    end
  end
  return version.to_s
end

Facter.add('apache_version') do
  setcode do
    case Facter.value('osfamily')
    when /RedHat/
      if File.exists?('/usr/sbin/apachectl')
        version = parse_apache_version(%x(/usr/sbin/apachectl -v))
      end
    when /Debian/
      if File.exists?('/usr/sbin/apache2')
        version = parse_apache_version(%x(/usr/sbin/apache2 -v))
      end
    else
      version = 'undef'
    end
  end
end
