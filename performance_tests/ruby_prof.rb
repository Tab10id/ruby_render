# frozen_string_literal: true

require_relative 'context/scene'
require_relative 'context/ray_tracing'
require 'ruby-prof'

# not work with truffleruby=(
result = RubyProf.profile {  ray_tracing(SCENE) }
printer = RubyProf::FlatPrinter.new(result)
printer.print($stdout)
