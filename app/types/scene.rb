# frozen_string_literal: true

require_relative 'sphere'

module Types
  # basic 3D-scene definitions
  class Scene
    attr_reader :spheres

    def initialize
      @spheres = []
    end

    def add_sphere(center, radius, color)
      @spheres << Sphere.new(center, radius, color)
    end
  end
end
