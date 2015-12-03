require 'spec_helper'

describe 'openam_wpa::params', :type => :class do
  it { is_expected.to contain_openam_wpa__params }

  it "Should not contain any resources" do
    should have_resource_count(0)
  end
end
