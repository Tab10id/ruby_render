# frozen_string_literal: true

module Types
  # basic RGB-color definition
  class Color
    attr_reader :red, :green, :blue

    def initialize(red, green, blue)
      @red = red
      @green = green
      @blue = blue
    end

    def components
      [red, green, blue]
    end
  end
end
