require 'spec_helper'
require 'support/struct'
require 'support/notification/hip_chat_helper'
require 'factories/notification'
require 'factories/notification/hip_chat'
require 'support/rails'

describe TrackerHub::Request::Notification do

  describe 'class variables' do
    it { expect(described_class::KEY_CACHE).to be_a(String) }
    it { expect(described_class::KEY_CACHE.frozen?).to be(true) }
  end

  describe 'attributes' do

    context 'public' do
      subject { described_class.new('my_notifier', timelapse: 42, my: 'option') }

      context '#notifier' do
        it { expect(subject.notifier).to eq('my_notifier') }
        it { expect{subject.notifier = 'hack'}.to raise_error(NoMethodError) }
      end

      context '#timelapse' do
        it { expect(subject.timelapse).to eq(42) }
        it { expect{subject.timelapse = 84}.to raise_error(NoMethodError) }
      end

      context '#options' do
        it { expect(subject.options.keys).to include(:my) }
        it { expect{subject.options = {}}.to raise_error(NoMethodError) }
      end
    end

    context 'private' do
      subject { described_class.new }

      context '#notifier' do
        it { expect(subject.instance_variable_set(:@notifier, 'hack')).to eq('hack') }
      end

      context '#timelapse' do
        it { expect(subject.instance_variable_set(:@timelapse,84)).to eq(84) }
      end

      context '#options' do
        it { expect(subject.instance_variable_set(:@options, {my: 'option'})).to \
          eq({my: 'option'}) }
      end
    end
  end

  describe 'initialization' do
    let(:notifier) { Struct.new_singleton('Notifier') }

    it { expect(described_class.new).to be_a(described_class) }
    it { expect(described_class.new(notifier)).to be_a(described_class) }
    it { expect(described_class.new(notifier, my: :option)).to be_a(described_class) }
    it { expect{described_class.new(notifier, {}, [])}.to raise_error(ArgumentError) }
  end

  describe 'instance methods' do

    context '#notify' do
      include HipChatHelper

      context 'without timelapse' do
        let(:notifier) { Struct.new_singleton('Notifier') }
        subject { Factory.notification(notifier) }

        it { expect{subject.notify('message')}.to_not raise_error }

        it 'expects to not write in the cache' do
          subject.notify('message')
          expect(Rails.cache.exist?(described_class::KEY_CACHE)).to be(false)
        end
      end

      context 'with timelapse' do
        let(:notifier) { Factory.hip_chat }
        subject { Factory.notification(notifier, timelapse: 42.minutes) }

        before(:each) do
          Rails.cache.clear
          stub_hip_chat
        end

        it 'expects to write the timelapse in the cache' do
          subject.notify('message')
          expect(Rails.cache.exist?(described_class::KEY_CACHE)).to be(true)
        end
      end

      context 'hip_chat' do
        let(:notifier) { Factory.hip_chat }
        subject { Factory.notification(notifier) }

        before(:each) do
          stub_hip_chat
        end

        it { expect(subject.notify('message')).to be(true) }
      end
    end
  end
end
