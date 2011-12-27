module Sublimate
  #todo: This seems like it could just be IO objects that map to portions of a file
  class ChunkedFile
    def initialize(path, opts={})
      @path = path
      @chunk_size = opts[:chunk_size] || (1024 * 1024 * 6)
    end

    def each_chunk
      counter = 0
      offset = 0
      file_size = File.size(@path)
      while offset < file_size
        data = IO.read(@path, @chunk_size, offset)
        details = {:counter => counter }
        yield(data, details)
        offset += @chunk_size
        counter += 1
      end
    end
  end
end
