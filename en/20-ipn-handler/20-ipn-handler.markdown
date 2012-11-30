
Objectives
 - Pushing logic to the right layer by applying separation of concerns.
 - Using stubs to break external dependencies and make tests run fast.
 - Using mocks to design your API.
 - Using as_null_object to ignore incidental interactions and keep the tests focused.

Version 1 : How not to write specs

The first few tests were written by copying the steps 1 - 6 from Paypal IPN Guide. Read the ActiveMerchant tests to learn about the plugin. 

paypal_ipn_controller_spec.rb

require 'spec_helper'

describe PaypalIpnController do
  include ActiveMerchant::Billing::Integrations

  specify "Step 1 : IPN Listener should wait for an HTTP post from PayPal" do
    post 'notify', {}
    response.body.should be_blank
  end

  specify 'Step 2 : Read post from Paypal' do
    request.stub!(:raw_post).and_return(http_raw_data)

    post 'notify', {}
    # notify should be local variable. It has been made available to view to test step 2
    assigns[:notify].should_not be_nil
  end

  specify 'Step 3 : Post back to PayPal system to validate'  do
    request.stub!(:raw_post).and_return(http_raw_data)
    Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')

    post 'notify', {}

    assigns[:verify].should be_true
  end

  specify 'Step 4 : If the response is VERIFIED check that the payment status is Completed' do
    request.stub!(:raw_post).and_return(http_raw_data)
    Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')

    post 'notify', {}
    assigns[:notify].status.should == 'Completed'    
  end

  specify "View should not be rendered for the Paypal IPN callback" do
    post 'notify', {}
    response.body.should be_blank
  end

  private

  def http_raw_data
    "mc_gross=500.00&address_status=confirmed&payer_id=EVMXCLDZJV77Q&tax=0.00&address_street=164+Waverley+Street&payment_date=15%3A23%3A54+Apr+15%2C+2005+PDT&payment_status=Completed&address_zip=K2P0V6&first_name=Tobias&mc_fee=15.05&address_country_code=CA&address_name=Tobias+Luetke&notify_version=1.7&custom=&payer_status=unverified&business=tobi%40leetsoft.com&address_country=Canada&address_city=Ottawa&quantity=1&payer_email=tobi%40snowdevil.ca&verify_sign=AEt48rmhLYtkZ9VzOGAtwL7rTGxUAoLNsuf7UewmX7UGvcyC3wfUmzJP&txn_id=6G996328CK404320L&payment_type=instant&last_name=Luetke&address_state=Ontario&receiver_email=tobi%40leetsoft.com&payment_fee=&receiver_id=UQ8PDYXJZQD9Y&txn_type=web_accept&item_name=Store+Purchase&mc_currency=CAD&item_number=&test_ipn=1&payment_gross=&shipping=0.00"
  end 

end

paypal_ipn_controller.rb

class PaypalIpnController < ApplicationController
  #skip security check because post comes from paypal
  skip_before_filter :verify_authenticity_token

  include ActiveMerchant::Billing::Integrations

  def notify
	@notify = Paypal::Notification.new(request.raw_post)
	@verify = @notify.acknowledge

  	render :nothing => true 
  end
end

routes.rb

match 'notify' => 'paypal_ipn#notify', :via => :post 


Version 2

Let's fix the spec 2 as follows:

specify 'Step 2 : Read post from Paypal' do
  request.stub!(:raw_post).and_return(http_raw_data)
  ipn = stub(:valid => true)
  PaypalService.should_receive(:new).with(http_raw_data) { ipn }

  post 'notify', {}
end

When we post, we now use mock to make sure the API that we control gets called. We no longer expose a variable to the view in order to test something that is un related to the variable. Reading the Paypal IPN guide we now add a negative condition spec for step 2 like this:

specify 'Step 2 negative condition : Read post from Paypal. 
         If ipn is invalid, log the message for manual intervention' do
  logger = mock(:info => nil)
  request.stub!(:raw_post).and_return(http_raw_data)
  ipn = stub(:valid => false)
  PaypalService.stub(:new).with(http_raw_data) { ipn }
  controller.stub!(:logger) { logger }

  PaypalService.should_not_receive(:process_payment)
  logger.should_receive(:info)

  post 'notify', {}
end


