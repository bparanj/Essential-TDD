require_relative 'list'

describe WeightedRanking::List do
  it 'list all of the major criteria for ranking' do
    criterion = ['Type of plot',  'Strength of plot', 'Degree of excitement', 'Level of violence', 'Cinematography', 'Music', 'Cast',  'Director']
    list = WeightedRanking::List.new(criterion)
    
    expect(list.size).to eq(8)
  end
  
  it 'pair rank the criteria list' do
    criterion = ['Type of plot',  'Strength of plot', 'Degree of excitement', 'Level of violence', 'Cinematography', 'Music', 'Cast',  'Director']    
    
    list = WeightedRanking::List.new(criterion)
    
    list.pairs.size.should == (8*(8-1))/2
  end
  
end