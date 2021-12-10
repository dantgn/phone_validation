# frozen_string_literal: true

require 'json'
require 'webmock/rspec'

RSpec.describe PhoneValidation::ValidationRequest do
  let(:token) { 'abcdxxxx' }
  let(:request_url) { "http://apilayer.net/api/validate?access_key=#{token}&number=#{phone_number}" }

  describe '#call' do
    subject { described_class.new(token, phone_number).call }
    let!(:request_stub) do
      stub_request(:get, request_url).to_return(status: status_code, body: expected_response, headers: {})
    end

    context 'when request returns a valid response' do
      let(:phone_number) { '+34977222122' }
      let(:status_code) { 200 }
      let(:expected_response) { json_sample_file('phone_response_valid') }

      it 'makes the request to external api' do
        subject

        expect(request_stub).to have_been_made
      end

      it { expect(subject).to eq(expected_response) }
    end

    context 'when request returns a failed response' do
      let(:phone_number) { '123456789' }
      let(:expected_response) { json_sample_file('phone_response_invalid') }
      let(:status_code) { 404 }

      it { expect(subject).to eq(expected_response) }
    end
  end
end