class PaypalIpnController < ApplicationController
  skip_before_filter :verify_authenticity_token

  include ActiveMerchant::Billing::Integrations

  def notify
  	ipn = PaypalService.new(request.raw_post)
	
	if ipn.valid
	  PaypalService.process_payment
	else
	  logger.info("Failed to verify Paypal IPN notification : #{request.raw_post}")
	end

  	render :nothing => true 
  end
end

This spec passes but there is a mock expectation to check payment is not processed. Let's move that check to it's own spec like this:

specify 'Step 2 negative condition : Read post from Paypal. 
         If ipn is invalid, payment should not be processed' do
  logger = mock(:info => nil)
  request.stub!(:raw_post).and_return(http_raw_data)
  ipn = stub(:valid => false)
  PaypalService.stub(:new).with(http_raw_data) { ipn }
  controller.stub!(:logger) { logger }

  PaypalService.should_not_receive(:process_payment)

  post 'notify', {}
end

The spec is now focused. It is consistent with doc string. Let's add the spec for step 3:

specify 'Step 3 : Post back to PayPal system to validate'

It fails. The spec for step 4 also fails. 

specify 'Step 4 : If the response is VERIFIED check that the payment status is Completed'

Let's push them down to service layer. The paypal_service_spec.rb looks like this:

require 'spec_helper'

include ActiveMerchant::Billing::Integrations

describe PaypalService do
  let(:paypal_service) do
    PaypalService.new(http_raw_data)
  end
  
  specify 'Payment status must be complete'  do 
    paypal_service.notify.should be_complete
  end
  
  specify 'Check that transaction id has not been previously processed' do
    already_processed = paypal_service.transaction_processed?

    already_processed.should be_false
  end
  
  specify 'Step 3 in IPN handler : Post back to PayPal system to validate' do
    Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')

    paypal_service.notify.acknowledge.should be_true
  end

  specify 'Step 3 in IPN handler negative case: Post back to PayPal system to validate' do
    Paypal::Notification.any_instance.stub(:ssl_post).and_return('INVALID')
    
    paypal_service.notify.acknowledge.should be_false
  end
  
  specify 'Check that payment amount and payment currency are correct' do
    paypal_service.check_payment.should be_true
  end
  
  specify 'Check that receiver_email is your buyer\'s Primary Paypal email' do    
    primary_paypal_email = paypal_service.primary_paypal_email?
    
    primary_paypal_email.should be_true
  end
  
end

The spec 3 and 4 are now defined in paypal_service_spec.rb. In spec 3 we could have written 

paypal_service.notify.status.should == 'Completed'

From client perspective, only acknowledge value is important. It is also the implementation details of the ActiveMerchant plugin. The plugin has tests for that case and we would be testing the plugin unnecessarily.

1. The initial version of the tests were more like ActiveMerchant learning tests and tightly coupled to the 	
	 implementation. Therefore the tests were brittle as the refactoring forced data to be hidden.
 
2. 	This illustrates the 'Breaking Out' concept discussed in Growing OO system guided by tests. By applying separation of concerns we have created a new object PaypalService that interacts with Paypal API. 

3. When to delete a test? 
   Deleted tests that were not related to controller responsibilities. These were scaffolding tests that gave quick feedback and allowed us to build the system. Since me moved the responsibility to the service layer, we delete those tests in the controller. These tests were moved to layer below that provides the service to Paypal API.

4. Notice the mocking of the Paypal service API in the controller specs.

The paypal_service.rb looks like this:

class PaypalService
  attr_reader :notify, :valid

  include ActiveMerchant::Billing::Integrations

  def initialize(data)
  	@notify = Paypal::Notification.new(data)
	@valid = @notify.acknowledge
  end

  def self.process_payment
    # check the $payment_status=Completed
    # check that $txn_id has not been previously processed
    # check that $receiver_email is your Primary PayPal email
    # check that $payment_amount/$payment_currency are correct
    # process payment
  end
  # All the methods below must be made private
  # Delegate the implementation to the PaymentNotification ActiveRecord object.
  # Test PaymentNotification methods. Move the tests in PaypalService object to PaymentNotification.
  def transaction_processed?
  	 #  Check the database if notify.transaction_id has been processed 
  	 # or not by hitting the db
  	false
  end

  def primary_paypal_email?
  	# Check that the notify.account is the your primary paypal email
  	# by hitting the db
  	# It could mean either the buyer or the seller. I don't know yet.
  	true
  end

  def check_payment
  	# Check notify.gross and notify.currency are correct 
  	# for this product by hitting the db
  	true
  end
