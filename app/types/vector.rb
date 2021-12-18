# frozen_string_literal: true

module Types
  Vector = Struct.new(:x, :y, :z) do
    def +(other)
      Vector.new(x + other.x, y + other.y, z + other.z)
    end

    def *(k)
      Vector.new(x * k, y * k, z * k)
    end

    def -(other)
      Vector.new(x - other.x, y - other.y, z - other.z)
    end

    def dot_product(other)
      (x * other.x) + (y * other.y) + (z * other.z)
    end

    def length
      Math.sqrt(dot_product(self))
    end
  end
end
