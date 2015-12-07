# == Class: openam_wpa
#
class openam_wpa (
  $mode                  = $::openam_wpa::params::mode,
  $wpa_install_path      = $::openam_wpa::params::wpa_install_path,
  $installation_filename = $::openam_wpa::params::installation_filename,
  $high_assurance        = $::openam_wpa::params::high_assurance,
  $use_puppetlabs_apache = $::openam_wpa::params::use_puppetlabs_apache,
  ) inherits openam_wpa::params {

  # Validation Inputs
  # Anything not listed as an array is likely a regex below
  $valid_modes          = [ 'enabled', 'disabled', 'purged' ]

  validate_re($mode, $valid_modes)
  validate_absolute_path($wpa_install_path)
  validate_string($installation_filename)
  validate_bool($high_assurance)
  validate_bool($use_puppetlabs_apache)

  # Validation Architecture
  $valid_architectures = [ 'x86_64' ]
  $valid_osfamilies    = [ 'RedHat' ]

  validate_re($::architecture, $valid_architectures )
  validate_re($::osfamily, $valid_osfamilies)

  include openam_wpa::install

  anchor { 'wpa_start': } ->
    Class['::openam_wpa::install'] ->
  anchor { 'wpa_end': }

  openam_wpa::instance { "test-name":
    agent_number => '1',
    agent_realm_name => 'test-realm',
    openam_server_url => 'https://utlogin-test-core.its.utexas.edu:443',
    agent_url => 'https://localhost.localdomain:443',
    agent_password => 'asdfasdf', #$::agent_password,
    apache_confd_location => '/etc/httpd/conf.d',
    disable_config => false,
  }


}
