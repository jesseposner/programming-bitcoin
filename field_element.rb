class FieldElement
  attr_reader :int, :prime

  def initialize(int:, prime:)
    @int   = int
    @prime = prime
  end

  def ==(comparand)
    field_element_validation!(comparand)

    (int == comparand.int) && (prime == comparand.prime)
  end

  def +(summand)
    field_element_validation!(summand)

    int_sum = (int + summand.int) % prime

    FieldElement.new(int: int_sum, prime: prime)
  end

  def -(subtrahend)
    field_element_validation!(subtrahend)

    int_difference = (int - subtrahend.int) % prime

    FieldElement.new(int: int_difference, prime: prime)
  end

  def *(multiplicand)
    field_element_validation!(multiplicand)

    int_product = (int * multiplicand.int) % prime

    FieldElement.new(int: int_product, prime: prime)
  end

  def **(exponent)
    raise 'Must provide an integer' unless exponent.is_a?(Integer)

    if exponent < 0
      # int ** -n == 1 / int ** n
      positive_product = int ** exponent.abs

      identity_element / positive_product
    else
      int_product = (int ** exponent) % prime

      FieldElement.new(int: int_product, prime: prime)
    end
  end

  def /(divisor)
    # (divisor ** (prime - 1)) % prime == 1 by Fermat's Little Theorem
    # int / divisor == int * (divisor ** -1)
    # int / divisor == int * (divisor ** -1) * 1
    # int / divisor == int * (divisor ** -1) * (divisor ** (prime - 1)) % prime
    # int / divisor == int * (divisor ** (prime - 2)) % prime
    multiplicative_inverse = (divisor ** (prime - 2)) % prime
    int_quotient           = (int * multiplicative_inverse) % prime

    FieldElement.new(int: int_quotient, prime: prime)
  end

  def identity_element
    @_identity_element ||= FieldElement.new(int: 1, prime: prime)
  end

  private

  def field_element_validation!(operand)
    raise 'Must provide a FieldElement' unless operand.is_a?(FieldElement)
    raise 'Operands must have the same primes' if prime != operand.prime
  end
end
