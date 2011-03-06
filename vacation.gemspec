lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'vacation'
 
Gem::Specification.new do |s|
  s.name        = "vacation"
  s.version     = Vacation::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Doc Ritezel"]
  s.email       = ['ritezel+doc@gmail.com']
  s.homepage    = "http://github.com/ohrite/vacation"
  s.summary     = "Send your Jekyll blog on an S3 vacation"
  s.description = "You got your peanut butter on my static file host!  You got your static blog content on my chocolate!"
 
  s.required_rubygems_version = ">= 1.3.6"
 
  s.add_development_dependency "rspec"
  s.add_dependency "fog"
  s.add_dependency "jekyll"
 
  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {spec}/*`.split("\n")
  s.require_path       = 'lib'
  s.executables        = %w(vacation)
  s.default_executable = "vacation"
end
