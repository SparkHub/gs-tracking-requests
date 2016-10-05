require 'spec_helper'
require 'support/logger_helper'

describe TrackerHub::Request::Config do

  describe 'instantiation' do
    include LoggerHelper

    before(:each) do
      stub_logger
    end

    it { expect(described_class.new).to be_a(described_class) }

    context 'with too many arguments' do
      it { expect{described_class.new(app_version: '4.2')}.to raise_error(ArgumentError) }
    end

    describe 'default attribute values' do
      subject { described_class.new }

      it { expect(subject.app_version).to be_a(String) }
      it { expect(subject.logger).to be_truthy } # stubbed, so cannot test the real default value
      it { expect(subject.required_keys).to be_an(Array) }
      it { expect(subject.notification).to be_a(TrackerHub::Request::Notification) }
    end
  end

  describe 'attributes' do
    include LoggerHelper

    before(:each) do
      stub_logger
    end

    subject { described_class.new }

    describe 'getter' do
      # see 'instantiation "default attribute values"' test
    end

    describe 'setter' do
      it { expect(subject.app_version = '4.2').to eq('4.2') }
      it { expect(subject.logger = {}).to eq({}) }
      it { expect(subject.required_keys = {}).to eq({}) }
      it { expect(subject.notification = {}).to eq({}) }
    end
  end
end
