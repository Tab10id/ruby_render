# frozen_string_literal: true

require_relative '../types/color'
require_relative '../types/point'

module Interactors
  # Very basic raytracer
  class RayTracing
    attr_reader :scene,
                :image_resolution,
                :viewport,
                :projection_distance

    def initialize(scene, image_resolution:, viewport:, projection_distance:)
      @scene = scene
      @image_resolution = image_resolution
      @viewport = viewport
      @projection_distance = projection_distance
    end

    CAMERA_POSITION = Types::Point.new(0, 0, 0).freeze
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
      Types::Point.new(
        point_x * viewport.width / image_resolution.width,
        -point_y * viewport.height / image_resolution.height,
        projection_distance
      )
    end

    def trace_ray(origin, direction)
      closest_t = Float::INFINITY
      closest_object = nil

      scene.spheres.each do |sphere|
        t1, t2 = intersect_ray_sphere(origin, direction, sphere)

        if (new_closest_t = new_closest_t(t1, t2, closest_t))
          closest_t = new_closest_t
          closest_object = sphere
        end
      end

      closest_object ? closest_object.color : BACKGROUND_COLOR
    end

    def intersect_ray_sphere(origin, direction, sphere)
      oc = subtract(origin, sphere.center)

      quadratic_equation(
        dot_product(direction, direction),
        2 * dot_product(oc, direction),
        dot_product(oc, oc) - sphere.radius**2
      )
    end

    def subtract(vector1, vector2)
      Types::Point.new(vector1.x - vector2.x, vector1.y - vector2.y, vector1.z - vector2.z)
    end

    def dot_product(vector1, vector2)
      (vector1.x * vector2.x) + (vector1.y * vector2.y) + (vector1.z * vector2.z)
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

    def new_closest_t(t1, t2, closest_t) # rubocop:disable Naming/MethodParameterName
      [t1, t2].sort.find { |t| t > projection_distance && t < closest_t }
    end
  end
end
