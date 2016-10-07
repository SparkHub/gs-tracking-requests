require 'spec_helper'

describe TrackerHub::Request do

  describe 'instantiation' do
    it { expect(described_class.new({}, 200, {})).to be_a(described_class) }

    context 'with not enought arguments' do
      it { expect{ described_class.new() }.to        raise_error(ArgumentError) }
      it { expect{ described_class.new({}) }.to      raise_error(ArgumentError) }
      it { expect{ described_class.new({}, 200) }.to raise_error(ArgumentError) }
    end
  end

  describe 'attributes' do
    subject { described_class.new({}, 200, {}) }

    describe 'getter' do

      context 'public' do
        it { expect{ subject.request }.to  raise_error(NoMethodError) }
        it { expect{ subject.status }.to   raise_error(NoMethodError) }
        it { expect{ subject.response }.to raise_error(NoMethodError) }
      end
    end

    describe 'setter' do

      context 'public' do
        it { expect{ subject.request = {} }.to  raise_error(NoMethodError) }
        it { expect{ subject.status = 201 }.to  raise_error(NoMethodError) }
        it { expect{ subject.response = {} }.to raise_error(NoMethodError) }
      end
    end
  end

  describe 'instance methods' do
    it { expect(described_class).to respond_to(:setup) }
    it { expect(described_class).to respond_to(:config) }
  end
end
