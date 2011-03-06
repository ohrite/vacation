require File.expand_path('../../spec_helper', __FILE__)

describe Vacation::Jekyll do
  let (:jk) { Vacation::Jekyll.new(fake_jekyll) }

  describe '#initialize' do
    it 'should assign the path to a Jekyll blog' do
      jk.source.should == fake_jekyll
    end
    
    { 'not valid' => '/trøløløl', 'not readable' => '/var/root', 'not a directory' => __FILE__ }.each do |reason, path|
      it "should bail if the path is #{reason}" do
        lambda {
          Vacation::Jekyll.new(path)
        }.should raise_exception
      end
    end
  end

  describe '#compile_to' do
    let(:temp_dir) { Dir.mktmpdir }
    let(:index_path) { File.expand_path('index.html', temp_dir) }
    after { FileUtils.remove_entry_secure temp_dir }
    
    it 'should compile that sumbitch to a tempdir' do
      jk.compile_to(temp_dir)
      
      File.exists?(index_path).should be_true
      index_content = IO.read(index_path)
      
      index = Nokogiri::HTML.parse(index_content)
      index.css('title').inner_text.should == 'Index'
      index.css('h4').count.should == 2
    end
    
    it 'should create the destination directory if it does not exist' do
      Dir.rmdir(temp_dir)
      File.exists?(temp_dir).should be_false
      
      jk.compile_to(temp_dir)
      File.exists?(index_path).should be_true
    end
    
    it 'should throw an exception if the destination is not writable' do
      lambda {
        jk.compile_to('/var/root')
      }.should raise_exception
    end
  end
end