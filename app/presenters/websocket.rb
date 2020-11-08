# frozen_string_literal: true

require 'json'

module Presenters
  # present raw image date as websocket data for render on html canvas
  # @todo: implement data compression
  class Websocket
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def call
      data.to_json
    end
  end
end
