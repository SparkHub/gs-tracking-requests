require 'spec_helper'
require 'support/logger_helper'

describe TrackerHub::Request::Config::Logger do

  describe 'class variables' do

    context '#rolling_pattern' do
      it { expect(described_class::ROLLING_PATTERN).to be_a(String) }
      it { expect(described_class::ROLLING_PATTERN.frozen?).to be(true) }
    end

    context '#rolling_age' do
      it { expect(described_class::ROLLING_AGE).to be_a(String) }
      it { expect(described_class::ROLLING_AGE.frozen?).to be(true) }
    end

    context '#rolling_size' do
      it { expect(described_class::ROLLING_SIZE).to be_an(Integer) }
      it { expect(described_class::ROLLING_SIZE.frozen?).to be(true) }
    end

    context '#logger_name' do
      it { expect(described_class::LOGGER_NAME).to be_a(String) }
      it { expect(described_class::LOGGER_NAME.frozen?).to be(true) }
    end

    context '#logfile_name' do
      it { expect(described_class::LOGFILE_NAME).to be_a(String) }
      it { expect(described_class::LOGFILE_NAME.frozen?).to be(true) }
    end
  end

  describe 'class methods' do
    include LoggerHelper

    context '#default_config' do # stubbed method
      before(:each) do
        stub_logger
      end

      it { expect(described_class.default_config).to be_truthy }
    end

    context '#rolling_logger' do # stubbed method

      context 'more than 1 argument arguments' do
        before(:each) do
          stub_rolling_logger_raise(ArgumentError)
        end

        it { expect{described_class.rolling_logger('too', 'many')}.to \
          raise_error(ArgumentError) }
      end

      context 'wrong type of arguments' do
        before(:each) do
          stub_rolling_logger_raise(TypeError)
        end

        it { expect{described_class.rolling_logger('wrong')}.to raise_error(TypeError) }
      end

      context 'hash as argument' do
        before(:each) do
          stub_rolling_logger
        end

        it { expect(described_class.rolling_logger({})).to be_a(Logging::Logger) }
      end
    end
  end
end
