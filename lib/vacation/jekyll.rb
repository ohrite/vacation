require 'jekyll'

module Vacation
  class Jekyll
    attr_accessor :source
    
    def initialize(source)
      @source = source
      throw StandardError unless File::readable_real?(source) and File::directory?(source)
    end
    
    def config_hash
      config_file = File.join(source, '_config.yml')
      begin
        config = YAML.load_file(config_file)
      rescue => err
        config = {}
      end
      
      ::Jekyll::DEFAULTS.deep_merge(config).deep_merge('source' => source)
    end
    
    def compile_to(destination, options = {})
      options = config_hash.deep_merge('destination' => destination).deep_merge(options)
      site = ::Jekyll::Site.new options
      site.process
    end
  end
end
