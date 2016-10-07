require 'spec_helper'

describe TrackerHub::Request::Utils::Env do

  describe 'instantiation' do

    context 'with illegal arguments' do
      it { expect{described_class.new}.to raise_error(ArgumentError) }
      it { expect{described_class.new({}, 'extra')}.to raise_error(ArgumentError) }
    end

    context 'with valid arguments' do
      it { expect{described_class.new('any_argument')}.to_not raise_error }
      it { expect{described_class.new({})}.to_not raise_error }
      it { expect(described_class.new({})).to be_a(described_class) }
    end
  end

  describe 'instance methods' do

    describe '#trackable?' do

      context 'asset request' do
        subject { described_class.new({'SCRIPT_NAME' => '/assets'}) }

        it { expect(subject.trackable?).to be(false) }
      end

      context 'non asset request' do
        subject { described_class.new({'SCRIPT_NAME' => ''}) }

        it { expect(subject.trackable?).to be(true) }
      end
    end
  end
end
