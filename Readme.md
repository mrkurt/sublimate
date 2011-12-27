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
You'll need an instance of `Sublimate::Uploader`. Just pass it a Fog bucket/directory and call `store_file`

Example:

```ruby
opts = {
  :provider => 'AWS',
  :aws_access_key_id => ENV['AWS_ACCESS_KEY'],
  :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
}
s3 = Fog::Storage.new(opts)
bucket = s3.directories.get('HUGE-FILES')
uploader = Sublimate::Uploader.new(bucket)
upload.store_file(path, :key => 'something.iso')
```
