class ProductMailer < ActionMailer::Base
  default from: "do-not-reply@clickplan.net"
  
  def confirmation_email(order)
    @order = order
    mail(to: order.buyer_email, subject: 'Your Purchase')
  end
end
