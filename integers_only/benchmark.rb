require 'benchmark/ips'
require 'yajl'
require 'oj'
require 'json'
require_relative 'integers_pb'

data = {
  field1: 2312345434234,
  field2: 31415926,
  field3: 43161592,
  field4: 23141596,
  field5: 61415923,
  field6: 323423434343443,
  field7: 53141926,
  field8: 13145926,
  field9: 323423434343443,
  field10: 43161592
}

proto_model = TestData.new(data)
proto_encoded_data = proto_model.to_proto
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
