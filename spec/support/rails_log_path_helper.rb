module RailsLogPathHelper
  require 'logger'

  def stub_pathname(filename = "#{Dir.getwd}/tmp")
    allow(TrackerHub::Request::Config::Logger).to receive(:log_path) do
      filename
    end
  end
end
