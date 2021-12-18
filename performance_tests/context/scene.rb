# frozen_string_literal: true

require_relative '../../app/types/scene'

SCENE =
  Types::Scene.new.tap do |s|
    s.add_sphere([-1, 0, 4], 1, [255, 0, 0])
    s.add_sphere([3, 1, 5], 1, [0, 0, 255])
    s.add_sphere([-2, 1, 6], 1, [0, 255, 0])
  end.freeze


