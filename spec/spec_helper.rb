require 'minitest/autorun'
require 'webmock/minitest'
require 'boardeffect'

class Module
  include Minitest::Spec::DSL
end

module BeforeHelper
  before do
    @token = 'b73cbb117c89c9ed9d8009453655e36965bdb1ca491583b22b85c7d499f8a658b1e3fff221fbb2a141880d2be3a466'
    @base_url = 'https://boardeffect.local/api/v3'
    @entry_id = @project_id = @id = 1234
    @client = BoardEffect::Client.new(access_token: @token, host: 'http://boardeffect.local', test: true)
    @auth_header = @auth_value = {headers: {'Authorization' => "Bearer #{@token}", 'User-Agent'=>'Ruby BoardEffect::Client', 'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'}}
    @json_request = {headers: {'Authorization' => "Bearer #{@token}", 'User-Agent'=>'Ruby BoardEffect::Client', 'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'}}
    @json_response = {headers: {'Content-Type' => 'application/json;charset=utf-8'}, body: '{ "success": true, "data": [] }'}
    @json_error = {headers: {'Content-Type' => 'application/json;charset=utf-8'}, body: '{ "success": false, "error": { "title": "There was an error", "message": "Something went wrong"} }'}
  end

  after do
    assert_requested(@request) if defined?(@request)
  end
end