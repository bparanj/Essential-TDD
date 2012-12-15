class ZephoLogger
  def self.error(message, exception, logger = Rails.logger)
    logger.error("#{message} #{exception.class.name}: #{exception.message}") 
    logger.error(exception.backtrace * "\n")
  end
end