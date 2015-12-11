# wpa_version.rb

def parse_wpa_version(version_string)
  version = ""
  version_string.each_line do |line|
    if line.match(/Version/)
      version = line.scan(/ Version: (.*)/)
    else
      version = version_string.scan(/ Version: (.*)/)
    end
  end
  return version.to_s
end

Facter.add('wpa_version') do
  setcode do
    case Facter.value('apache_version')
    when /2.2/
      if File.exists?('/opt/apache22_agent/bin/agentadmin')
        version = parse_wpa_version(%x(/opt/apache22_agent/bin/agentadmin --v))
      end
    when /2.4/
      if File.exists?('/opt/apache24_agent/bin/agentadmin')
        version = parse_wpa_version(%x(/opt/apache24_agent/bin/agentadmin --v))
      end
    else
      version = 'undef'
    end
  end
end
