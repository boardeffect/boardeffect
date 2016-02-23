require 'minitest/autorun'
require 'webmock/minitest'
require 'boardeffect'

describe 'BoardEffect::Client' do
  before do
    @token = 'd9e982b84b624ab761f718a54f5ab682b0dbf9a11e28ed334812a118eeba34ab2200ec00a923b85eb7c848343aadc601b0386b8ea875f7feb931e2674ceaaf8b'

    @base_url = 'http://boardeffect.local/services/v2'

    @entry_id = @project_id = @id = 1234

    @auth_header = {headers: {'Authorization' => "Token token=#{@token}"}}

    @json_request = {headers: {'X-BoardEffectToken' => @token, 'Content-Type' => 'application/json'}, body: /\A{.+}\z/}

    @json_response = {headers: {'Content-Type' => 'application/json;charset=utf-8'}, body: '{}'}

    @client = BoardEffect::Client.new(access_token: @token)
  end

  after do
    assert_requested(@request) if defined?(@request)
  end

  describe "get_announcements method" do
    it "fetches the announcements resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/announcements").with(@auth_header).to_return(@json_response.merge(body: '[]'))
      @client.get_announcements.must_equal([])
    end
  end
end

describe 'BoardEffect::Record' do
  before do
    @record = BoardEffect::Record.new

    @record[:project_id] = 123
  end

  describe 'square brackets method' do
    it 'returns the value of the attribute with the given name' do
      @record[:project_id].must_equal(123)
    end
  end

  describe 'method_missing' do
    it 'returns the value of the attribute with the given name' do
      @record.project_id.must_equal(123)
    end
  end

  describe 'to_h method' do
    it 'returns a hash containing the record attributes' do
      @record.to_h.must_equal({project_id: 123})
    end
  end
end