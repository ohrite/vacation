require File.expand_path('../../vacation', __FILE__)

namespace :vacation do
  require 'tmpdir'
  
  desc 'Compile and deploy to S3'
  task :deploy, :aws_access_id, :aws_secret_key, :s3_bucket do |t, args|
    Dir.mktmpdir do |temp_dir|
      jekyll = Vacation::Jekyll.new(Dir.pwd)
      jekyll.compile_to(temp_dir)
      
      p args.inspect
      s3 = Vacation::S3.new(args[:aws_access_id], args[:aws_secret_key], args[:s3_bucket])
      s3.deploy_to_bucket(temp_dir)
    end
  end
end
