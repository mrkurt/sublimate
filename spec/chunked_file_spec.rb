require 'spec_helper'

describe Sublimate::ChunkedFile do
  it "should read a file in parts" do
    size = 2 ** 20 * 10
    path = '/tmp/sublimate.test'
    verify_path = '/tmp/sublimate.verify'
    File.open(path, 'w') do |fd|
      fd.truncate(size)
    end

    cf = Sublimate::ChunkedFile.new(path, :chunk_size => (size / 10).to_i)
    chunks = 0
    File.open(verify_path, 'wb') do |out|
      cf.each_chunk do |data|
        chunks += 1
        out.write(data)
      end
    end

    chunks.should == 10
    File.size(path).should == File.size(verify_path)
  end
end
