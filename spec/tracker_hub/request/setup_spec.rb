require 'spec_helper'
require 'support/rails_log_path_helper'

describe TrackerHub::Request do

  describe 'attributes' do
    describe 'getter' do

      context '#config' do
        include RailsLogPathHelper

        before(:each) do
          stub_pathname
        end

        it { expect(described_class.config).to be_a(TrackerHub::Request::Config) }
      end

      context '#setup' do
        it { expect{described_class.setup}.to raise_error(LocalJumpError) }
      end
    end

    describe 'setter' do
      context 'public' do

        context '#config' do
          it { expect{described_class.config = {}}.to raise_error(NoMethodError) }
        end

        context '#setup' do
          it { expect(described_class.setup{ |s| s.app_version = '4.2' }).to eq('4.2') }
        end
      end

      context 'private' do
        context '#config' do
          it { expect(described_class.instance_variable_set(:@config, {})).to eq({}) }
        end
      end
    end
  end
end
