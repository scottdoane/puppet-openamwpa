require 'spec_helper'
describe 'openam_wpa', :type => :class do

  context 'with defaults for all parameters' do
    it { is_expected.to compile.with_all_deps }
    it { should contain_anchor('wpa_start') }
    it { should contain_class('openam_wpa::install') }
    it { should contain_anchor('wpa_end') }
    it { should contain_class('openam_wpa') }
  end

  context 'with apache_version => null' do
    let(:facts) do { :apache_version => '' }
      it { is_expected.to raise_error(Puppet::PreformattedError, /\"Unsupported Apache version\"/) }
    end
  end

  context 'with osfamily => Debian' do
    let (:facts) do { :osfamily => 'Debian', }
      it { is_expected.to raise_error(Puppet::PreformattedError, /\"Unsupported osfamily\"/) }
    end
  end

  context 'with architecture => i386' do
    let (:facts) do { :architecture => 'i386' }
      it { is_expected.to raise_error(Puppet::PreformattedError, /\"i386\" does not match/) }
    end
  end

end
