# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup(:default)

require 'rack'
require_relative '../app/ruby_render'

app = RubyRender.new

Rack::Server.start(
  app: Rack::ShowExceptions.new(app),
  Port: 9292
)
