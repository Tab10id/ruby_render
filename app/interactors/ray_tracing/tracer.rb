# frozen_string_literal: true

module Interactors
  class RayTracing
    # compute ray crossing with scene objects
    class Tracer
      attr_reader :scene,
                  :projection_distance

      def initialize(scene:, projection_distance:)
        @scene = scene
        @projection_distance = projection_distance
      end

      def call(origin, direction)
        closest_crossing = Float::INFINITY
        closest_object = nil

        scene.spheres.each do |sphere|
          crossing1, crossing2 = intersect_ray_sphere(origin, direction, sphere)

          if (new_closest_crossing = new_closest_crossing(crossing1, crossing2, closest_crossing))
            closest_crossing = new_closest_crossing
            closest_object = sphere
          end
        end

        [closest_object, closest_crossing]
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
end
