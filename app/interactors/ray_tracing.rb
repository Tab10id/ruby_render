# frozen_string_literal: true

require_relative '../types/color'
require_relative '../types/vector'
require_relative 'ray_tracing/tracer'
require_relative 'ray_tracing/color_processor'

module Interactors
  # Very basic raytracer
  class RayTracing
    attr_reader :scene,
                :image_resolution,
                :viewport,
                :projection_distance,
                :tracer,
                :color_processor

    def initialize(scene, image_resolution:, viewport:, projection_distance:, tracer: nil,  color_processor: nil)
      @scene = scene
      @image_resolution = image_resolution
      @viewport = viewport
      @projection_distance = projection_distance
      @tracer = tracer || RayTracing::Tracer.new(scene: scene, projection_distance: projection_distance)
      @color_processor = color_processor || RayTracing::ColorProcessor.new(scene: scene)
    end

    CAMERA_POSITION = Types::Vector.new(0, 0, 0).freeze
    BACKGROUND_COLOR = Types::Color.new(120, 120, 120).freeze

    def data
      half_height = (image_resolution.height / 2)
      half_width = (image_resolution.width / 2)

      (-half_height...half_height).flat_map do |y|
        (-half_width...half_width).map do |x|
          direction = canvas_to_viewport(x.to_f, y.to_f)
          closest_sphere, distance = tracer.call(CAMERA_POSITION, direction)
          color(closest_sphere, direction, distance).components
        end
      end
    end

    private

    def canvas_to_viewport(point_x, point_y)
      Types::Vector.new(
        point_x * viewport.width / image_resolution.width,
        -point_y * viewport.height / image_resolution.height,
        projection_distance
      )
    end

    def color(closest_sphere, direction, distance)
      if closest_sphere
        color_processor.call(CAMERA_POSITION, direction, closest_sphere, distance)
      else
        BACKGROUND_COLOR
      end
    end
  end
end
