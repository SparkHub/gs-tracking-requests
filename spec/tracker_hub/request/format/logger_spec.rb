require 'spec_helper'
require 'factories/env'
require 'support/logger_helper'
require 'active_support/core_ext/hash'

describe TrackerHub::Request::Format::Logger do

  describe 'class methods' do
    include LoggerHelper

    before(:each) do
      stub_logger
    end

    context '#clean_env' do
      let(:env) { Factory.env }
      let(:cleaned_env) { described_class.clean_env(env) }

      it { expect(cleaned_env).to be_a(Hash) }

      it 'expects to only have the specific required keys' do
        expected_keys = TrackerHub::Request.config.required_keys
        expected_keys += %w(action_dispatch.logger action_dispatch.remote_ip
                            rack.session rack.session.options http_accept_language.parser)
        expect(cleaned_env.keys - expected_keys).to be_empty
      end

      context 'formatted data' do
        let(:cleaned_env) { described_class.clean_env(env) }

        context 'action_dispatch.logger' do
          let(:logger) { cleaned_env['action_dispatch.logger'] }

          it { expect(logger).to be_a(Hash) }
          it { expect(logger.keys).to include(:session_id, :account_id, :user_id) }
          it { expect(logger.values).to all(be_a(Integer)) }
        end

        context 'action_dispatch.remote_ip' do
          let(:remote_ip) { cleaned_env['action_dispatch.remote_ip'] }

          it { expect(remote_ip).to be_a(String) }
        end

        context 'rack.session' do
          let(:rack_session) { cleaned_env['rack.session'] }

          it { expect(rack_session).to be_a(Hash) }
        end

        context 'rack.session.options' do
          let(:session_option) { cleaned_env['rack.session.options'] }

          it { expect(session_option).to be_a(Hash) }
        end

        context 'http_accept_language.parser' do
          let(:parser) { cleaned_env['http_accept_language.parser'] }

          it { expect(parser).to be_a(String) }
        end
      end
    end
  end
end

require 'json'
require 'factories/headers'
require 'factories/status'

describe TrackerHub::Request do

  describe 'instance methods' do

    context '#to_logger' do
      let(:env)     { Factory.env }
      let(:status)  { Factory.status }
      let(:headers) { Factory.headers }

      subject { described_class.new(env, status, headers) }

      let(:json) { JSON.parse(subject.to_logger) }

      it { expect(json).to be_a(Hash) }
      it { expect(json.keys).to \
        include('status', 'request', 'response', 'app_version', 'tracker_version') }

      it { expect(json['status']).to eq(status) }
      it { expect(json['request']).to eq(headers) }
      it { expect(json['response'].keys).to \
        eq(TrackerHub::Request::Format::Logger.clean_env(env).keys) }
      it { expect(json['app_version']).to eq(described_class.config.app_version) }
      it { expect(json['tracker_version']).to eq(described_class::VERSION) }
    end
  end
end
