namespace :zepho do
  desc "Send order confirmation emails"
  task :confirmation => :environment do
    
    begin
      orders = Order.where(:status => Order::FULFILL)
      Rails.logger.info("Number of orders to be processed : #{orders.size}")
      orders.each do |order|
        Rails.logger.info("Processing order : #{order.id}")
        begin
          Rails.logger.info("Sending confirmation email")
          ProductMailer.confirmation_email(order).deliver
          Rails.logger.info("Confirmation email sent")
          order.status = Order::CONFIRMED
          Rails.logger.info("Saving the order")
          order.save!
          Rails.logger.info("Order saved")
          Rails.logger.info("Confirmation email sent for order : #{order.id}")
        rescue  => ex
          ZephoLogger.error("ORDER CONFIRMATION : Something went wrong due to : ", ex)
        end
      end
    rescue Exception => e
      ZephoLogger.error("ORDER CONFIRMATION : Something went wrong due to : ", e)
    end
        
  end
end