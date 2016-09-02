require_relative 'spec_helper'

describe 'BoardEffect::Client' do
  include BeforeHelper

  # Announcements
  describe "get_announcements method" do
    it "fetches the announcements resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/workrooms/1/announcements.json?workroom_id=1").with(@auth_header).to_return(@json_response)
      @client.get_announcements(workroom_id: 1).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "create_announcement method" do
    it "posts the given attributes to the announcements resource and returns the decoded response object" do
      @request = stub_request(:post, "#@base_url/workrooms/1/announcements.json").with(@json_request.merge(body: { title: "Testing api", body: "This is a description"})).to_return(@json_response.merge(status: 201))
      @client.create_announcement({title: "Testing api", body: "This is a description"}, {workroom_id: 1}).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "update_announcement method" do
    it "puts the given attributes to the announcements resource and returns the decoded response object" do
      @request = stub_request(:put, "#@base_url/workrooms/1/announcements/1.json").with(@json_request.merge(body: { title: "Testing api update", body: "This is a description"})).to_return(@json_response.merge(status: 201))
      @client.update_announcement(1, {title: "Testing api update", body: "This is a description"}, workroom_id: 1).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "get_announcement method" do
    it "fetches the announcement resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/workrooms/1/announcements/1.json").with(@auth_header).to_return(@json_response)
      @client.get_announcement(1, workroom_id: 1).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "delete_announcement method" do
    it "deletes the announcement resource" do
      @request = stub_request(:delete, "#@base_url/workrooms/1/announcements/1.json").with(@auth_header).to_return(status: 204)
      @client.delete_announcement(1, workroom_id: 1).must_equal(:no_content)
    end
  end

  # Events
  describe "get_events method" do
    it "fetches the events resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/workrooms/1/events.json?workroom_id=1").with(@auth_header).to_return(@json_response)
      @client.get_events(workroom_id: 1).must_be_instance_of(BoardEffect::Record)
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
      @request = stub_request(:get, "#@base_url/workrooms/1/events/1.json").with(@auth_header).to_return(@json_response)
      @client.get_event(1, workroom_id: 1).must_be_instance_of(BoardEffect::Record)
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
      @request = stub_request(:get, "#@base_url/workrooms/1/events/1/rsvps.json").with(@auth_header).to_return(@json_response)
      @client.get_rsvps(workroom_id: 1, event_id: 1).must_be_instance_of(BoardEffect::Record)
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
      @request = stub_request(:get, "#@base_url/workrooms/1/events/1/rsvps/1.json").with(@auth_header).to_return(@json_response)
      @client.get_rsvp(1, {workroom_id: 1, event_id: 1}).must_be_instance_of(BoardEffect::Record)
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

  # # Userclasses
  describe "get_userclasses method" do
    it "fetches the userclasses resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/userclasses.json").with(@auth_header).to_return(@json_response)
      @client.get_userclasses.must_be_instance_of(BoardEffect::Record)
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
      @request = stub_request(:get, "#@base_url/userclasses/1.json").with(@auth_header).to_return(@json_response)
      @client.get_userclass(1).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "delete_userclass method" do
    it "deletes the userclass resource" do
      @request = stub_request(:delete, "#@base_url/userclasses/1.json").with(@auth_header).to_return(status: 204)
      @client.delete_userclass(1).must_equal(:no_content)
    end
  end

  # # Books
  describe "get_books method" do
    it "fetches the books resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/workrooms/1/books.json?workroom_id=1").with(@auth_header).to_return(@json_response)
      @client.get_books(workroom_id: 1).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "get_book method" do
    it "fetches the book resource and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/workrooms/1/books/1.json?").with(@auth_header).to_return(@json_response)
      @client.get_book(1, workroom_id: 1).must_be_instance_of(BoardEffect::Record)
    end
  end

  # # Clients
  describe "get_client method" do
    it "fetches the client resource and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/clients/1.json?").with(@auth_header).to_return(@json_response)
      @client.get_client(1).must_be_instance_of(BoardEffect::Record)
    end
  end

  # # Custom Fields
  describe "get_custom_fields method" do
    it "fetches the custom fields resource and returns the decoded response object" do
      attributes = { "id" => 0, "label" => "string", "field_type" => "string", "options" => "string"}
      @request = stub_request(:get, "#@base_url/custom_fields.json?").with(@auth_header).to_return(@json_response)
      @client.get_custom_fields.must_be_instance_of(BoardEffect::Record)
    end
  end

  # # Discussions
  describe "get_discussions method" do
    it "fetches the discussions resource and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/workrooms/1/discussions.json").with(@auth_header).to_return(@json_response)
      @client.get_discussions(workroom_id: 1).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "get_discussion method" do
    it "fetches the discussion resource and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/workrooms/1/discussions/1.json").with(@auth_header).to_return(@json_response)
      @client.get_discussion(1, workroom_id: 1).must_be_instance_of(BoardEffect::Record)
    end
  end

  # # Discussion Posts
  describe "get_discussion_post" do
    it "fetches the discussion post resource and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/workrooms/1/discussions/1/discussion_posts/1.json").with(@auth_header).to_return(@json_response)
      @client.get_discussion_post(1, 1, workroom_id: 1).must_be_instance_of(BoardEffect::Record)
    end
  end

  # # Event Categories
  describe "get_event_categories" do
    it "fetches the event category resource and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/eventcolors.json").with(@auth_header).to_return(@json_response)
      @client.get_event_categories().must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "create_event_category" do
    it "creates the event category resource and returns the decoded response object" do
      attributes = {title: "New Event Category", color: 'FFFF00'}
      @request = stub_request(:post, "#@base_url/eventcolors.json").with(@json_request.merge(body: attributes.to_json)).to_return(@json_response.merge(status: 201))
      @client.create_event_category(attributes).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "update_event_category" do
    it "updates the event category resource and returns the decoded response object" do
      attributes = {title: "Updated Event Category", color: 'FFFFCC'}
      @request = stub_request(:put, "#@base_url/eventcolors/1.json").with(@json_request.merge(body: attributes.to_json)).to_return(@json_response.merge(status: 201))
      @client.update_event_category(1, attributes).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "get_event_category" do
    it "fetches the event category resource and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/eventcolors/1.json").with(@auth_header).to_return(@json_response)
      @client.get_event_category(1).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "delete_event_category" do
    it "fetches the event category resource and returns the decoded response object" do
      @request = stub_request(:delete, "#@base_url/eventcolors/1.json").with(@auth_header).to_return(@json_response)
      @client.delete_event_category(1).must_be_instance_of(BoardEffect::Record)
    end
  end

  # # Surveys
  describe "get_surveys" do
    it "fetches the survey resource and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/workrooms/1/surveys.json").with(@auth_header).to_return(@json_response)
      @client.get_surveys(workroom_id: 1).must_be_instance_of(BoardEffect::Record)
    end
  end

  # # Users
  describe "get_users" do
    it "fetches the users resource and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/users.json").with(@auth_header).to_return(@json_response)
      @client.get_users.must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "get_user" do
    it "fetches the user resource and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/users/1.json").with(@auth_header).to_return(@json_response)
      @client.get_user(1).must_be_instance_of(BoardEffect::Record)
    end
  end

  # # Workgroups
  describe "get_workgroups" do
    it "fetches the workgroups resource and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/committeegroups.json").with(@auth_header).to_return(@json_response)
      @client.get_workgroups.must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "get_workgroup" do
    it "fetches the workgroup resource and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/committeegroups/1.json").with(@auth_header).to_return(@json_response)
      @client.get_workgroup(1).must_be_instance_of(BoardEffect::Record)
    end
  end

  # # Workrooms
  describe "get_workrooms method" do
    it "fetches the workrooms resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/workrooms.json").with(@auth_header).to_return(@json_response)
      @client.get_workrooms.must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "create_workroom method" do
    it "posts the given attributes to the workroom resource and returns the decoded response object" do
      attributes = {name: "New Workroom"}
      @request = stub_request(:post, "#@base_url/workrooms.json").with(@json_request.merge(body: attributes.to_json)).to_return(@json_response.merge(status: 201))
      @client.create_workroom(attributes).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "update_workroom method" do
    it "puts the given attributes to the workroom resource and returns the decoded response object" do
      attributes = { name: "Updated Workroom" }
      @request = stub_request(:put, "#@base_url/workrooms/1.json").with(@json_request.merge(body: attributes.to_json)).to_return(@json_response.merge(status: 201))
      @client.update_workroom(1, attributes).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "get_workroom method" do
    it "fetches the workroom resources and returns the decoded response object" do
      @request = stub_request(:get, "#@base_url/workrooms/1.json").with(@auth_header).to_return(@json_response)
      @client.get_workroom(1).must_be_instance_of(BoardEffect::Record)
    end
  end

  describe "delete_workroom method" do
    it "deletes the workroom resource" do
      @request = stub_request(:delete, "#@base_url/workrooms/1.json").with(@auth_header).to_return(status: 204)
      @client.delete_workroom(1).must_equal(:no_content)
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