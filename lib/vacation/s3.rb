require 'fog'
require 'tmpdir'

module Vacation
  class S3
    attr_reader :access_key_id, :secret_access_key, :storage, :bucket_name
    
    def initialize(id, key, bucket)
      @access_key_id = id
      @secret_access_key = key
      @bucket_name = bucket
      @storage = Fog::Storage.new(
        :provider => 'AWS',
        :aws_access_key_id => access_key_id,
        :aws_secret_access_key => secret_access_key
      )
    end
    
    def bucket
      @_bucket ||= storage.directories.create(:key => bucket_name, :privacy => 'public-read')
    end
    
    def backup_bucket
      @_backup_bucket ||= storage.directories.create(:key => "#{bucket_name}-vacation-backup",
                                                      :privacy => 'private')
    end
    
    def strip_bucket
      bucket.files.reload.each { |file| file.destroy }
      bucket.files.reload
    end
    
    def download_from_bucket(path)
      FileUtils.mkdir_p(path)
      
      bucket.files.each do |file|
        location = File.join(path, file.key)
        FileUtils.mkdir_p(File.dirname(location))
        File.open(location, 'w') do |local|
          local.write(file.body)
        end
      end
    end
    
    def upload_to_bucket(path, backup = false)
      return unless File.exists? path

      strip_bucket unless backup
      target = backup ? backup_bucket : bucket
      
      Dir[File.join(path, '**', '*')].each do |file|
        relative_path = file[path.length + 1..-1]
        target.files.create(:key => relative_path, :body => File.read(file)) if File.file?(file)
      end
      
      target.files.reload
    end
    
    def deploy_to_bucket(path, options = { :backup => true })
      if options[:backup] && options[:backup] == true
        Dir.mktmpdir do |temp_dir|
          backup_dir = File.expand_path(Time.now.strftime("%Y-%m-%d@%H:%M:%S(%Z)"), temp_dir)
          FileUtils.mkdir backup_dir
          
          download_from_bucket(backup_dir)
          upload_to_bucket(temp_dir, true)
        end
      end
      
      storage.put_bucket_website bucket_name, 'index.html', :key => '404.html'
      
      upload_to_bucket(path)
    end
  end
end
