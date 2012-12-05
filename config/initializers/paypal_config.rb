PAYPAL_CONFIG = YAML.load_file(Rails.root.join("config","paypal_config.yml"))[Rails.env]

options = {
  login: PAYPAL_CONFIG["login"],
  password: PAYPAL_CONFIG["password"],
  signature: PAYPAL_CONFIG["signature"]
}

if Rails.env.test?
  ZephoPaypalExpress = ActiveMerchant::Billing::BogusGateway.new
else
  ZephoPaypalExpress = ActiveMerchant::Billing::PaypalExpressGateway.new(options)  
end
