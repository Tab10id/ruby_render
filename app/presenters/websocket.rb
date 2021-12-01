# frozen_string_literal: true

require 'json'

module Presenters
  # present raw image data as websocket data for render on html canvas
  # @todo: implement data compression
  class Websocket
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def call
      data.flat_map { |a| a + [255] }
    end
  end
end
