require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet_facts'
include PuppetFacts

# The default set of platforms to test again.
ENV['UNIT_TEST_PLATFORMS'] = 'centos-6-x86_64 ubuntu-1404-x86_64'
PLATFORMS = ENV['UNIT_TEST_PLATFORMS'].split(' ')

RSpec.configure do |c|
  c.default_facts = {
    :apache_version => '2.2',
    :osfamily => 'RedHat',
    :operatingsystem => 'RedHat',
    :architecture => 'x86_64'
  }
end
