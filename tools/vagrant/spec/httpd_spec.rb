require 'spec_helper'
require 'net/http'
config = YAML::load_file("../hobo/config.yaml")

describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_enabled   }
  it { should be_running   }
end

describe port(80) do
  it { should be_listening }
end

describe file("/etc/nginx/sites-enabled/#{config[:name]}") do
  it { should be_file }
  its(:content) { should match /server_name .*#{config[:hostname]}.*/ }
end

describe "HTTP OK" do
  it do
    Net::HTTP.get_response(URI.parse("http://#{config[:hostname]}")).should be_a Net::HTTPOK
  end
end
