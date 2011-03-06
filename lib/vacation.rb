require 'rubygems'
require File.expand_path('../vacation/s3', __FILE__)
require File.expand_path('../vacation/jekyll', __FILE__)

module Vacation
  unless const_defined?(:VERSION)
    VERSION = '0.1.1'
  end
end

