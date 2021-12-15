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
      closest_crossing = Float::INFINITY
      closest_object = nil

      scene.spheres.each do |sphere|
        crossing1, crossing2 = intersect_ray_sphere(origin, direction, sphere)

        if (new_closest_crossing = new_closest_crossing(crossing1, crossing2, closest_crossing))
          closest_crossing = new_closest_crossing
          closest_object = sphere
        end
      end

      closest_object ? color_with_lighting(origin, closest_object, closest_crossing, direction) : BACKGROUND_COLOR
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

    def color_with_lighting(origin, closest_object, closest_crossing, direction)
      point = origin + (direction * closest_crossing)
      normal = point - closest_object.center

      closest_object.color * compute_lighting_intensity(point, normal * (1.0 / normal.length))
    end

    def compute_lighting_intensity(point, normal)
      scene.ambient_light +
        overall_point_light(point, normal) +
        overall_directional_light(normal)
    end

    def overall_point_light(point, normal)
      scene.point_lights.sum do |light|
        direction = light.position - point

        directional_light(direction, normal, light.intensity)
      end
    end

    def overall_directional_light(normal)
      scene.directional_lights.sum do |light|
        directional_light(light.direction, normal, light.intensity)
      end
    end

    def directional_light(direction, normal, intensity)
      reflect_rate = normal.dot_product(direction)

      if reflect_rate.positive?
        (intensity * reflect_rate) / (normal.length * direction.length)
      else
        0
      end
    end
  end
end
