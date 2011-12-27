# rackspace cloud: http://www.rackspace.com/knowledge_center/index.php/Does_Cloud_Files_support_large_file_transfer
# s3: https://gist.github.com/908875
# Google Storage apparently allows single PUTs up to 50GB
module Sublimate
end
require 'fog'
require 'sublimate/chunked_file'
require 'sublimate/uploader'
