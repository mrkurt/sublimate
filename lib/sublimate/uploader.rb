module Sublimate
  class Uploader
    def initialize(attrs)
      @attrs = attrs

      fog_attrs = attrs.clone
      fog_attrs.delete(:auto_create_bucket)
      fog_attrs.delete(:multipart_chunk_size)
      fog_attrs.delete(:bucket)

      @fog_storage = Fog::Storage.new(fog_attrs)
    end

    def storage
      @fog_storage
    end

    def store_file(path, opts = {})
      opts = {:key => path}.merge(opts)
      size = File.size(path)

      bucket = @fog_storage.directories.get(opts[:bucket])
      if bucket.nil? && @attrs[:auto_create_bucket]
        bucket = @fog_storage.directories.create(:key => opts[:bucket])
      elsif bucket.nil?
        raise "bucket not found"
      end

      m = "do_multi_#{@attrs[:provider].downcase}"
      if respond_to?(m)
        chunked = ChunkedFile.new(path, :chunk_size => @attrs[:multipart_chunk_size])
        send(m, bucket, chunked, opts)
      else
        opts[:body] = File.open(path)
        bucket.files.create(opts)
      end
    end

    def do_multi_aws(bucket, chunked, opts)
      multi = @fog_storage.initiate_multipart_upload(opts[:bucket], opts[:key])
      upload_id = multi.body["UploadId"]
      results = []
      chunked.each_chunk do |data, details|
        part = @fog_storage.upload_part(opts[:bucket], opts[:key], upload_id, details[:counter] + 1, data)
        etag = part.headers['ETag']
        results << etag
      end

      completed_upload = @fog_storage.complete_multipart_upload(opts[:bucket], opts[:key], upload_id, results)
    end

    def do_multi_rackspace(bucket, chunked, opts)
      count = 1
      chunked.each_chunk do |data, details|
        key = opts[:key] + "/#{count}"
        bucket.files.create(:key => key, :body => data)
        count += 1
      end
      result = @fog_storage.put_object_manifest(bucket.identity, opts[:key])
    end

  end
end
