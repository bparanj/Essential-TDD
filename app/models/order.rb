class Order < ActiveRecord::Base
  attr_accessible :express_token, :express_payer_id
  attr_protected :ip_address
  serialize :details

  belongs_to :product
  has_many :transactions

  def purchase
    response = process_purchase
    transactions.create!(action: 'purchase', amount: price_in_cents, response: response)
    if response.success?
      p 'Purchase was successfully completed. Allow user to download the book when the payment is success.'
    end
    response.success?
  end

  def price_in_cents
    100
  end

  private

  def process_purchase
    ZephoPaypalExpress.purchase(price_in_cents, express_purchase_options)
  end
  
  def express_purchase_options
    {
      ip: ip_address,
      token: express_token,
      payer_id: express_payer_id
    }
  end

end
