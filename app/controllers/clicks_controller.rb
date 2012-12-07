class ClicksController < ApplicationController

  def create    
    _handle_cookie    
    _record_click
    
    logger.info("Params are : #{params[:r]} - #{params[:p]} - #{params[:l]}")
    logger.info("http referrer (Domain is): #{request.env["HTTP_REFERER"]}")
    logger.info("IP is : #{request.ip}")
    
    _redirect_to_product_sales_page_or_landing_page 
  end
  
  private
  # Unsigned cookie uniquely identifies a Payer. 
  # TODO: The click_id can be passed as custom variable to Paypal API : PAYMENTREQUEST_0_CUSTOM
  # TODO: SUBJECT=merchantEmailAddress to make the third-party API call
  # TODO: Merchant must grant third-party API access to bvparanj@zepho.com
  # TODO: Is it possible to just use click id instead of cookie to credit sales to affiliates?
  # TODO: API call will get custom value from response and do a lookup:
  # click = Click.find_by_payer_cookie(cookies[:payer_cookie])
  # cookie field is safer than referral_code to refer for bounty tracking since it is signed
  # Why does clicks table have affiliate_id? Can it be removed?
  # Why is referral_code and referral_cookie value are same in the clicks table?
  def _record_click
    Click.create(referral_code:    params[:r], 
                 product_id:       params[:p], 
                 landing_page_id:  params[:l], 
                 referral_cookie:  cookies.signed[:referral_code], 
                 payer_cookie:     cookies[:payer_cookie], 
                 domain:           request.env["HTTP_REFERER"], 
                 ip_address:       request.ip) 
                                  
    rescue Exception => e
      logger.error("Failed to record click : params are : #{params} due to #{e}")
  end
  
  def _handle_cookie
    cookie_manager = ZephoCookieManager.new(cookies)
    if cookie_manager.first_time_visit?   
      cookie_manager.set_referral_cookie(params[:r])
      cookie_manager.set_payer_cookie
    else
      logger.info("Referral cookie has already been set. The value is : #{cookies[:referral_code]}")
      logger.info("Payer cookie has already been set. The value is : #{cookies[:payer_cookie]}")
    end
  end

  def _redirect_to_product_sales_page_or_landing_page
    if params[:l]
      landing_page = LandingPage.find(params[:l])
      redirect_to landing_page.link
    else
      # This will make the tracking generic:
      # product = Product.find(params[:p]) 
      # redirect_to "http://" + product.sales_page
      
      # For now the product is on the same domain
      @product = Product.find(params[:p]) 
      
      redirect_to root_url
    end
  end

end