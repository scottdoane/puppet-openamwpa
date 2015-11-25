# == Class: openam_wpa
#
class openam_wpa (
  $wpa_install_path      = $::openam_wpa::params::wpa_install_path,
  $installation_filename = $::openam_wpa::params::installation_filename,
  $high_assurance        = $::openam_wpa::params::high_assurance,
  $use_puppetlabs_apache = $::openam_wpa::params::use_puppetlabs_apache,
  ) inherits openam_wpa::params {

  include openam_wpa::install

  anchor { 'wpa_start': } ->
    Class['openam_wpa::install'] ->
  anchor { 'wpa_end': }

  openam_wpa::instance { "test-name":
    agent_number => '1',
    agent_realm_name => 'test-realm',
    openam_server_url => 'https://utlogin-test-core.its.utexas.edu:443',
    agent_url => 'https://localhost.localdomain:443',
    agent_password => 'asdfasdf', #$::wpa_agent_password,
    apache_confd_location => '/etc/httpd/conf.d',
    disable_config => false,
  }

  openam_wpa::instance { "other-name":
    agent_number => '2',
    agent_realm_name => 'test-realm',
    openam_server_url => 'https://utlogin-test-core.its.utexas.edu:443',
    agent_url => 'https://localhost.localdomain:443',
    agent_password => 'asdfasdf', #$::wpa_agent_password,
    apache_confd_location => '/etc/httpd/conf.d',
    disable_config => true,
  }

}
