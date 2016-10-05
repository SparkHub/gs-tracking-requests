module LoggerHelper
  require 'logger'

  def stub_logger(filename = "#{Dir.getwd}/tmp/requests.log")
    allow(TrackerHub::Request::Config::Logger).to receive(:default_config) do
      ::Logger.new(filename)
    end
  end

  def stub_rolling_logger(filename = "#{Dir.getwd}/tmp/rolling-requests.log")
    allow(TrackerHub::Request::Config::Logger).to receive(:rolling_logger) do
      ::Logging.logger.new(filename)
    end
  end

  def stub_rolling_logger_raise(class_error)
    allow(TrackerHub::Request::Config::Logger).to receive(:rolling_logger) do
      raise class_error
    end
  end
end
