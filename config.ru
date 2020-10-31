# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup(:default)

require ::File.expand_path('app/ruby_render', __dir__)
use Rack::Static, urls: ['/'], root: 'public', cascade: true
run RubyRender.new
