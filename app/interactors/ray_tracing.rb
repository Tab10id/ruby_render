# frozen_string_literal: true

require_relative '../types/color'
require_relative '../types/vector'
require_relative 'ray_tracing/color_processor'

module Interactors
  # Very basic raytracer
  class RayTracing
    attr_reader :scene,
                :image_resolution,
                :viewport,
                :projection_distance,
                :color_processor

    def initialize(scene, image_resolution:, viewport:, projection_distance:, color_processor: nil)
      @scene = scene
      @image_resolution = image_resolution
      @viewport = viewport
      @projection_distance = projection_distance
      @color_processor = color_processor || RayTracing::ColorProcessor.new(scene)
    end

    CAMERA_POSITION = Types::Vector.new(0, 0, 0).freeze
    BACKGROUND_COLOR = Types::Color.new(120, 120, 120).freeze

    def data
      half_height = (image_resolution.height / 2)
      half_width = (image_resolution.width / 2)

      (-half_height...half_height).flat_map do |y|
        (-half_width...half_width).map do |x|
          direction = canvas_to_viewport(x.to_f, y.to_f)
          trace_ray(CAMERA_POSITION, direction).components
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

    def trace_ray(origin, direction)
      closest_crossing = Float::INFINITY
      closest_object = nil

      scene.spheres.each do |sphere|
        crossing1, crossing2 = intersect_ray_sphere(origin, direction, sphere)

        if (new_closest_crossing = new_closest_crossing(crossing1, crossing2, closest_crossing))
          closest_crossing = new_closest_crossing
          closest_object = sphere
        end
      end

      closest_object ? color_processor.call(origin, direction, closest_object, closest_crossing) : BACKGROUND_COLOR
    end

    def intersect_ray_sphere(origin, direction, sphere)
      oc = origin - sphere.center

      quadratic_equation(
        direction.dot_product(direction),
        2 * oc.dot_product(direction),
        oc.dot_product(oc) - sphere.radius**2
      )
    end

    def quadratic_equation(a, b, c) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Naming/MethodParameterName
      discriminant = b**2 - 4 * a * c

      if discriminant.negative?
        solution1 = solution2 = Float::INFINITY
      elsif discriminant.zero?
        solution1 = solution2 = -b / (2 * a)
      else
        discriminant_sqrt = Math.sqrt(discriminant)
        solution1 = (-b + discriminant_sqrt) / (2 * a)
        solution2 = (-b - discriminant_sqrt) / (2 * a)
      end

      [solution1, solution2]
    end

    def new_closest_crossing(crossing1, crossing2, closest_crossing)
      [crossing1, crossing2].sort.find { |c| c > projection_distance && c < closest_crossing }
    end
  end
end
