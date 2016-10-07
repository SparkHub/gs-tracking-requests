require 'spec_helper'

describe TrackerHub::Request do

  describe 'version' do
    it { expect(described_class::VERSION).not_to be nil }
  end
end