end

The steps for implementing the above methods is listed by copying it from Paypal IPN Guide. The cleaned up controller spec now looks like this:

require 'spec_helper'

describe PaypalIpnController do
  include ActiveMerchant::Billing::Integrations

  specify "Step 1 : IPN Listener should wait for an HTTP post from PayPal" do
    post 'notify', {}
    response.body.should be_blank
  end

  specify 'Step 2 : Read post from Paypal' do
  	request.stub!(:raw_post).and_return(http_raw_data)
  	ipn = stub(:valid => true)
  	PaypalService.should_receive(:new).with(http_raw_data) { ipn }

	post 'notify', {}
  end

 specify 'Step 2 negative condition : Read post from Paypal. 
	  If ipn is invalid, log the message for manual intervention' do
 	logger = mock(:info => nil)
  	request.stub!(:raw_post).and_return(http_raw_data)
  	ipn = stub(:valid => false)
  	PaypalService.stub(:new).with(http_raw_data) { ipn }
  	controller.stub!(:logger) { logger }

    PaypalService.should_not_receive(:process_payment)
    logger.should_receive(:info)

	post 'notify', {}
  end

  specify "View should not be rendered for the Paypal IPN callback" do
    post 'notify', {}
    response.body.should be_blank
  end

end

The first and last specs are the same, only the doc strings differ. What should you do in such a case? Do we delete one of them? Do we combine the doc string to merge them into one test? One of the goals of TDD is documentation. If the duplicate test provides documentation value, we can retain it.

The first version of specs for PaypalService object has shown us the need for PaypalNotification active
   record object for most of the checks. PaypalService will delegate the checks to the persistant object and
   make most of the methods as private. Only process_payment class method will be public. The specs will be
   moved to ActiveRecord object tests for PaypalNotification.

Version 3

Added payment persistant object. Service object fake implementations replaced by real implementation. Problem with decimal comparison.

class Payment < ActiveRecord::Base
  attr_accessible :currency, :gross, :transaction_id
  
  def has_correct_amount?(gross, currency)
    (self.gross == gross) && (self.currency == currency)
  end
end

class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :transaction_id
      t.decimal :gross, precision: 8, scale: 2
      t.string :currency
      t.boolean :processed, default: false

      t.timestamps
    end
  end
end

payment_spec.rb

require 'spec_helper'

describe Payment do
  specify 'When the transaction flag is true, the transaction has been processed' do
  	payment = Payment.new
  	payment.transaction_id = 20
  	payment.processed = true

  	payment.should be_processed
  end

  specify 'Check gross and currency are correct' do
    payment = Payment.new
    payment.gross = 100.99
    payment.currency = 'CAN'

    result = payment.has_correct_amount?(100.99, 'CAN')
    result.should be_true 
  end

  specify 'Check gross and currency are correct : Same amount, different currency' do
    payment = Payment.new
    payment.gross = 100.99
    payment.currency = 'CAN'

    result = payment.has_correct_amount?(100.99, 'US')
    result.should be_false
  end

  specify 'Check gross and currency are correct : Different amount, same currency' do
    payment = Payment.new
    payment.gross = 100.99
    payment.currency = 'CAN'

    result = payment.has_correct_amount?(200.99, 'CAN')
    result.should be_false
  end

  specify 'Check gross and currency are correct : Different amount, different currency' do
    payment = Payment.new
    payment.gross = 100.99
    payment.currency = 'CAN'

    result = payment.has_correct_amount?(200.99, 'US')
    result.should be_false
  end
 
 end

paypal_service_spec.rb is changes like this:

specify 'Check that payment amount and payment currency are correct'  do
  Payment.delete_all
  payment = Payment.new
  payment.transaction_id = '6G996328CK404320L'
  payment.gross = 500.00
  payment.currency = 'CAD'
  payment.save
  
  paypal_service.check_payment.should be_true
end

