lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'vacation'
require 'rspec'
require 'tmpdir'
require 'yaml'
require 'nokogiri'

def fake_jekyll
  File.expand_path('../support/jekyll', __FILE__)
end

def aws_creds
  YAML.load(File.expand_path('../support/credentials.yml', __FILE__))['aws']
end

RSpec.configure do |c|
  c.mock_with :rspec
end
