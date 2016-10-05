require 'active_support'
require 'active_support/core_ext/numeric'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'tracker_hub/request'

RSpec.configure do |config|
  tmp_dirname = 'tmp'

  config.before(:suite) do
    # create tmp dir if do not exist
    Dir.mkdir(tmp_dirname) unless File.exists?(tmp_dirname)
  end

  config.after(:suite) do
    FileUtils.rm_rf(tmp_dirname)
  end
end
