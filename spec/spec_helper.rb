require 'minitest/autorun'
require 'webmock/minitest'
require 'boardeffect'


class Module
  include Minitest::Spec::DSL
end
module BeforeHelper
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
end