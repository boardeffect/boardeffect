require_relative 'spec_helper'

describe 'BoardEffect::Client' do
  include BeforeHelper

  # Announcements
  describe "get_announcements method" do
    it "fetches the announcements resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/announcements.json").with(@auth_header).to_return(@json_response.merge(body: '[]'))
      @client.get_announcements.must_equal([])
    end

    it 'makes request to get specific workroom announcements' do
      @request = stub_request(:get, "#@base_url/announcements.json?workroom_id=1")
      @client.get_announcements(workroom_id: "1")
    end

    it 'raises an error if workroom_id is 0' do
      message = "Workroom ID Can not be 0"
      @request = stub_request(:get, "#@base_url/announcements.json?workroom_id=0").to_return(@json_response.merge(status: 400, body: %({"message":"#{message}"})))
      exception = proc { @client.get_announcements(workroom_id: "0") }.must_raise(BoardEffect::Error)
      exception.message.must_include(message)
    end
  end

  describe "create_announcement method" do
    it "posts the given attributes to the announcements resource and returns the decoded response object" do
      @request = stub_request(:post, "#@base_url/announcements.json").with(@json_request.merge(body: { title: "Testing api", body: "This is a description"})).to_return(@json_response.merge(status: 201))
      @client.create_announcement({title: "Testing api", body: "This is a description"}, {workroom_id: 1}).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "update_announcement method" do
    it "puts the given attributes to the announcements resource and returns the decoded response object" do
      @request = stub_request(:put, "#@base_url/announcements/1.json").with(@json_request.merge(body: { title: "Testing api update", body: "This is a description"})).to_return(@json_response.merge(status: 201))
      @client.update_announcement(1, {title: "Testing api update", body: "This is a description"}).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "get_announcement method" do
    it "fetches the announcement resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/announcements/1.json").with(@auth_header).to_return(@json_response.merge(body: '[]'))
      @client.get_announcement(1).must_equal([])
    end
  end

  describe "delete_announcement method" do
    it "deletes the announcement resource" do
      @request = stub_request(:delete, "#@base_url/announcements/1.json").with(@auth_header).to_return(status: 204)
      @client.delete_announcement(1).must_equal(:no_content)
    end
  end

  # Events
  describe "get_events method" do
    it "fetches the events resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/events.json?workroom_id=1").with(@auth_header).to_return(@json_response.merge(body: '[]'))
      @client.get_events(workroom_id: 1).must_equal([])
    end
  end

  describe "create_event method" do
    it "posts the given attributes to the events resource and returns the decoded response object" do
      attributes = {title: "Testing api", description: "This is a description", location: "Test location", eventcolor_id: "1", datetime_start: Time.now.to_s, datetime_end: Time.now.to_s}
      @request = stub_request(:post, "#@base_url/workrooms/1/events.json").with(@json_request.merge(body: attributes.to_json)).to_return(@json_response.merge(status: 201))
      @client.create_event(attributes, workroom_id: 1).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "update_event method" do
    it "puts the given attributes to the event resource and returns the decoded response object" do
      attributes = { location: "This is a new location" }
      @request = stub_request(:put, "#@base_url/workrooms/1/events/1.json").with(@json_request.merge(body: attributes.to_json)).to_return(@json_response.merge(status: 201))
      @client.update_event(1, attributes, workroom_id: 1).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "get_event method" do
    it "fetches the event resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/workrooms/1/events/1.json").with(@auth_header).to_return(@json_response.merge(body: '[]'))
      @client.get_event(1, workroom_id: 1).must_equal([])
    end
  end

  describe "delete_event method" do
    it "deletes the event resource" do
      @request = stub_request(:delete, "#@base_url/workrooms/1/events/1.json").with(@auth_header).to_return(status: 204)
      @client.delete_event(1, workroom_id: 1).must_equal(:no_content)
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