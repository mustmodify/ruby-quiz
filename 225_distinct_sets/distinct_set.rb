require 'rubygems'
require 'valuable'

class DistinctSet < Valuable

  has_collection :set
  has_value :testing, :default => false

  def parse
    dirty = (0..set.size).to_a
    
    while i = dirty.pop
      ( i+1 ... set.size ).each do |j|
        combine_overlapping_sets(i, j)
      end
    end
  end

  def combine_overlapping_sets(i, j)
    a = set[i]
    b = set[j]
    if( overlap_between(a, b) )
      set[i] = a | b
      set[j] = nil
      dirty << i
    end
  end

  def overlap_between(a, b)
    !((a & b).empty?) if a && b
  end
  
  def dirty
    @dirty ||= []
  end

  def elements
    set.compact.size
  end
  
  def loop_until_stable
    begin
      set_count = elements
      yield
    end while elements != set_count
  end

  def result
    set.compact.map(&:sort)
  end
end
