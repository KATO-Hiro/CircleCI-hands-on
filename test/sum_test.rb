require 'minitest/autorun'
require './lib/sum'

class SumTest < Minitest::Test
  def test_sum
    assert_equal 3, sum(1, 2)
  end
end
