class Point
  attr_reader :x, :y, :a, :b, :y_2, :x_3, :ax

  def initialize(x:, y:, a:, b:)
    @x   = x
    @y   = y
    @a   = a
    @b   = b
    @y_2 = y ** 2
    @x_3 = x ** 3
    @ax  = a * x

    unless point_on_curve?
      raise 'Point provided must be on the curve: y_2 = x_3 + ax + b'
    end
  end

  def ==(comparand)
    point_validation!(comparand)

    (x == comparand.x) &&
    (y == comparand.y) &&
    (a == comparand.a) &&
    (b == comparand.b)
  end

  def +(summand)
    # self + I == self
    return self if summand.point_at_infinity?
    # summand + I == summand
    return summand if self.point_at_infinity?
    # P + (-P) == I
    return point_at_infinity if (x == summand.x) && (-y == summand.y)

    slope = if x == summand.x && y == summand.y
              # dy/dx of y_2 = x_3 + ax + b
              (3 * x**2 + a).fdiv(2 * y)
            elsif x != summand.x
              # Slope of line between the two points.
              (y - summand.y).fdiv(x - summand.x)
            end

    # Find where the line intersects the curve at a third point.
    x_at_third_intersection = slope**2 - summand.x - x
    y_at_third_intersection = slope * (x_at_third_intersection - summand.x) + summand.y
    # Find the inverse point
    inverse_of_y_at_third_intersection = -y_at_third_intersection

    Point.new(x: x_at_third_intersection,
              y: inverse_of_y_at_third_intersection,
              a: a,
              b: b)
  end

  def point_on_curve?
    @_point_on_curve ||= (
      point_at_infinity? ||
      y_2 == x_3 + ax + b
    )
  end

  def point_at_infinity?
    @_is_point_at_infinity ||= (
      x == Float::INFINITY &&
      y == Float::INFINITY
    )
  end

  def point_at_infinity
    @_point_at_infinity ||= Point.new(
      x: Float::INFINITY,
      y: Float::INFINITY,
      a: a,
      b: b
    )
  end

  private

  def point_validation!(operand)
    unless operand.is_a?(Point)
      raise 'Must provide a FieldElement'
    end

    unless (a == operand.a) && (b == operand.b)
      raise 'Operands must be on the same curve'
    end
  end
end
