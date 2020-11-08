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
    attr_reader :event, :presenter

    def initialize(event)
      @event = event
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
        end
    end
  end
end
