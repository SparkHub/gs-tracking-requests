require 'spec_helper'
require 'factories/env'
require 'support/rails_log_path_helper'
require 'active_support/core_ext/hash'
require 'json'
require 'factories/headers'
require 'factories/status'

describe TrackerHub::Request do

  describe 'instance methods' do
    include RailsLogPathHelper

    before(:each) do
      stub_pathname
    end

    let(:env)     { Factory.env }
    let(:status)  { Factory.status }
    let(:headers) { Factory.headers }

    subject { described_class.new(env, status, headers) }

    context '#to_logger' do
      let(:json) { JSON.parse(subject.to_logger) }

      it { expect(json).to be_a(Hash) }
      it { expect(json.keys).to \
        include('status', 'request', 'response', 'app_version', 'tracker_version') }

      it { expect(json['status']).to eq(status) }
      it { expect(json['request']).to eq(headers) }
      it { expect(json['response'].keys).to eq(subject.cleaned_env.keys) }
      it { expect(json['app_version']).to eq(described_class.config.app_version) }
      it { expect(json['tracker_version']).to eq(described_class::VERSION) }
    end

    context '#cleaned_env' do
      let(:cleaned_env) { subject.cleaned_env }

      it { expect(cleaned_env).to be_a(Hash) }

      it 'expects to only have the specific required keys' do
        expected_keys = TrackerHub::Request.config.required_keys
        expected_keys += %w(action_dispatch.logger action_dispatch.remote_ip
                            rack.session rack.session.options http_accept_language.parser)
        expect(cleaned_env.keys - expected_keys).to be_empty
      end

      context '#serialized_env' do
        let(:serialized_env) { subject.serialized_env }

        context 'action_dispatch.logger' do
          let(:logger) { serialized_env['action_dispatch.logger'] }

          it { expect(logger).to be_a(Hash) }
          it { expect(logger.keys).to include(:session_id, :account_id, :user_id) }
          it { expect(logger.values).to all(be_a(Integer)) }
        end

        context 'action_dispatch.remote_ip' do
          let(:remote_ip) { serialized_env['action_dispatch.remote_ip'] }

          it { expect(remote_ip).to be_a(String) }
        end

        context 'rack.session' do
          let(:rack_session) { serialized_env['rack.session'] }

          it { expect(rack_session).to be_a(Hash) }
        end

        context 'rack.session.options' do
          let(:session_option) { serialized_env['rack.session.options'] }

          it { expect(session_option).to be_a(Hash) }
        end

        context 'http_accept_language.parser' do
          let(:parser) { serialized_env['http_accept_language.parser'] }

          it { expect(parser).to be_a(String) }
        end
      end
    end
  end
end
