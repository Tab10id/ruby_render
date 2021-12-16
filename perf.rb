# frozen_string_literal: true

require_relative 'app/controllers/render'
require 'benchmark'
require 'ruby-prof'

scene =
  Types::Scene.new.tap do |s|
    s.add_sphere([-1, 0, 4], 1, [255, 0, 0])
    s.add_sphere([3, 1, 5], 1, [0, 0, 255])
    s.add_sphere([-2, 1, 6], 1, [0, 255, 0])
  end

def render(scene)
  Interactors::RayTracing.new(
    scene,
    image_resolution: Types::Size.new(600, 300),
    viewport: Types::Size.new(2, 1),
    projection_distance: 1
  ).data
end

Benchmark.bmbm do |x|
  x.report { render(scene) }
end

# not work with truffleruby=(
result = RubyProf.profile { render(scene) }
printer = RubyProf::FlatPrinter.new(result)
printer.print($stdout)
