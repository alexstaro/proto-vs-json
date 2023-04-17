require 'benchmark/ips'
require 'yajl'
require 'oj'
require 'json'
require_relative 'integers_array_pb'

data = {
  field1: [
    2312345434234, 31415926, 43161592, 23141596, 61415923, 323423434343443, 53141926, 13145926, 323423434343443, 43161592
  ]
}

proto_model = TestData.new(data)
proto_encoded_data = TestData.encode(proto_model)
json_encoded_data = JSON.dump(data)

puts "JSON payload bytesize #{json_encoded_data.bytesize}"
puts "Protobuf payload bytesize #{proto_encoded_data.bytesize}"

Benchmark.ips do |x|
  x.config(time: 20, warmup: 5)

  x.report('yajl encoder') do
    Yajl::Encoder.encode(data)
  end

  x.report('oj encoder') do
    Oj.dump(data)
  end

  x.report('standard JSON encoding') do
    JSON.dump(data)
  end

  x.report('protobuf encoding') do
    TestData.encode(proto_model)
  end

  x.report('protobuf with model init') do
    TestData.new(data).to_proto
  end
  x.compare!
end

Benchmark.ips do |x|
  x.config(time: 20, warmup: 5)

  x.report('yajl parser') do
    Yajl::Parser.parse(json_encoded_data)
  end

  x.report('oj parser') do
    Oj.load(json_encoded_data)
  end

  x.report('standard JSON parser') do
    JSON.parse(json_encoded_data)
  end

  x.report('protobuf parser') do
    TestData.decode(proto_encoded_data)
  end

  x.compare!
end