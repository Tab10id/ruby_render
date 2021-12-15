# frozen_string_literal: true

require_relative 'color'
require_relative 'directional_light'
require_relative 'point'
require_relative 'point_light'
require_relative 'sphere'

module Types
  # basic 3D-scene definitions
  class Scene
    attr_reader :spheres, :ambient_light, :point_lights, :directional_lights

    def initialize
      @spheres = []
      @ambient_light = 0
      @point_lights = []
      @directional_lights = []
    end

    def add_sphere(center, radius, color)
      @spheres <<
        Sphere.new(
          Types::Point.new(*center),
          radius,
          Types::Color.new(*color)
        )
    end

    def ambient_light!(intensity:)
      @ambient_light = intensity
    end

    def add_point_light(position:, intensity:)
      @point_lights << Types::PointLight.new(Types::Point.new(*position), intensity)
    end

    def add_directional_light(direction:, intensity:)
      @directional_lights << Types::DirectionalLight.new(Types::Point.new(*direction), intensity)
    end
  end
end
