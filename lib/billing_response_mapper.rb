class BillingResponseMapper
  def initialize(response)
    @response = response
  end
  
  def email
    @response.email
  end
  
  def first_name
    @response.params['first_name']
  end
  
  def last_name
    @response.params['last_name']
  end
  
  def custom
    @response.params['custom']
  end
  
  def details
    @response.params  
  end
end