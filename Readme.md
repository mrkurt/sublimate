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
