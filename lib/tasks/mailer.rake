namespace :zepho do
  desc "Send order confirmation emails"
  task :confirmation => :environment do
    
    begin
      orders = Order.where(:status => Order::FULFILL)
      ProductMailer.confirmation_email(order).deliver
      Rails.logger.info("Confirmation email sent for order : #{order.id}")
    rescue Exception => e
      ZephoLogger.error("MAILER ERROR : Unable to send product confirmation email due to : ", e)
    end
    
  end
end