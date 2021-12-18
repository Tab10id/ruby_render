# frozen_string_literal: true

module Types
  # basic RGB-color definition
  Color = Struct.new(:red, :green, :blue) do
    def components
      [red, green, blue]
    end

    def *(intensity) # rubocop:disable Naming/BinaryOperatorParameterName
      Color.new(red * intensity, green * intensity, blue * intensity)
    end
  end
end
