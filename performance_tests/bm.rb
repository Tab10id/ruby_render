# frozen_string_literal: true

require_relative 'context/scene'
require_relative 'context/ray_tracing'
require 'benchmark'

Benchmark.bmbm do |x|
  x.report { ray_tracing(SCENE) }
end
