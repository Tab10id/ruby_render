# frozen_string_literal: true

require 'bundler/setup'
require 'rack'
require_relative '../app/ruby_render'

Bundler.setup(:default)

app =
  Rack::Builder.new do |builder|
    builder.use Rack::Static, urls: ['/'], root: '../public', cascade: true
    builder.run RubyRender.new
  end

Rack::Handler.default.run(app, Host: '127.0.0.1')
# Rack::Server.start

# Rack::Server.start(app: RubyRender.new)
