require 'fog'
require 'sublimate'

Fog.mock!

module Helpers
  def get_google_store
    Sublimate::Uploader.new(:provider => 'Google',
          :google_storage_access_key_id => 'test',
          :google_storage_secret_access_key => 'test',
          :auto_create_bucket => true)
  end
  
  def get_rackspace_store
    return nil unless ENV['RACKSPACE_USERNAME'] || ENV['RACKSPACE_API_KEY']
    Sublimate::Uploader.new(:provider => 'Rackspace',
          :rackspace_username => ENV['RACKSPACE_USERNAME'],
          :rackspace_api_key => ENV['RACKSPACE_API_KEY'],
          :auto_create_bucket => true)
  end
  def get_aws_store
    return nil unless ENV['AWS_ACCESS_KEY'] && ENV['AWS_SECRET_ACCESS_KEY']
    opts = {
      :provider => 'AWS',
      :aws_access_key_id => ENV['AWS_ACCESS_KEY'],
      :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
      :bucket => 'sublimate-test',
      :auto_create_bucket => true
    }
    Sublimate::Uploader.new(opts)
  end

  def tmpfile
    tmp = '/tmp/uploader-test'
    return tmp if File.exist?(tmp)
    File.open(tmp, 'wb') do |f|
      f.truncate(1024 * 1024 * 10)
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
