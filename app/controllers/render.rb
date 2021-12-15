# frozen_string_literal: true

require_relative '../presenters/websocket'
require_relative '../interactors/ray_tracing'
require_relative '../types/scene'
require_relative '../types/size'

module Controllers
  # Scene render controller
  # prepare scene by user input (not implemented yet)
  # call raytracer or rasterization (not implemented yet) class
  # present result as
  # - image file (not implemented yet)
  # - websocket data (for render on html canvas)
  class Render
    attr_reader :presenter

    def initialize
      @presenter = Presenters::Websocket
    end

    def ray_tracing
      presenter.new(
        Interactors::RayTracing.new(
          scene,
          image_resolution: Types::Size.new(600, 300),
          viewport: Types::Size.new(2, 1),
          projection_distance: 1
        ).data
      ).call
    end

    private

    def scene
      @scene ||=
        Types::Scene.new.tap do |scene|
          scene.add_sphere([-1, 0, 4], 1, [255, 0, 0])
          scene.add_sphere([3, 1, 5], 1, [0, 0, 255])
          scene.add_sphere([-2, 1, 6], 1, [0, 255, 0])
          scene.ambient_light!(intensity: 0.2)
          scene.add_point_light(position: [2, 1, 0], intensity: 0.6)
          scene.add_directional_light(direction: [1, 4, 4], intensity: 0.2)
        end
    end
  end
end
