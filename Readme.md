Sublimate
=========

This is a helper library for uploading extremely large files using Fog. It splits them into chunks and uses multipart uploads on S3 or the manifest file on Rackspace Cloud.

Set the following environment variables to run real, live tests (Mocks don't work for multipart stuff in Fog yet):

* AWS:
  * AWS_ACCESS_KEY
  * AWS_SECRET_ACCESS_KEY
* Rackspace
  * RACKSPACE_USERNAME
  * RACKSPACE_API_KEY


Usage
=====
You'll need an instance of `Sublimate::Uploader`. Initialize with the options you'd use to create a Fog storage instance.

Example:
```ruby
opts = {
  :provider => 'AWS',
  :aws_access_key_id => ENV['AWS_ACCESS_KEY'],
  :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  :auto_create_bucket => true
}
uploader = Sublimate::Uploader.new(opts)
upload.store_file(path, :bucket => 'large-file-bucket', :key => 'something.iso')
```
