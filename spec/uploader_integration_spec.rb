require 'spec_helper'

describe Sublimate::Uploader do
  describe "multipart uploads" do
    before(:all) do
      Fog.unmock!
    end

    after(:all) do
      Fog.mock!
    end

    it "uses multipart upload for s3" do
      if uploader = get_aws_store
        uploader.store_file(tmpfile(true), :key => 'aws-test')

        s3 = uploader.bucket.files.head('aws-test')
        File.size(tmpfile).should == s3.content_length
        #s3.destroy
      else
        puts "Skipped s3 test, missing API keys and no Fog mocking"
      end
    end

    it "creates a manifest for rackspace cloud" do
      if uploader = get_rackspace_store
        uploader.store_file(tmpfile(true), :key => 'rackspace-test')

        rs = uploader.bucket.files.head('rackspace-test')
        File.size(tmpfile).should == rs.content_length
        #rs.destroy
      else
        puts "Skipped Rackspace test, missing API keys and no Fog mocking"
      end
    end
  end

  it "does standard upload for smaller files" do
    fog = Fog::Storage.new(:provider => 'AWS', :aws_access_key_id => 'test', :aws_secret_access_key => 'test')
    bucket = fog.directories.get('sublimate-test')
    bucket = fog.directories.create(:key => 'sublimate-test') if bucket.nil?
    uploader = Sublimate::Uploader.new(bucket)
    uploader.store_file(tmpfile(1024 * 1024), :key => 'small-file')
    File.size(tmpfile).should == bucket.files.head('small-file').content_length
  end
end
