require 'spec_helper'

describe PaypalGateway do
  context 'SetExpressCheckout' do
    it 'should set express checkout' do
      amount = 100
      confirmation_number = 23
      options = {}
      options[:ip] = '127.0.0.1'
      options[:return_url] = 'return/url.local'
      options[:cancel_return_url] = 'cancel/return/url.local'
      options[:notify_url] = 'notify/url.local'
      options[:order_id] = confirmation_number

      token = stub('Token', confirmation_number: confirmation_number) 
      Token.stub(:create!) { token }
      fake_response = stub("Response", success?: true)
      ZephoPaypalExpress.should_receive(:setup_purchase).with(amount, 
                                                              ip: options[:ip],
                                                              return_url: options[:return_url],
                                                              cancel_return_url: options[:cancel_return_url],
                                                              notify_url: options[:notify_url],
                                                              order_id: confirmation_number,
                                                              custom: options[:custom]).and_return(fake_response)
      PaypalGateway.set_express_checkout(amount, options)  
    end      
  end
  
  context 'Express Checkout' do
    
    before do
      @options = {}
      @options[:express_token] = 'LKX2'
      @options[:express_payer_id] = 'CXVJ4'
      @options[:product_id] = 2
      @options[:item_name] = 'Essential TDD'
      @options[:amount] = 47      
      o = Order.new
      Order.stub(:new) { o }
      o.stub_chain(:transactions, :create!)
      ZephoPaypalExpress.stub(:details_for) {  stub("Response", success?: false) }      
    end
    
    it 'checkout : If purchase is succcess then order status must be set to fulfill' do
      fake_response = stub("Response", success?: true).as_null_object
      ZephoPaypalExpress.stub(:purchase) { fake_response }

      PaypalGateway.checkout('127.0.0.1', @options)

      order = Order.last
      expect(order.status).to eq(Order::FULFILL)
    end

    it 'checkout : If purchase is failure then order status must be set to failed' do
      fake_response = stub("Response", success?: false).as_null_object
      ZephoPaypalExpress.stub(:purchase) { fake_response }

      PaypalGateway.checkout('127.0.0.1', @options)

      order = Order.last
      expect(order.status).to eq(Order::FAILED)
    end    
  end

  context 'Express Checkout Details' do
    before do
      @options = {}
      @options[:express_token] = 'LKX2'
      @options[:express_payer_id] = 'CXVJ4'
      @options[:product_id] = 2
      @options[:item_name] = 'Essential TDD'
      @options[:amount] = 47      
      @o = Order.new
      Order.stub(:new) { @o }
      ZephoPaypalExpress.stub(:details_for) {  stub("Response", success?: true) }      
      @fake_response = stub("Response", success?: true).as_null_object
      ZephoPaypalExpress.stub(:purchase) { @fake_response }
      fake_mapper = double('Mapper')
      fake_mapper.stub(email: 'buyer@spender.com')
      fake_mapper.stub(first_name: 'Daffy')
      fake_mapper.stub(last_name: 'Duck')
      fake_mapper.stub(custom: 'ABJQ')
      fake_mapper.stub(details: {})
      BillingResponseMapper.stub(:new) { fake_mapper }
    end
    
    it 'checkout is successful, checkout details must be saved' do
      @o.stub_chain(:transactions, :create!)
            
      PaypalGateway.checkout('127.0.0.1', @options)
      
      order = Order.last
      expect(order.buyer_email).to eq('buyer@spender.com')
      expect(order.first_name).to eq('Daffy')
      expect(order.last_name).to eq('Duck')
      expect(order.custom).to eq('ABJQ')
    end    

    it 'checkout is successful, transaction must be saved' do      
      @o.should_receive(:create_purchase_transaction).with(@options[:amount], @fake_response)
            
      PaypalGateway.checkout('127.0.0.1', @options)      
    end    
    
  end
  
end