specify 'Check that transaction id has not been previously processed' do
  payment = Payment.new
  payment.transaction_id = '6G996328CK404320L'
  payment.processed = false
  payment.save

  already_processed = paypal_service.transaction_processed?

  already_processed.should be_false
end

paypal_service.rb is changes like this:

def check_payment
  payment = Payment.find_by_transaction_id(notify.transaction_id)

  payment.has_correct_amount?(notify.gross, notify.currency)
end

def transaction_processed?
  payment = Payment.find_by_transaction_id(notify.transaction_id)

  payment.processed?
end

Version 4

Changes to payment_spec.rb are:

payment.currency = 'CAD'
payment.has_correct_amount?("100.99", 'CAD')
payment.has_correct_amount?("100.99", 'USD')

We are now using the right strings for the currency.

So it now looks like this:

require 'spec_helper'

describe Payment do
  specify 'When the transaction flag is true, the transaction has been processed' do
  	payment = Payment.new
  	payment.transaction_id = 20
  	payment.processed = true

  	payment.should be_processed
  end

  specify 'Check gross and currency are correct' do
    payment = Payment.new
    payment.gross = 100.99
    payment.currency = 'CAD'

    result = payment.has_correct_amount?("100.99", 'CAD')
    result.should be_true 
  end

  specify 'Check gross and currency are correct : Same amount, different currency' do
    payment = Payment.new
    payment.gross = 100.99
    payment.currency = 'CAD'

    result = payment.has_correct_amount?("100.99", 'USD')
    result.should be_false
  end

  specify 'Check gross and currency are correct : Different amount, same currency' do
    payment = Payment.new
    payment.gross = 100.99
    payment.currency = 'CAD'

    result = payment.has_correct_amount?("200.99", 'CAD')
    result.should be_false
  end

  specify 'Check gross and currency are correct : Different amount, different currency' do
    payment = Payment.new
    payment.gross = 100.99
    payment.currency = 'CAD'

    result = payment.has_correct_amount?("200.99", 'USD')
    result.should be_false
  end
 
 end

Payment class now uses money gem to fix the decimal comparison problem as follows:

require 'money'

class Payment < ActiveRecord::Base
  attr_accessible :currency, :gross, :transaction_id
  
  def has_correct_amount?(gross, currency)
    paid = Money.new(BigDecimal.new(gross), currency)
    price = Money.new(self.gross, self.currency)
    price == paid
  end
end

Version 5

Let's disconnect the paypal_service_spec.rb from accessing the network during Palpal API calls by stubbing. Specs will run fast. Here is the specs:

require 'spec_helper'

include ActiveMerchant::Billing::Integrations

describe PaypalService do
  let(:paypal_service) do
    PaypalService.new(http_raw_data)
  end

  specify 'Payment status must be complete'  do 
    paypal_service.notify.should be_complete
  end

  context 'VERIFIED' do
    before do
      Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')
    end

    specify 'Check that transaction id has not been previously processed' do
      payment = Payment.new
      payment.transaction_id = '6G996328CK404320L'
      payment.processed = false
      payment.save

      already_processed = paypal_service.transaction_processed?

      already_processed.should be_false
    end

    specify 'Step 3 in IPN handler : Post back to PayPal system to validate' do
      paypal_service.notify.acknowledge.should be_true
    end

    specify 'Check that payment amount and payment currency are correct'  do
      Payment.delete_all
      payment = Payment.new
      payment.transaction_id = '6G996328CK404320L'
      payment.gross = 500.00
      payment.currency = 'CAD'
      payment.save

      paypal_service.check_payment.should be_true
    end

    specify 'Check that receiver_email is your buyer\'s Primary Paypal email' do   
      account = Account.new 
      account.custom = "89CVZ"
      account.primary_paypal_email = 'tobi@leetsoft.com'
      account.save

      primary_paypal_email = paypal_service.primary_paypal_email?

      primary_paypal_email.should be_true
    end
  end
  
  context 'INVALID' do
    specify 'Step 3 in IPN handler negative case: Post back to PayPal system to validate' do
      Paypal::Notification.any_instance.stub(:ssl_post).and_return('INVALID')

      paypal_service.notify.acknowledge.should be_false
    end    
  end
end

Version 6

The paypal_service_spec.rb has two new specs for order fulfillment:

