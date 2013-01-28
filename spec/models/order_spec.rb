require 'spec_helper'

describe Order do
  it 'custom field Character length and limitations: 256 single-byte alphanumeric characters' do
    order = Order.new
    order.custom = 'A1JX' * 64
    order.number = '10'
    
    expect(order.custom.size).to eq(256)
    expect(order.save).to be_true
  end
end