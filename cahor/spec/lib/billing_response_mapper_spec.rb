require 'spec_helper'

class FakeBillingResponse
  attr_reader :params
  
  def initialize
    @params = {}
    @params['first_name'] = 'Daffy'
    @params['last_name'] = 'Duck'
    @params['custom'] = 'ABQ'
  end
  
  def email
    'buyer@spender.com'
  end
  
  def details
    @params
  end
end

describe BillingResponseMapper do
  let(:mapper) { BillingResponseMapper.new(FakeBillingResponse.new) }
  
  it 'should return email' do      
      expect(mapper.email).to eq('buyer@spender.com')
  end
  
  it 'should return first name' do
    expect(mapper.first_name).to eq('Daffy')
  end
  
  it 'should return last name' do
    expect(mapper.last_name).to eq('Duck')
  end
  
  it 'should return custom value' do
    expect(mapper.custom).to eq('ABQ')
  end
  
  it 'should return details' do
    params = {}
    params['first_name'] = 'Daffy'
    params['last_name'] = 'Duck'
    params['custom'] = 'ABQ'
    
    expect(mapper.details).to eq(params)    
  end
  
end