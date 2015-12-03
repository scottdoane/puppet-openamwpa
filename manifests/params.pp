# == Class: openam_wpa::params
#
class openam_wpa::params {
  $mode                  = 'enabled'
  $wpa_install_path      = '/opt'
  $wpa_version           = '4.0.0'
  $high_assurance        = true
  $use_puppetlabs_apache = false

  # Determine which version of the module to install
  if $::architecture == "x86_64" { $archtag = '64' } else { $archtag = '32' }
  case $::apache_version {
    /(2.2)/: {
      $apache_version_designator = '22'
      $installation_filename = "Apache_v22_Linux_${archtag}bit_${wpa_version}.zip"
    }
    /(2.4)/: {
      $apache_version_designator = '24'
      $installation_filename = "Apache_v24_Linux_${archtag}bit_${wpa_version}.zip"
    }
    default: {
      fail("Class['openam_wpa::params']: Unsupported Apache version: ${::apache_version}")
    }
  }

  case $::osfamily {
    /RedHat/: { $apache_confd_location = '/etc/httpd/conf.d'}
    default: { fail("Class['openam_wpa::params']: Unsupported osfamily: ${::osfamily}") }
  }

}
