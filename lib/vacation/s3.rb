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
    
    def backup_bucket_name
      "#{bucket_name}-vacation-backup"
    end
    
    def backup_bucket_directory
      @_backup_bucket_directory ||= Time.now.strftime("%Y-%m-%d@%H:%M:%S(%Z)")
    end
    
    def backup_bucket
      @_backup_bucket ||= storage.directories.create(:key => backup_bucket_name,
                                                      :privacy => 'private')
    end
    
    def strip_bucket
      bucket.files.reload.each { |file| file.destroy }
      bucket.files.reload
    end
    
    def backup
      bucket.files.reload.map(&:key).each do |file|
        storage.copy_object(bucket_name, file, backup_bucket_name, File.join(backup_bucket_directory, file))
      end
      backup_bucket.files.reload
    end
    
    def download_from_bucket(path)
      return unless storage.directories.get(bucket_name)
      FileUtils.mkdir_p(path)
      
      bucket.files.each do |file|
        location = File.join(path, file.key)
        FileUtils.mkdir_p(File.dirname(location))
        File.open(location, 'w') do |local|
          local.write(file.body)
        end
      end
    end
    
    def upload_to_bucket(path)
      return unless File.exists? path

      strip_bucket
      
      Dir[File.join(path, '**', '*')].each do |file|
        relative_path = file[path.length + 1..-1]
        bucket.files.create(:key => relative_path, :body => File.read(file)) if File.file?(file)
      end
      
      bucket.files.reload
    end
    
    def deploy_to_bucket(path, options = { :backup => true })
      backup if options[:backup] && options[:backup] == true
      upload_to_bucket path
      storage.put_bucket_website bucket_name, 'index.html', :key => '404.html'
    end
  end
end
