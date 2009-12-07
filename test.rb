require 'rubygems'
require 'test/unit'
require 'distinct_set.rb'

class DistinctSetTest < Test::Unit::TestCase

  def test_that_two_similar_sets_are_merged
    parser = DistinctSet.new(:set => [['a'], ['a']])
    parser.parse

    assert_equal [['a']], parser.result
  end

  def test_that_two_disjoint_sets_are_not_merged
    parser = DistinctSet.new(:set => [['a'], ['b']])
    parser.parse

    assert_equal [['a'], ['b']], parser.result
  end

  def test_that_non_overlapping_elements_are_not_lost
    parser = DistinctSet.new(:set => [['a', 'b', 'c'], ['c', 'd']])
    parser.parse

    assert_equal [['a', 'b', 'c', 'd']], parser.result
  end

  def test_that_non_adjacent_sets_are_joined
	  parser = DistinctSet.new(:set => [['a', 'b'], ['c'], ['a', 'e']])
	  parser.parse
	  assert_equal [['a', 'b', 'e'], ['c']], parser.result
  end
 
  def test_that_three_items_can_be_joined
    parser = DistinctSet.new(:set => [['a', 'b'], ['a', 'c'], ['a', 'd']], :testing => false)
    parser.parse
    assert_equal [['a', 'b', 'c', 'd']], parser.result
  end
  
  def test_quiz_basic_example
    example = [['D', 'E', 'G'], ['C', 'J', 'K', 'M'], ['K', 'M'], ['H'], ['D', 'H', 'L', 'R'], ['G', 'L']]
    
    expected = [['D', 'E', 'G', 'H', 'L', 'R'], ['C', 'J', 'K', 'M']]

    parser = DistinctSet.new(:set => example, :testing => false)
    parser.parse
    assert_equal expected, parser.result
  end

  def test_quiz_samples
    samples = {
	    [["G", "J", "N"], ["D", "F", "G", "K"], ["E", "H"], 
		    ["B", "C", "J","L", "Q"], ["C", "M"]] => [["B", "C", "D", "F", "G", "J", "K", "L", "M", "N", "Q"], 
		    ["E", "H"]],
	    [["A", "C", "E", "G", "H"], ["B", "I", "M"], ["E", "M", "O"]] =>  [["A", "B", "C", "E", "G", "H", "I", "M", "O"]],
	    [["D", "E", "J", "L"], ["F", "K"], ["L", "M"], ["I", "K"], 
		    ["I", "K"]] => [["D", "E", "J", "L", "M"], ["F", "I", "K"]],
            [["B", "E", "L", "M"], ["B", "I", "L", "O", "P"], 
		    ["A", "J", "O", "P"], ["A", "D", "F", "L"]] => 
		    [["A", "B", "D", "E", "F", "I", "J", "L", "M", "O", "P"]],
            [["E", "G", "K"], ["A", "C", "I", "J", "N"], 
		    ["C", "J", "M", "N"]] => [["E", "G", "K"], 
		    ["A", "C", "I", "J", "M", "N"]],
            [["A", "D", "E", "H"], ["D", "N", "P"], ["D", "I", "L", "P"]] => 
		    [["A", "D", "E", "H", "I", "L", "N", "P"]], 
            [["E", "F", "K", "N", "O"], ["A", "B", "C", "J", "P"]] => 
		    [["E", "F", "K", "N", "O"], ["A", "B", "C", "J", "P"]],
            [["C", "H", "M"], ["D", "F", "L"], ["A", "E", "J", "O"], 
		    ["C", "H"], ["J", "K", "M"], ["A", "N", "Q", "T"]] => 
		    [["A", "C", "E", "H", "J", "K", "M", "N", "O", "Q", "T"], 
                    ["D", "F", "L"]]
    }
    samples.each do |input, expected| 
      parser = DistinctSet.new(:set => input, :testing => false)
      parser.parse
      assert_equal expected, parser.result    
    end
  end
end
