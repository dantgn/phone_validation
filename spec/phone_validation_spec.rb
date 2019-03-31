# frozen_string_literal: true

RSpec.shared_examples 'returns method name field extracted from response' do |method_response|
  context 'when response returns valid phone' do
    let(:response) { json_sample_file('phone_response_valid') }

    it { expect(subject).to eq(method_response) }
  end

  context 'when response returns invalid phone' do
    let(:response) { json_sample_file('phone_response_invalid') }

    it { expect(subject).to be_empty }
  end

  context 'when response returns internal API error message' do
    let(:response) { json_sample_file('api_internal_error') }

    it 'raises an error' do
      expect { subject }.
        to raise_error(
          PhoneValidation::ApiInternalError,
          'You have not supplied a valid API Access Key.'
        )
    end
  end
end

RSpec.describe PhoneValidation::Client do
  let(:token) { 'abcdxxx' }
  let(:phone_number) { '34977222122' }

  describe '.initialize' do
    subject { described_class.new(token, phone_number) }

    context 'when token is not provided' do
      let(:token) { nil }

      it { expect { subject }.to raise_error(PhoneValidation::InvalidToken, "Token can't be nil") }
    end

    context 'when phone number is not provided' do
      let(:phone_number) { nil }

      it { expect { subject }.to raise_error(PhoneValidation::InvalidNumber, "Phone number can't be nil") }
    end

    context 'when token and phone number are provided' do
      it { expect(subject).to be }
    end
  end

  context 'instance methods' do
    let(:request_service) { instance_double('PhoneValidation::ValidationRequest') }

    before do
      expect(PhoneValidation::ValidationRequest).
        to receive(:new).
        once.
        with(token, phone_number).
        and_return(request_service)

      expect(request_service).to receive(:call).and_return(response)
    end

    describe '#valid?' do
      subject { described_class.new(token, phone_number).valid? }

      context 'when response returns valid phone' do
        let(:response) { json_sample_file('phone_response_valid') }

        it { expect(subject).to eq(true) }
      end

      context 'when response returns invalid phone' do
        let(:response) { json_sample_file('phone_response_invalid') }

        it { expect(subject).to eq(false) }
      end

      context 'when response returns internal API error message' do
        let(:response) { json_sample_file('api_internal_error') }

        it 'raises an error' do
          expect { subject }.
            to raise_error(
              PhoneValidation::ApiInternalError,
              'You have not supplied a valid API Access Key.'
            )
        end
      end
    end

    describe '#local_format' do
      subject { described_class.new(token, phone_number).local_format }

      it_behaves_like 'returns method name field extracted from response', '977222122'
    end

    describe '#international_format' do
      subject { described_class.new(token, phone_number).international_format }

      it_behaves_like 'returns method name field extracted from response', '+34977222122'
    end

    describe '#country_prefix' do
      subject { described_class.new(token, phone_number).country_prefix }

      it_behaves_like 'returns method name field extracted from response', '+34'
    end

    describe '#country_code' do
      subject { described_class.new(token, phone_number).country_code }

      it_behaves_like 'returns method name field extracted from response', 'ES'
    end

    describe '#country_name' do
      subject { described_class.new(token, phone_number).country_name }

      it_behaves_like 'returns method name field extracted from response', 'Spain'
    end

    describe '#location' do
      subject { described_class.new(token, phone_number).location }

      it_behaves_like 'returns method name field extracted from response', 'Tarragona'
    end

    describe '#carrier' do
      subject { described_class.new(token, phone_number).carrier }

      it_behaves_like 'returns method name field extracted from response', ''
    end

    describe '#line_type' do
      subject { described_class.new(token, phone_number).line_type }

      it_behaves_like 'returns method name field extracted from response', 'landline'
    end
  end
end
