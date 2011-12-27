module Sublimate
  class Uploader
    def initialize(bucket, opts = {})
      @bucket = bucket
      @opts = opts
    end

    attr_accessor :bucket
    def store_file(path, opts = {})
      opts = {:key => path}.merge(opts)
      size = File.size(path)

      m = multi_method_name
      if respond_to?(m)
        chunked = ChunkedFile.new(path, :chunk_size => @opts[:multipart_chunk_size])
        send(m, chunked, opts)
      else
        opts[:body] = File.open(path)
        bucket.files.create(opts)
      end
    end

    def multi_method_name
      n = bucket.connection.service.to_s.split('::').last.downcase
      "do_multi_#{n}"
    end

    def do_multi_aws(chunked, opts)
      multi = bucket.connection.initiate_multipart_upload(bucket.key, opts[:key])
      upload_id = multi.body["UploadId"]
      results = []
      chunked.each_chunk do |data, details|
        part = bucket.connection.upload_part(bucket.key, opts[:key], upload_id, details[:counter] + 1, data)
        etag = part.headers['ETag']
        results << etag
      end

      completed_upload = bucket.connection.complete_multipart_upload(bucket.key, opts[:key], upload_id, results)
    end

    def do_multi_rackspace(chunked, opts)
      count = 1
      chunked.each_chunk do |data, details|
        key = opts[:key] + "/#{count}"
        bucket.files.create(:key => key, :body => data)
        count += 1
      end
      result = bucket.connection.put_object_manifest(bucket.key, opts[:key])
    end

  end
end
