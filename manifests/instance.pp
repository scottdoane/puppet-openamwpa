# == Define: openam_wpa::instance
#
# Based on the 4.0 Instances
# Install agent instance (silent):
# agentadmin --s "web-server configuration file, directory or site parameter" \
#                "OpenAM URL" "Agent URL" "realm" "agent user id" \
#                "path to the agent password file" [--changeOwner] [--acceptLicence] [--forceInstall]
#
define openam_wpa::instance (
  $order = '25',
  $agent_number,
  $openam_server_url,
  $agent_url,
  $agent_realm_name,
  $agent_profile_name = $title,
  $agent_password = undef,
  $agent_password_file = undef,
  $apache_confd_location = $::openam_wpa::params::apache_confd_location,
  $sso_agent_file = undef,
  $disable_config = undef,
  ) {
  # Pull in a couple necessary paramaters
  $apache_version_designator = $::openam_wpa::params::apache_version_designator

  # Deal with the password
  if ($agent_password) {
    $password_file = "/tmp/wpa-${agent_profile_name}-password.txt"
    file { "/tmp/wpa-${agent_profile_name}-password.txt":
      ensure => file,
      mode => '0640',
      content => $agent_password
    }
  } else {
    $password_file = $agent_password_file
  }


  # The installation process requires the apache configuration as part
  #   of the process.
  # We're circumventing this providing it a fake configuration file.
  #   However, the installer doesn't deem an apache configuration valid if it
  #   does not contain the phrase "LoadModule"
  #   ...
  file { "/tmp/wpa-${agent_profile_name}-temp.conf":
    ensure => file,
    mode => '0644',
    content => "# LoadModule"
  } ->
  exec { "Creating WPA instance for $agent_profile_name":
    command => "agentadmin --s \
      '/tmp/wpa-${agent_profile_name}-temp.conf' \
      '${openam_server_url}' \
      '${agent_url}' \
      '${agent_realm_name}' \
      '${agent_profile_name}' \
      '${password_file}' \
      --changeOwner \
      --acceptLicence \
      --forceInstall",
    path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    creates => "/opt/web_agents/apache${apache_version_designator}_agent/instances/agent_${agent_number}",
  }

  # Link it up to Apache
  if ($disable_config) { $disable = '.disabled' } else { $disable = '' }

  file { "$apache_confd_location/${agent_number}-amagent_${agent_number}.conf${disable}":
    ensure => file,
    mode => '0644',
    owner => 'root',
    group => 'root',
    content => template('openam_wpa/amagent.conf.erb')
  }

}
