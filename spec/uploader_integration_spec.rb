require 'spec_helper'

describe Sublimate::Uploader do
  before(:all) do
    Fog.unmock!
  end

  after(:all) do
    Fog.mock!
  end

  it "uses multipart upload for s3" do
    if uploader = get_aws_store
      bucket = uploader.storage.directories.get('sublimate-test')

      uploader.store_file(tmpfile, :bucket => 'sublimate-test', :key => 'aws-test')

      s3 = bucket.files.head('aws-test')
      File.size(tmpfile).should == s3.content_length
      s3.destroy
    else
      puts "Skipped s3 test, missing API keys and no Fog mocking"
    end
  end

  it "creates a manifest for rackspace cloud" do
    if uploader = get_rackspace_store
      bucket = uploader.storage.directories.get('sublimate-test')

      uploader.store_file(tmpfile, :bucket => 'sublimate-test', :key => 'rackspace-test')

      rs = bucket.files.head('rackspace-test')
      File.size(tmpfile).should == rs.content_length
      rs.destroy
    else
      puts "Skipped Rackspace test, missing API keys and no Fog mocking"
    end
  end
end
