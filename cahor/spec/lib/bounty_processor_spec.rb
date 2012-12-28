require 'spec_helper'

describe BountyProcessor do
  let(:notify) { stub('Notify', gross: '10', currency: 'CAD') }
  
  it 'should credit the affiliate for the referral purchase' do
    order = stub('Order', custom: 'AXBG')
    affiliate = stub('Affiliate', id: 1)
    Affiliate.stub(:find_by_referrer_code) { affiliate }
    bounty_processor = BountyProcessor.new(notify, order)
    
    expect do
      bounty_processor.run
    end.to change(Bounty, :count).by(1)
  end
  
  it 'should not credit any affiliate for a non referral purchase' do
    order = stub('Order', custom: nil)
    bounty_processor = BountyProcessor.new(notify, order)
    
    expect do
      bounty_processor.run
    end.to_not change(Bounty, :count)
  end
  
end