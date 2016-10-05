module TrackerHub
  class Request
    class Config

      module Logger

        class << self

          def rolling_logger(args)
            raise NameError, 'uninitialized constant Logging' unless defined?(Logging)

            app_log_path = Pathname.new(Rails.application.config.paths['log'].first).parent.to_s
            rolling_pattern = '%Y-%m-%d-%H-%M-%S'
            logfile_name = 'requests.log'

            options = {
              log_path:        app_log_path,
              logger_name:     'requests',
              logfile_pattern: "#{logfile_name}{{.#{rolling_pattern}}}",

              age:             'daily',
              size:            1.gigabyte
            }.merge(args)

            logfile_path = File.join(options.delete(:log_path),
                                     options.delete(:logfile_pattern))

            logger  = Logging.logger.new(options.delete(:logger_name))
            rolling = Logging::Appenders::RollingFile.new(logfile_path, options)
            logger.add_appenders(rolling)

            logger
          end

          def default_config
            filename = 'requests.log'
            log_path = Pathname.new(Rails.application.config.paths['log'].first).parent.to_s
            ::ActiveSupport::Logger.new(File.join(log_path, filename))
          end
        end
      end
    end
  end
end