context 'Payment is Complete' do
  before do
    @paypal_service = PaypalService.new(http_raw_data)
    Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')
  end

  specify 'Order should be fulfilled if payment_status is Completed'  do
    order = double("Order")
    Order.stub(:find) { order }

    order.should_receive(:fulfill)

    @paypal_service.process_payment
  end
    
end

context 'Payment Incomplete' do
  before do
   @paypal_service2 = PaypalService.new(http_raw_data_incomplete)
   Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')
  end

  specify 'Order should not be fulfilled if payment_status is not Completed'  do
    order = double("Order")
    Order.stub(:find) { order }

    order.should_not_receive(:fulfill)

    @paypal_service2.process_payment
  end

end

Notice that we mock fulfill method. This is fine since we own this interface. The paypal_service.rb process_payment method is now changed as follows:

def process_payment
	if @notify.complete?
		order = Order.find(@notify.item_id)
		order.fulfill
	end
  # check the $payment_status=Completed
  # check that $txn_id has not been previously processed
  # check that $receiver_email is your Primary PayPal email
  # check that $payment_amount/$payment_currency are correct
  # process payment
end

class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status, default: 'open'

      t.timestamps
    end
  end
end

class Order < ActiveRecord::Base
  attr_accessible :status
  
  def fulfill
    status = 'fulfill'
    save
  end
end

Add the data for incomplete payment by adding the following method to the spec_helper.rb:

def http_raw_data_incomplete
 "custom=89CVZ&mc_gross=500.00&address_status=confirmed&payer_id=EVMXCLDZJV77Q&tax=0.00&address_street=164+Waverley+Street&payment_date=15%3A23%3A54+Apr+15%2C+2005+PDT&payment_status=Declined&address_zip=K2P0V6&first_name=Tobias&mc_fee=15.05&address_country_code=CA&address_name=Tobias+Luetke&notify_version=1.7&payer_status=unverified&business=tobi%40leetsoft.com&address_country=Canada&address_city=Ottawa&quantity=1&payer_email=tobi%40snowdevil.ca&verify_sign=AEt48rmhLYtkZ9VzOGAtwL7rTGxUAoLNsuf7UewmX7UGvcyC3wfUmzJP&txn_id=6G996328CK404320L&payment_type=instant&last_name=Luetke&address_state=Ontario&receiver_email=tobi%40leetsoft.com&payment_fee=&receiver_id=UQ8PDYXJZQD9Y&txn_type=web_accept&item_name=Store+Purchase&mc_currency=CAD&test_ipn=1&payment_gross=&shipping=0.00"
end

Version 7

Let's add tests for two checks before payment can be processed. 

specify 'Order should be fulfilled if all checks pass'  do
  order = double("Order")
  Order.stub(:find) { order }
  Payment.stub(:previously_processed?) { false }

  order.should_receive(:fulfill)

  @paypal_service.process_payment
end

specify 'Check that transaction_id has not been previously processed'  do
  order = stub('Order').as_null_object
  Order.stub(:find) { order }
  Payment.should_receive(:previously_processed?)

  @paypal_service.process_payment      
end

Change the PaypalService process_payment method as follows:

def process_payment
	# 1. check the $payment_status=Completed
	if @notify.complete?
		# 2. check that $txn_id has not been previously processed
		previously_processed = Payment.previously_processed?(@notify.transaction_id)
		unless previously_processed
		  order = Order.find(@notify.item_id)
	  	  order.fulfill  			
		end
	end
  
  # check that $receiver_email is your Primary PayPal email
  # check that $payment_amount/$payment_currency are correct
  # process payment
end

Add previously_processed? method to the payment.rb as follows:

def self.previously_processed?(transaction_id)
  false
end

The second spec uses as_null_object for incidental interaction. Essential interaction is the interaction that we are currently testing, incidental interactions are there to help the test run. The new tests pass only if connected to network and takes 15 seconds to run 9 tests. Let's fix that now.

Version 8

Change the paypal_service_spec.rb before method as follows :

before do
  notification = Bogus.notification('name=mama')
  notification.stub(:acknowledge) { true }
  notification.stub(:complete?) { true }
  notification.stub(:transaction_id) { "6G996328CK404320L" }
  notification.stub(:notify_id) { '1234' }
  notification.stub(:gross) { "500.00" }
  notification.stub(:currency) { 'CAD' }
  notification.stub(:account) {'tobi@leetsoft.com'}
  notification.stub(:item_id) {  '89CVZ' }

  @paypal_service = PaypalService.new(notification)

  Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')
