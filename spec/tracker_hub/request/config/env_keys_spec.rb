require 'spec_helper'

describe TrackerHub::Request::Config::EnvKeys do

  describe 'class methods' do

    context '#default_config' do
      it { expect(described_class.default_config).to be_an(Array) }
      it { expect(described_class.default_config).to all(be_a(String)) }
    end
  end
end
