# frozen_string_literal: true

require_relative '../../app/interactors/ray_tracing'
require_relative '../../app/types/size'

def ray_tracing(scene)
  Interactors::RayTracing.new(
    scene,
    image_resolution: Types::Size.new(600, 300),
    viewport: Types::Size.new(2, 1),
    projection_distance: 1
  ).data
end
