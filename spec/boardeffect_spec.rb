require 'minitest/autorun'
require 'webmock/minitest'
require 'boardeffect'

describe 'BoardEffect::Client' do
  before do
    @token = 'd9e982b84b624ab761f718a54f5ab682b0dbf9a11e28ed334812a118eeba34ab2200ec00a923b85eb7c848343aadc601b0386b8ea875f7feb931e2674ceaaf8b'

    @base_url = 'http://boardeffect.local/services/v2'

    @entry_id = @project_id = @id = 1234

    @auth_header = {headers: {'Authorization' => "Token token=#{@token}", 'User-Agent'=>'Ruby BoardEffect::Client', 'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'}}

    @json_request = {headers: {'Authorization' => "Token token=#{@token}", 'User-Agent'=>'Ruby BoardEffect::Client', 'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'}}

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

    it 'makes request to get specific workroom announcements' do
      @request = stub_request(:get, "#@base_url/announcements?workroom_id=1")
      @client.get_announcements(workroom_id: "1")
    end

    it 'raises an error if workroom_id is 0' do
      message = "Workroom ID Can not be 0"
      @request = stub_request(:get, "#@base_url/announcements?workroom_id=0").to_return(@json_response.merge(status: 400, body: %({"message":"#{message}"})))
      exception = proc { @client.get_announcements(workroom_id: "0") }.must_raise(BoardEffect::Error)
      exception.message.must_include(message)
    end
  end

  describe "create_announcement method" do
    it "posts the given attributes to the announcements resource and returns the decoded response object" do
      @request = stub_request(:post, "#@base_url/announcements").with(@json_request.merge(body: { title: "Testing api", description: "This is a description"})).to_return(@json_response.merge(status: 201))
      @client.create_announcement(title: "Testing api", description: "This is a description").must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "update_announcement method" do
    it "puts the given attributes to the announcements resource and returns the decoded response object" do
      @request = stub_request(:put, "#@base_url/announcements/1").with(@json_request.merge(body: { title: "Testing api update", description: "This is a description"})).to_return(@json_response.merge(status: 201))
      @client.update_announcement(1, {title: "Testing api update", description: "This is a description"}).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "get_announcement method" do
    it "fetches the announcement resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/announcements/1").with(@auth_header).to_return(@json_response.merge(body: '[]'))
      @client.get_announcement(1).must_equal([])
    end
  end

  describe "delete_announcement method" do
    it "deletes the announcement resource" do
      @request = stub_request(:delete, "#@base_url/announcements/1").with(@auth_header).to_return(status: 204)
      @client.delete_announcement(1).must_equal(:no_content)
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