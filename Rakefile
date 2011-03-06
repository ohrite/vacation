require 'rspec/core/rake_task'
import 'lib/tasks/deploy.rake'

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_path = 'rspec'
  t.rspec_opts = %w[--color]
  t.verbose = false
end

namespace :hammer do
  require 'vacation'
  desc "Fire a given S3 bucket out of a cannon into the sun"
  task :drop, :aws_access_id, :aws_secret_key, :s3_bucket do |t, args|
    s3 = Vacation::S3.new(args[:aws_access_id], args[:aws_secret_key], args[:s3_bucket])
    s3.strip_bucket
    s3.bucket.destroy
  end
end

task :default => [:spec]