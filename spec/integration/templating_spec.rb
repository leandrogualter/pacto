require 'securerandom'

describe 'Templating' do
  let(:contract_path) { 'spec/fixtures/contracts/templating_contract.json' }
  let(:contracts) {  Pacto.load_contracts(contract_path, 'http://dummyprovider.com') }

  let(:key) { SecureRandom.hex }
  let(:auth_token) { SecureRandom.hex }

  let :response do
    contracts.stub_all(:key => key, :auth_token => auth_token)

    raw_response = Faraday.get('http://dummyprovider.com/echo') do |req|
      req.headers = {
      'Accept' => 'application/json',
      'Custom-Auth-Token' => "#{auth_token}",
      'X-Message' => "#{key}"
      }
    end
    MultiJson.load(raw_response.body)
  end

  before :each do
    Pacto.clear!
  end

  context 'No processing' do
    it 'does not proccess erb tag' do
      Pacto.configure do |c|
        c.strict_matchers = false
        c.register_hook do |contracts, req, res|
          res
        end
      end

      expect(response.keys).to eq ['message']
      expect(response['message']).to eq("<%= req['HEADERS']['X-Message'].reverse %>")
    end
  end

  context 'Post processing' do
    it 'processes erb on each request' do
      Pacto.configure do |c|
        c.strict_matchers = false
        c.register_hook Pacto::Hooks::ERBHook.new
      end

      expect(response.keys).to eq ['message']
      expect(response['message']).to eq(key.reverse)
    end
  end
end
