require 'benchmark/ips'
require 'yajl'
require 'oj'
require 'json'
require_relative 'doubles_array_pb'

data = {
  field1: [
    2312.345434234, 31415.926, 4316.1592, 23141.596, 614159.23, 3234234.34343443, 53141.926, 13145.926, 323423.434343443, 43161.592
  ]
}

proto_model = TestData.new(data)
proto_encoded_data = TestData.encode(proto_model)
json_encoded_data = JSON.dump(data)

puts "JSON payload bytesize #{json_encoded_data.bytesize}"
puts "Protobuf payload bytesize #{proto_encoded_data.bytesize}"

Benchmark.ips do |x|
  x.config(time: 20, warmup: 5)

  x.report('Yajl encoding') do
    Yajl::Encoder.encode(data)
  end

  x.report('Oj encoding') do
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

  x.report('Yajl parsing') do
    Yajl::Parser.parse(json_encoded_data)
  end

  x.report('Oj parsing') do
    Oj.load(json_encoded_data)
  end

  x.report('standard JSON parsing') do
    JSON.parse(json_encoded_data)
  end

  x.report('protobuf parsing') do
    TestData.decode(proto_encoded_data)
  end

  x.compare!
end
