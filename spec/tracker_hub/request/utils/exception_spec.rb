require 'spec_helper'
require 'support/notification/hip_chat_helper'
require 'factories/notification/hip_chat'
require 'factories/notification'
require 'support/rails'

describe TrackerHub::Request::Utils::Exception do

  describe 'instantiation' do
    let(:exception) { ArgumentError.new }
    let(:notifier) { Factory.hip_chat }
    let(:notification) { Factory.notification(notifier) }

    context 'with illegal arguments' do
      it { expect{described_class.new}.to raise_error(ArgumentError) }
      it { expect{described_class.new(notification, 'extra')}.to raise_error(ArgumentError) }
    end

    context 'with valid arguments' do
      it { expect{described_class.new('any_argument')}.to_not raise_error }
      it { expect{described_class.new(notification)}.to_not raise_error }
      it { expect(described_class.new(notification)).to be_a(described_class) }
    end
  end

  describe 'instance methods' do

    describe '#report' do
      let(:exception) { ArgumentError.new }
      subject { described_class.new(exception) }
      let(:notifier) { Factory.hip_chat }
      let(:notification) { Factory.notification(notifier) }

      context 'with valid arguments' do
        include HipChatHelper

        before(:each) do
          stub_hip_chat
          allow(subject).to receive(:backtrace) { ['error1', 'error2'] }
        end

        it { expect(subject.report(notification, Rails)).to be(true) }
      end

      context 'with illegal arguments' do
        it { expect{subject.report}.to raise_error(ArgumentError) }
        it { expect{subject.report(notification, Rails, 'extra')}.to raise_error(ArgumentError) }
        it { expect{subject.report(notification, Array)}.to raise_error(NameError) }
        it { expect{subject.report([], Rails)}.to raise_error(NameError) }
      end
    end
  end
end
