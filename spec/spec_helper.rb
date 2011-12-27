require 'fog'
require 'sublimate'

Fog.mock!

Sublimate::ChunkedFile.default_chunk_size = 1024 * 1024 * 6
Sublimate::Uploader.multipart_min_size = 1024 * 1024 * 10 #for faster testing

module Helpers
  def get_google_store
    storage = Fog::Storage.new(:provider => 'Google',
          :google_storage_access_key_id => 'test',
          :google_storage_secret_access_key => 'test')
    test_uploader(storage)
  end
  
  def get_rackspace_store
    return nil unless ENV['RACKSPACE_USERNAME'] || ENV['RACKSPACE_API_KEY']
    storage = Fog::Storage.new(:provider => 'Rackspace',
          :rackspace_username => ENV['RACKSPACE_USERNAME'],
          :rackspace_api_key => ENV['RACKSPACE_API_KEY'])
    test_uploader(storage)
  end
  def get_aws_store
    return nil unless ENV['AWS_ACCESS_KEY'] && ENV['AWS_SECRET_ACCESS_KEY']
    opts = {
      :provider => 'AWS',
      :aws_access_key_id => ENV['AWS_ACCESS_KEY'],
      :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    }
    storage = Fog::Storage.new(opts)
    test_uploader(storage)
  end

  def test_uploader(storage)
    bucket = storage.directories.get('sublimate-test')
    bucket = storage.directories.create('sublimate-test') if bucket.nil?
    Sublimate::Uploader.new(bucket)
  end

  def tmpfile(recreate = false)
    tmp = '/tmp/uploader-test'
    return tmp if File.exist?(tmp) && !recreate
    File.open(tmp, 'wb') do |f|
      size =  if recreate.is_a?(Numeric)
                recreate
              else
                1024 * 1024 * 10 * (1 + rand(0.9)) #randomizes sizes so tests mostly work while overwriting
              end
      f.truncate(size.to_i)
    end
    tmp
  end

  def tmpout
    '/tmp/uploader-test-verify'
  end
end

RSpec.configure do |c|
  c.include Helpers
end
