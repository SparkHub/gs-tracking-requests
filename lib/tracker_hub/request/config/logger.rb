module TrackerHub
  class Request
    class Config

      module Logger
        ROLLING_PATTERN = '%Y-%m-%d-%H-%M-%S'.freeze
        ROLLING_AGE     = 'daily'.freeze
        ROLLING_SIZE    = 1.gigabyte.freeze
        LOGGER_NAME     = 'requests'.freeze
        LOGFILE_NAME    = "#{LOGGER_NAME}.log".freeze

        class << self

          # Template for the rolling logger configuration
          #   Note: for additional options, please refer to:
          #   http://www.rubydoc.info/gems/logging/Logging/Appenders/RollingFile:initialize
          #
          # @option args [String] :log_path ('/log') Path of the log file
          # @option args [String] :logger_name ('requests') Name of the log file
          # @option args [String] :logfile_pattern ('requests.log.%Y-%m-%d-%H-%M-%S')
          #   Pattern to roll log files
          # @option args [String|Integer] :age ('daily') The maximum age (in seconds)
          #   of a log file before it is rolled.
          # @option args [String] :size (1073741824) The maximum allowed size (in bytes)
          #   of a log file before it is rolled.
          # @return [Logging::Logger]
          #
          # @example
          #   > options = { logger_name: 'my_logger' }
          #   > logger = TrackerHub::Request::Config::Logger.rolling_logger(options)
          #   > logger.info('log text')
          #
          # @api public
          def rolling_logger(args = {})
            options = extract_rolling_options(args)

            build_rolling_logger(options)
          end

          # Default configuration for the logger
          #
          # @return [ActiveSupport::Logger]
          #
          # @example
          #   > logger = TrackerHub::Request::Config::Logger.default_config
          #   > logger.info('log text')
          #
          # @api public
          def default_config
            ::ActiveSupport::Logger.new(File.join(log_path, LOGFILE_NAME))
          end

          private

          # Extract the given rolling logger arguments and merge with defaults
          #
          # @param  [Hash] args Options to configure the rolling logger
          # @return [Hash]
          #
          # @api private
          def extract_rolling_options(args)
            {
              log_path:        log_path,
              logger_name:     LOGGER_NAME,
              logfile_pattern: "#{LOGFILE_NAME}{{.#{ROLLING_PATTERN}}}",

              age:             ROLLING_AGE,
              size:            ROLLING_SIZE
            }.merge(args)
          end

          # Build a rolling logger based on the given options
          #
          # @param  [Hash] options Options to configure the rolling logger
          # @return [Logging]
          #
          # @api private
          def build_rolling_logger(options)
            logfile_path = File.join(options.delete(:log_path),
                                     options.delete(:logfile_pattern))

            logger  = Logging.logger.new(options.delete(:logger_name))
            rolling = Logging::Appenders::RollingFile.new(logfile_path, options)
            logger.add_appenders(rolling)

            logger
          end
        end
      end
    end
  end
end
