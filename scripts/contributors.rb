#!/usr/bin/env ruby

require 'net/http'
require 'openssl'
require 'json'

API_HOST = 'api.github.com'.freeze
API_URL = '/repos/greatghoul/remote-working/stats/contributors'.freeze

http = Net::HTTP.new(API_HOST, 443)
http.use_ssl = true
response = http.send_request(
  'GET', API_URL, nil,
  Accept: 'application/vnd.github.v3+json'
)

contributors = JSON.parse(response.body)

contributors.map! do |contributor|
  author = contributor['author']
  Hash[{
    login: author['login'],
    avatar_url: author['avatar_url'],
    url: author['url'],
    commits: contributor['total']
  }]
end
contributors.sort_by! { |contributor| -contributor[:commits] }
contributors.take(10).each do |contributor|
  puts "<img src=\"#{contributor[:avatar_url]}\" width=\"18\" height=\"18\" " \
       'style="vertical-align:middle;"> ' \
       "<a href=\"#{contributor[:url]}\">#{contributor[:login]}</a> | " \
       "#{contributor[:commits]}"
end
