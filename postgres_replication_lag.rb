#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'excon'

tl_host = "localhost"
tl_port = "50000"

def main
  time = `sudo -u postgres psql -tAc "SELECT NOW() - pg_last_xact_replay_timestamp()" 2> /dev/null`

  time[/(.*):(.*):(.*).(.*)/]

  hour = $1
  minute = $2
  second = $3

  hours_behind = hour.to_i * 60 * 60
  minutes_behind = minute.to_i * 60
  seconds_behind = hours_behind + minutes_behind + seconds_behind.to_i


  json = {
    "plugin_id" => "postgresql_replication_lag",
    "tags" => ["postgresql", "replication", "lag"],
    "data" => seconds_behind
  }.to_json

  response = Excon.post("http://#{tl_host}:#{tl_port}", :body => json)
end

main