end

Change the constructor of paypal_service.rb as follows:

def initialize(notify)
  @notify = notify
  @valid = @notify.acknowledge
end

How to speed up unit tests? Can you run the tests with network connection disconnected? We disconnect from network by using the fake notification object Bogus provided by the plugin. Tests now run within one second. This is a tremendous improvement from 15 seconds. 

The following spec is the responsibility of the ActiveMerchant plugin:

specify 'Step 3 in IPN handler negative case: Post back to PayPal system to validate'

 It is the implementation details of the plugin. Do not test ActiveMerchant plugin. Focus on testing application logic. So, this spec can be deleted. 


Version 9

Let's review the paypal_payment_spec.rb :

require 'spec_helper'

include ActiveMerchant::Billing::Integrations

describe PaypalService do

  context 'Payment is Complete' do
    before do
      notification = Bogus.notification('name=mama')
      notification.stub(:acknowledge) { true }
      notification.stub(:complete?) { true }
      notification.stub(:transaction_id) { "6G996328CK404320L" }
      notification.stub(:notify_id) { '1234' }
      notification.stub(:gross) { "500.00" }
      notification.stub(:currency) { 'CAD' }
      notification.stub(:account) {'tobi@leetsoft.com'}
      notification.stub(:item_id) {  '89CVZ' }

      @paypal_service = PaypalService.new(notification)

      Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')
    end
    
    specify 'Payment status must be complete', :focus => true do 
      @paypal_service.notify.should be_complete
    end

    specify 'Check that the transaction is not already processed, identified by the transaction ID' do
      payment = Payment.new
      payment.transaction_id = '6G996328CK404320L'
      payment.processed = false
      payment.save

      already_processed = @paypal_service.transaction_processed?

      already_processed.should be_false
    end

    specify 'Step 3 in IPN handler : Post back to PayPal system to validate', :focus => true do
      @paypal_service.notify.acknowledge.should be_true
    end

    specify 'Check that payment amount and payment currency are correct'  do
      Payment.delete_all
      payment = Payment.new
      payment.transaction_id = '6G996328CK404320L'
      payment.gross = 500.00
      payment.currency = 'CAD'
      payment.save

      @paypal_service.check_payment.should be_true
    end

    specify 'Check that receiver_email is your buyer\'s Primary Paypal email' do   
      account = Account.new 
      account.custom = "89CVZ"
      account.primary_paypal_email = 'tobi@leetsoft.com'
      account.save

      primary_paypal_email = @paypal_service.primary_paypal_email?

      primary_paypal_email.should be_true
    end
    # Step 1. 
    specify 'Order should be fulfilled if all checks pass'  do
      order = double("Order")
      Order.stub(:find) { order }
      Payment.stub(:previously_processed?) { false }

      order.should_receive(:fulfill)

      @paypal_service.process_payment
    end
    
    # Step 2.
    specify 'Check that transaction_id has not been previously processed'  do
      order = stub('Order').as_null_object
      Order.stub(:find) { order }
      Payment.should_receive(:previously_processed?)

      @paypal_service.process_payment      
    end

  end
end

Look at the following specs closely:

specify 'Check that the transaction is not already processed, identified by the transaction ID'
specify 'Check that payment amount and payment currency are correct'
specify 'Check that receiver_email is your buyer\'s Primary Paypal email'

They all create just one object and check for a certain expected outcome. It would make sense to retain these specs in paypal_service_spec if we were creating and co-ordinating with many objects. To make the classes cohesive, let's push those responsibilities down to those models.

Move the specs to the payment_spec.rb as follows:

specify 'Check that the transaction is not already processed, identified by the transaction ID' do
  payment = Payment.new
  payment.transaction_id = '6G996328CK404320L'
  payment.processed = false
  payment.save

  already_processed = Payment.previously_processed?('6G996328CK404320L')

  already_processed.should be_false
end

specify 'Check that given transaction has correct amount' do
  payment = Payment.new
  payment.transaction_id = '6G996328CK404320L'
  payment.gross = 100.00
  payment.currency = 'CAD'
  payment.save

  correct_amount = Payment.transaction_has_correct_amount?('6G996328CK404320L', '100.00',  'CAD')
  correct_amount.should be_true
