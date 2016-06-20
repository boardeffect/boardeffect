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

  # RSVPS
  describe "get_rsvps method" do
    it "fetches the rsvps resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/workrooms/1/events/1/rsvps.json").with(@auth_header).to_return(@json_response.merge(body: '[]'))
      @client.get_rsvps(workroom_id: 1, event_id: 1).must_equal([])
    end
  end

  describe "create_rsvp method" do
    it "posts the given attributes to the rsvps resource and returns the decoded response object" do
      attributes = {title: "Testing api", description: "This is a description", location: "Test location", expiration_date: Time.now.to_s}
      @request = stub_request(:post, "#@base_url/workrooms/1/events/1/rsvps.json").with(@json_request.merge(body: attributes.to_json)).to_return(@json_response.merge(status: 201))
      @client.create_rsvp(attributes, { workroom_id: 1, event_id: 1}).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "get_rsvp method" do
    it "fetches the rsvp resource and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/workrooms/1/events/1/rsvps/1.json").with(@auth_header).to_return(@json_response.merge(body: '[]'))
      @client.get_rsvp(1, {workroom_id: 1, event_id: 1}).must_equal([])
    end
  end

  describe "add_invitee method" do
    it "adds an array of user_ids to an rsvp" do
      @request = stub_request(:post, "#@base_url/workrooms/1/events/1/rsvps/1/add_invitee.json").with(@json_request.merge(body: { ids: "1,2,3"}.to_json)).to_return(@json_response.merge(status: 201))
      @client.add_invitee(1, {ids: "1,2,3"}, {workroom_id: 1, event_id: 1}).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "remove_invitee method" do
    it "removes an array of user_ids to an rsvp" do
      @request = stub_request(:post, "#@base_url/workrooms/1/events/1/rsvps/1/add_invitee.json").with(@json_request.merge(body: { ids: "1,3"}.to_json)).to_return(@json_response.merge(status: 201))
      @client.add_invitee(1, {ids: "1,3"}, {workroom_id: 1, event_id: 1}).must_be_instance_of(BoardEffect::Record)
    end
  end

  # Userclasses
  describe "get_userclasses method" do
    it "fetches the userclasses resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/userclasses.json").with(@auth_header).to_return(@json_response.merge(body: '[]'))
      @client.get_userclasses.must_equal([])
    end
  end

  describe "create_userclass method" do
    it "posts the given attributes to the userclass resource and returns the decoded response object" do
      attributes = {title: "New Userclass"}
      @request = stub_request(:post, "#@base_url/userclasses.json").with(@json_request.merge(body: attributes.to_json)).to_return(@json_response.merge(status: 201))
      @client.create_userclass(attributes).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "update_userclass method" do
    it "puts the given attributes to the userclass resource and returns the decoded response object" do
      attributes = { title: "Old Userclass" }
      @request = stub_request(:put, "#@base_url/userclasses/1.json").with(@json_request.merge(body: attributes.to_json)).to_return(@json_response.merge(status: 201))
      @client.update_userclass(1, attributes).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "get_userclass method" do
    it "fetches the userclass resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/userclasses/1.json").with(@auth_header).to_return(@json_response.merge(body: '[]'))
      @client.get_userclass(1).must_equal([])
    end
  end

  describe "delete_userclass method" do
    it "deletes the userclass resource" do
      @request = stub_request(:delete, "#@base_url/userclasses/1.json").with(@auth_header).to_return(status: 204)
      @client.delete_userclass(1).must_equal(:no_content)
    end
  end

  # Books
  describe "get_books method" do
    it "fetches the books resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/books.json?workroom_id=1").with(@auth_header).to_return(@json_response.merge(body: '[]'))
      @client.get_books(workroom_id: 1).must_equal([])
    end
    it "fetches the books resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/books/paginated.json?workroom_id=1&page=1").with(@auth_header).to_return(@json_response.merge(body: '[]'))
      @client.get_paginated_books(workroom_id: 1, page: 1).must_equal([])
    end
  end

  describe "get_book method" do
    it "fetches the book resource and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/workrooms/1/books/1.json?").with(@auth_header).to_return(@json_response.merge(body: '[]'))
      @client.get_book(1, workroom_id: 1).must_equal([])
    end
  end

  # Clients
  describe "get_client method" do
    it "fetches the client resource and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/clients/1.json?").with(@auth_header).to_return(@json_response.merge(body: '[]'))
      @client.get_client(1).must_equal([])
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