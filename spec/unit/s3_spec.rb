require File.expand_path('../../spec_helper', __FILE__)

describe Vacation::S3 do
  before { Fog.mock! }
  
  let(:bucket_name) { 'pants' }
  let(:s3) { Vacation::S3.new('fake', 'key', bucket_name)}
  let(:file) { s3.bucket.files.create(:key => 'socks/feet', :body => 'toes') }
  before { s3 && file }

  describe '#initialize' do
    it 'should assign AWS credentials' do
      s3.access_key_id.should == 'fake'
      s3.secret_access_key.should == 'key'
      s3.bucket_name.should == 'pants'
    end
  end
  
  describe '#strip_bucket' do
    it 'should destroy existing files' do
      s3.strip_bucket
      s3.bucket.files.count.should == 0
    end
  end
  
  describe '#download_from_bucket' do
    let(:temp_dir) { Dir.mktmpdir }
    after { FileUtils.remove_entry_secure temp_dir }
    
    it 'should create directories and files existing in the bucket' do
      s3.download_from_bucket temp_dir
      
      File.exists?(File.expand_path('socks', temp_dir)).should be_true
      File.exists?(File.expand_path('socks/feet', temp_dir)).should be_true
      File.read(File.expand_path('socks/feet', temp_dir)).should == 'toes'
    end
  end
  
  describe '#upload_to_bucket' do
    let(:temp_dir) { Dir.mktmpdir }
    after { FileUtils.remove_entry_secure temp_dir }

    it 'should pave over existing files' do
      lambda {
        s3.upload_to_bucket temp_dir
      }.should change { s3.bucket.files.reload.count }.by -1
    end
    
    it 'should create directories and files existing on the filesystem' do
      FileUtils.mkdir(File.expand_path('pocket', temp_dir))
      File.open(File.expand_path('pocket/chili', temp_dir), 'w') { |local| local.write('beans')}
      
      s3.upload_to_bucket temp_dir
      
      s3.bucket.files.count.should == 1
      s3.bucket.files.first.key.should == 'pocket/chili'
      s3.bucket.files.first.body.should == 'beans'
    end
  end
  
  describe '#backup' do
    let(:backup_bucket) { s3.storage.directories.create(:key => "#{bucket_name}-vacation-backup") }

    it 'should deploy to the specified bucket' do
      lambda {
        s3.backup
      }.should change { s3.backup_bucket.files.count }.by 2
    end
  end
  
  describe '#deploy_to_bucket' do
    it 'should obey a no-backup parameter' do
      s3.storage.stub!(:put_bucket_website) do |name, index, opts|
        name.should == s3.bucket.key
        index.should == 'index.html'
        opts[:key].should == '404.html'
      end
      
      lambda {
        s3.deploy_to_bucket fake_jekyll, :backup => false
      }.should_not change{ s3.backup_bucket.files.count }
    end

    it 'should enable the static hosting parameter and pages' do
      pending 'this functionality is not mocked out in Fog yet'
      s3.deploy_to_bucket fake_jekyll
      s3.storage.get_bucket_website(s3.bucket.key).body['IndexDocument']['Suffix'].should == 'index.html'
      s3.storage.get_bucket_website(s3.bucket.key).body['ErrorDocument']['Key'].should == '404.html'
    end
  end
end