#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'excon'
require 'csv'

tl_host = "localhost"
tl_port = "50000"

file_path = "/proc/interrupts"
file_path = "./interrupts.data" # for testing

index = 0
cpu_count = 0
data = {}

File.readlines(file_path).each do |line|
  row_index = 0
  interrupt = {}

  if index == 0
    cpu_count = line.split.length
  else
    line.split.each do |thing|
      if row_index == 0
        # do nothing
      elsif row_index > cpu_count
        # do nothing
      else
        interrupt.store("CPU#{row_index - 1}", thing.split.first)
      end

      row_index += 1
    end
  end

  data.store(line.split.first.gsub(":", ""), interrupt)
  index += 1
end

json = {
  "plugin_id" => "interrupts",
  "tags" => ["cpu", "interrupts"],
  "data" => data
}.to_json

response = Excon.post("http://#{tl_host}:#{tl_port}", :body => json)