# frozen_string_literal: true

module Interactors
  class RayTracing
    # compute color for some point of sphere
    class ColorProcessor
      attr_reader :scene

      def initialize(scene:)
        @scene = scene
      end

      def call(origin, direction, sphere, distance)
        point = origin + (direction * distance)
        normal = point - sphere.center

        sphere.color * compute_lighting_intensity(point, normal * (1.0 / normal.length))
      end

      private

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
end
