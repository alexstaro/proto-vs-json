# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: integers_array.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("integers_array.proto", :syntax => :proto3) do
    add_message "TestData" do
      repeated :field1, :int64, 1
    end
  end
end

TestData = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("TestData").msgclass
