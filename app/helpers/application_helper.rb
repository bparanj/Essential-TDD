module ApplicationHelper
  def is_active?(page_name)
    logger.info("Page name #{page_name}")
    logger.info("Controller name #{params[:controller]}")
    servlet = params[:controller]
    if servlet == page_name
      "active"
    else
      ""
    end
  end
end