end

Change the payment.rb as follows:

def self.previously_processed?(transaction_id)
  payment = find_by_transaction_id(transaction_id)
  payment.processed?
end

def self.transaction_has_correct_amount?(transaction_id, gross, currency)
  payment = find_by_transaction_id(transaction_id)
  payment.has_correct_amount?(gross, currency)
end

The account_spec.rb is as follows:

require 'spec_helper'

describe Account do
  specify 'Check that receiver_email field from Paypal is merchant Primary Paypal Email' do
    account = Account.new
    account.custom = 'X5FI29'
    account.primary_paypal_email = 'bugs@disney.com'
    account.save
    
    result = Account.receiver_email_merchant_primary_paypal_email?('X5FI29','bugs@disney.com')
    result.should be_true
  end
end

Change the account.rb as follows:

def self.receiver_email_merchant_primary_paypal_email?(custom, email)
  account = find_by_custom(custom)
  account.primary_paypal_email == email
end

Change the paypal_service.rb as follows:

class PaypalService
  attr_reader :notify, :valid

  include ActiveMerchant::Billing::Integrations

  def initialize(notify)
  	@notify = notify
	@valid = @notify.acknowledge
  end

  def process_payment
  	if @notify.complete?
  	  previously_processed = Payment.previously_processed?(@notify.transaction_id)
  	  unless previously_processed
		order = Order.find(@notify.item_id)
	  	order.fulfill  			
  	  end
  	end    
  end
end

The paypal_service_spec.rb looks like this:

require 'spec_helper'

include ActiveMerchant::Billing::Integrations

describe PaypalService do

  context 'Payment is Complete' do
    before do
      n = Bogus.notification('name=mama')
      n.stub(:acknowledge) { true }
      n.stub(:complete?) { true }
      n.stub(:transaction_id) { "6G996328CK404320L" }
      n.stub(:notify_id) { '1234' }
      n.stub(:gross) { "500.00" }
      n.stub(:currency) { 'CAD' }
      n.stub(:account) {'tobi@leetsoft.com'}
      n.stub(:item_id) {  '89CVZ' }

      @paypal_service = PaypalService.new(n)

      Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')
    end
    
    specify 'Payment status must be complete', :focus => true do 
      @paypal_service.notify.should be_complete
    end

    specify 'Step 3 in IPN handler : Post back to PayPal system to validate', :focus => true do
      @paypal_service.notify.acknowledge.should be_true
    end

    # Step 1. 
    specify 'Order should be fulfilled if all checks pass'  do
      order = double("Order")
      Order.stub(:find) { order }
      Payment.stub(:previously_processed?) { false }

      order.should_receive(:fulfill)

      @paypal_service.process_payment
    end
    
    # Step 2.
    specify 'Check that transaction_id has not been previously processed'  do
      order = stub('Order').as_null_object
      Order.stub(:find) { order }
      Payment.should_receive(:previously_processed?)

      @paypal_service.process_payment      
    end
  end

  context 'Payment Incomplete' do
    before do
     n = Bogus.notification('name=mama')
     n.stub(:acknowledge) { true }
     n.stub(:complete?) { false }
     n.stub(:transaction_id) { "6G996328CK404320L" }
     n.stub(:notify_id) { '1234' }
     n.stub(:gross) { "500.00" }
     n.stub(:currency) { 'CAD' }
     n.stub(:account) {'tobi@leetsoft.com'}
     n.stub(:item_id) {  '89CVZ' }

     @paypal_service_incompelete = PaypalService.new(n)
     
     Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')
    end

    specify 'Order should not be fulfilled if payment_status is not Completed'  do
      order = double("Order")
      Order.stub(:find) { order }

      order.should_not_receive(:fulfill)

      @paypal_service_incompelete.process_payment
    end

  end
end

# This test is testing the ActiveMerchant logic not application logic. Delete this and
# write a test that is focused on application logic which does post back.
xspecify 'Step 3 in IPN handler negative case: Post back to PayPal system to validate' do
  Paypal::Notification.any_instance.stub(:ssl_post).and_return('INVALID')

  @paypal_service.notify.acknowledge.should be_false
end    

Version 10
