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


}