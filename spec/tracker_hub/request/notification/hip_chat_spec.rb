require 'spec_helper'
require 'factories/notification/hip_chat'
require 'support/notification/hip_chat_helper'

describe TrackerHub::Request::Notification::HipChat do

  describe 'class variables' do
    it { expect(described_class::API_VERSION).to be_a(String) }
    it { expect(described_class::API_VERSION.frozen?).to be(true) }
  end


  describe 'instantiation' do

    context 'with valid arguments' do
      it { expect{described_class.new('token', 'room', 'username')}.to_not raise_error }
      it { expect{described_class.new('token', 'room', 'username', {})}.to_not raise_error }
    end

    context 'API version' do
      subject { Factory.hip_chat(api_version: 'v1') }

      it { expect(subject.instance_variable_get(:@options).keys).to_not include(:api_version) }
    end

    context 'with illegal arguments' do
      it { expect{described_class.new}.to raise_error(ArgumentError) }
      it { expect{described_class.new('token')}.to raise_error(ArgumentError) }
      it { expect{described_class.new('token', 'room')}.to raise_error(ArgumentError) }
      it { expect{described_class.new('token', 'room', 'username', 'options')}.to \
          raise_error(TypeError) }
      it { expect{described_class.new('token', 'room', 'username', {}, 'extra')}.to \
          raise_error(ArgumentError) }
    end
  end

  describe 'attributes' do

    context 'public' do
      subject { Factory.hip_chat }

      context '#client' do
        it { expect{subject.client}.to raise_error(NoMethodError) }
      end

      context '#username' do
        it { expect{subject.username}.to raise_error(NoMethodError) }
      end

      context '#room' do
        it { expect{subject.room}.to raise_error(NoMethodError) }
      end

      context '#options' do
        it { expect{subject.options}.to raise_error(NoMethodError) }
      end
    end
  end

  describe 'instance methods' do

    context '#send_message' do
      # Note: we are expecting `raise_error(Exception)` and not specific class error
      # because if the tests are run with no network connection, then a :SocketError:
      # will be raised.

      context 'with invalid token' do
        subject { Factory.hip_chat(token: 'invalid_token') }

        it { expect{subject.send_message('my message')}.to raise_error(Exception) } # Hipchat error
      end

      context 'with invalid token' do
        subject { Factory.hip_chat(room: 'unauthorized_room') }

        it { expect{subject.send_message('my message')}.to raise_error(Exception) } # Hipchat error
      end

      context 'with invalid api version' do
        subject { Factory.hip_chat(api_version: 42) }

        it { expect{subject.send_message('my message')}.to raise_error(HipChat::InvalidApiVersion) }
      end

      context 'with illegal arguments' do
        subject { Factory.hip_chat }

        it { expect{subject.send_message()}.to raise_error(ArgumentError) }
        it { expect{subject.send_message('my message', 'options')}.to raise_error(TypeError) }
        it { expect{subject.send_message('my message', {}, 'extra')}.to raise_error(ArgumentError) }
      end

      context 'with valid arguments' do
        include HipChatHelper

        subject { Factory.hip_chat }

        before(:each) do
          stub_hip_chat
        end

        it { expect(subject.send_message('my message')).to be(true) }
      end
    end
  end
end
