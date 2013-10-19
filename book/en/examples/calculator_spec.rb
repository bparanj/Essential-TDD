require_relative 'calculator'

describe Calculator do
  it 'should add given two numbers' do
    calculator = Calculator.new
    result = calculator.add(1,2)
    
    result.should == 3
  end
  # it 'should subtract two numbers'
  
end
