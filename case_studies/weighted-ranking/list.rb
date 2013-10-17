module WeightedRanking
  class List
    def initialize(criterion)
      @criterion = criterion
    end
    
    def size
      @criterion.size
    end
    
    def pairs
      # 1. Take the first element of the array
      # 2. Combine it with second element. Save the tuple.
      # 3. Continue till the end of the array. Save.
      # 4. Take the next element and repeat till the penultimate element.
      # 5. Return the list of all tuples
    end
  end
end