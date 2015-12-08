require 'spec_helper'
describe 'openam_wpa::install' do
  context "on RedHat OS" do
    let (:facts) {{
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :architecture => 'x86_64',
        :apache_version => '2.2',
        :wpa_version => '4.0.0'
      }}
    let (:params) {{
        :wpa_install_path => '/opt',
        :apache_version_designator => '22'
      }}

    describe 'should ensure that required packages are present' do
      it { should contain_package('unzip').with(
        :ensure => 'present'
      )}
    end

    context "when wpa version is null" do
      let :default_facts do
        { :wpa_version => '', }
      end
      let :facts do default_facts end
      it { is_expected.to contain_class("openam_wpa::params") }
      it { is_expected.to contain_file("/tmp/Apache_v22_Linux_64bit_4.0.0.zip").with(
        'ensure' => 'file',
        'mode'   => '0644',
      )}
      it { is_expected.to contain_exec("Unzip Apache_v22_Linux_64bit_4.0.0.zip into /opt").with(
        'command' => "unzip /tmp/Apache_v22_Linux_64bit_4.0.0.zip -d /opt",
        'creates' => "/opt/apache22_agent",
      )}
      it { is_expected.to contain_file("/usr/local/bin/agentadmin").with(
        'ensure'  => 'link',
        'mode'    => '0644',
        'target'  => "/opt/apache22_agent/bin/agentadmin"
      )}
    end
  end
end
