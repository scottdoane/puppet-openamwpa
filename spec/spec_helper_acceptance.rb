require 'beaker-rspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

UNSUPPORTED_PLATFORMS     = [ 'Windows', 'Solaris', 'AIX' ]
UNSUPPORTED_ARCHITECTURES = [ 'i386' ]

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'openam_wpa')
    hosts.each do |host|
      # Tell beaker that we're operating in the CI environment
      shell ('export FACTER_app_env="ci"')

      # copy over private key
      # This is kinda hackey-- there's no good way to really do this right now
      # We need the administrative user, and its key
      # shell("groupadd -g 59006 iamops-ci && useradd -u 59006 -g 59006 -s /bin/bash iamops-ci")
      # shell("mkdir -p /home/iamops-ci/.ssh")
      # shell("chmod 0700 /home/iamops-ci/.ssh")
      # scp_to hosts, "#{proj_root}/files/iamops_id_rsa.key", '/home/iamops-ci/.ssh/id_rsa'
      # shell("chmod 0600 /home/iamops-ci/.ssh/id_rsa")
      # shell("chown -R iamops. /home/iamops-ci")

      # Required for binding tests.
      if fact('osfamily') == 'RedHat'
        # shell("/sbin/init")
        shell("yum install -y tar rsyslog crontabs")
        version = fact("operatingsystemmajrelease")
        if fact('operatingsystemmajrelease') =~ /7/ || fact('operatingsystem') =~ /Fedora/
          shell("yum install -y bzip2")
        end
      end
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
