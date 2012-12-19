class BountyProcessor
  
  def initialize(notify, order)
    @notify = notify
    @order = order
  end
  
  # create_bounty & credit affiliate, record the product price at the time of purchase not current price.  
  def run
    referrer_code = @order.custom
    
    if referrer_code
      affiliate = Affiliate.find_by_referrer_code(referrer_code)
      # TODO : product_price is decimal. Test it is stored correctly.
      if affiliate
        Bounty.create(affiliate_id: affiliate.id, product_price: @notify.gross, currency: @notify.currency)
      else
        PaypalLogger.error("FRAUD ALERT : Could not create bounty. Affiliate not found for referrer_code : #{referrer_code}.")
      end
    end
  end
end