require 'spec_helper'
require 'json'
require 'rack/mock'
require 'support/rails_log_path_helper'
require 'support/rails'
require 'factories/env'
require 'factories/status'
require 'factories/headers'

describe TrackerHub::Request::Middleware do
  include RailsLogPathHelper

  before(:each) do
    stub_pathname
  end

  let(:status)  { Factory.status }
  let(:headers) { Factory.headers }
  let(:body)    { ['Hello World.'] }
  let(:app)     { proc { [status, headers, body] } }
  subject       { described_class.new(app) }

  describe 'middleware behavior' do
    let(:env) { Factory.env }

    context 'return values' do
      it 'expects to release the process to the next middleware' do
        results = subject.call(env)

        expect(results).to    be_an(Array)
        expect(results[0]).to eq(status)
        expect(results[1]).to eq(headers)
        expect(results[2]).to eq(body)
      end
    end

    context 'log request initalization' do

      context 'without error' do

        it 'expects to call the tracking request method' do
          expect(subject).to receive(:track).with(env, status, headers)
          subject.call(env)
        end

        it 'expects to log the current request' do
          request_to_log = TrackerHub::Request.new(env, status, headers).to_logger
          expect(TrackerHub::Request.config.logger).to receive(:info).with(request_to_log)
          subject.call(env)
        end

        context 'when it is an asset request' do
          before(:each) do
            env['SCRIPT_NAME'] = '/assets'
          end

          it 'expects to not call the tracking request method' do
            expect(TrackerHub::Request.config.logger).to_not receive(:info)
            subject.call(env)
          end
        end
      end

      context 'with internal error' do
        before(:each) do
          allow(TrackerHub::Request).to receive(:new) { raise ArgumentError }
        end

        it 'expects to not log the current request' do
          expect(TrackerHub::Request.config.logger).to_not receive(:info)
          subject.call(env)
        end

        it 'expects to notify the error' do
          expect(TrackerHub::Request.config.notification).to receive(:notify)
          subject.call(env)
        end
      end
    end
  end

  describe 'when get a response' do
    let(:request) { Rack::MockRequest.new(subject) }
    let(:response) { request.get('/') }

    context 'without error' do
      it { expect(response.status).to eq(status) }
    end

    context 'with internal error' do
      before(:each) do
        allow(TrackerHub::Request).to receive(:new) { raise ArgumentError }
      end

      it { expect{response.status}.to_not raise_error }
    end
  end
end
