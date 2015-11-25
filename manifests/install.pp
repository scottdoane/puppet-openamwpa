# == Class: openam_wap::install
#
class openam_wpa::install
  inherits ::openam_wpa::params {

  Exec {
    cwd  => $wpa_install_path,
    path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin'
  }
  package { 'unzip': ensure => present }

  # Conditional logic required
  # Since we can get the version of the installed agent
  # if the version of the installed agent doesn't match the version
  #  presented by the module config, do an install/overwrite

  if ($::wpa_version != $wpa_version) {
    file { "/tmp/$installation_filename":
      ensure => file,
      mode => '0644',
      source => "puppet:///modules/openam_wpa/$installation_filename"
    } ->
    exec { "Unzip $installation_filename into $wpa_install_path":
      command => "unzip /tmp/$installation_filename -d $wpa_install_path",
      creates => "${$wpa_install_path}/web_agents/apache${apache_version_designator}_agent",
    } ->
    file { '/usr/local/bin/agentadmin':
      ensure => link,
      mode => '0644',
      target => "${$wpa_install_path}/web_agents/apache${apache_version_designator}_agent/bin/agentadmin"
    } ->
    exec { "rm /tmp/$installation_filename": }
  }

  if ($use_puppetlabs_apache) {
    include apache
    apache::mod { 'amagent':
      package => nil,
      package_ensure => absent,
      lib => 'mod_openam.so',
      lib_path => "/opt/web_agents/apache${apache_version_designator}_agent/lib"
    }
  } else {
    file { "$apache_confd_location/00-mod_openam.conf":
      ensure => file,
      mode => '0644',
      content => template('openam_wpa/mod_openam.conf.erb')
    }
  }

  if ($high_assurance) {
    file { "$apache_confd_location/99-amagent_high_assurance.conf":
      ensure => file,
      mode => '0644',
      content => template('openam_wpa/high_assurance.conf.erb')
    }
  }

}
