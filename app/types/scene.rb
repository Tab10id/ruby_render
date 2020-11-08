# frozen_string_literal: true

require_relative 'color'
require_relative 'point'
require_relative 'sphere'

module Types
  # basic 3D-scene definitions
  class Scene
    attr_reader :spheres

    def initialize
      @spheres = []
    end

    def add_sphere(center, radius, color)
      @spheres <<
        Sphere.new(
          Types::Point.new(*center),
          radius,
          Types::Color.new(*color)
        )
    end
  end
end
