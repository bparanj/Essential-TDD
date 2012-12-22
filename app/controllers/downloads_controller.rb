class DownloadsController < ApplicationController
  # GET http://www.clickplan.net/downloads/:confirmation_number
  def show
    order = Order.find_by_number(params[:confirmation_number])

    if (order.status == ORDER::CONFIRMED)
      order.status = Order::DELIVERED
      order.save!

      redirect_to order.product.file_url
    else
      render text: 'Unable to download file'
    end
  end
end


