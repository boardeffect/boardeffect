require 'boardeffect/client'
require 'boardeffect/version'

module BoardEffect
  class Client

    # Announcements
    def get_announcements(params = nil)
      get("/#{workroom_check(params)}announcements.json", params)
    end

    def create_announcement(attributes, params = nil)
      post("/#{workroom_check(params)}announcements.json", attributes)
    end

    def update_announcement(announcement_id, attributes, params = nil)
      put("/#{workroom_check(params)}announcements/#{announcement_id}.json", attributes)
    end

    def get_announcement(announcement_id, params = nil)
      get("/#{workroom_check(params)}announcements/#{announcement_id}.json")
    end

    def delete_announcement(announcement_id, params = nil)
      delete("/#{workroom_check(params)}announcements/#{announcement_id}.json")
    end

    # Events
    def get_events(params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      get("/events.json", params)
    end

    def create_event(attributes, params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      post("/workrooms/#{params[:workroom_id]}/events.json", attributes)
    end

    def update_event(id, attributes, params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      raise Error, "Event ID is required" unless id.is_a? Numeric
      put("/workrooms/#{params[:workroom_id]}/events/#{id}.json", attributes)
    end

    def get_event(id, params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      raise Error, "Event ID is required" unless id.is_a? Numeric
      get("/workrooms/#{params[:workroom_id]}/events/#{id}.json")
    end

    def delete_event(id, params = nil)
      raise Error, "Event ID is required" unless id.is_a? Numeric
      delete("/workrooms/#{params[:workroom_id]}/events/#{id}.json")
    end

    # RSVPS
    def get_rsvps(params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      raise Error, "Event ID is required" unless params[:event_id].is_a? Numeric
      get("/workrooms/#{params[:workroom_id]}/events/#{params[:event_id]}/rsvps.json")
    end

    def create_rsvp(attributes, params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      raise Error, "Event ID is required" unless params[:event_id].is_a? Numeric
      post("/workrooms/#{params[:workroom_id]}/events/#{params[:event_id]}/rsvps.json", attributes)
    end

    def get_rsvp(rsvp_id, params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      raise Error, "Event ID is required" unless params[:event_id].is_a? Numeric
      raise Error, "RSVP ID is required" unless rsvp_id.is_a? Numeric
      get("/workrooms/#{params[:workroom_id]}/events/#{params[:event_id]}/rsvps/#{rsvp_id}.json")
    end

    def add_invitee(rsvp_id, attributes, params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      raise Error, "Event ID is required" unless params[:event_id].is_a? Numeric
      raise Error, "RSVP ID is required" unless rsvp_id.is_a? Numeric
      post("/workrooms/#{params[:workroom_id]}/events/#{params[:event_id]}/rsvps/#{rsvp_id}/add_invitee.json", attributes)
    end

    def remove_invitee(rsvp_id, attributes, params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      raise Error, "Event ID is required" unless params[:event_id].is_a? Numeric
      raise Error, "RSVP ID is required" unless rsvp_id.is_a? Numeric
      post("/workrooms/#{params[:workroom_id]}/events/#{params[:event_id]}/rsvps/#{rsvp_id}/remove_invitee.json", attributes)
    end

    # Books
    def get_books(params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      get("/books.json", params)
    end

    def get_paginated_books(params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      get("/books/paginated.json", params)
    end

    def get_book(book_id, params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      raise Error, "Book ID is required" unless book_id.is_a? Numeric
      get("/workrooms/#{params[:workroom_id]}/books/#{book_id}.json")
    end

    # Clients
    def get_client(client_id)
      raise Error, "Client ID is required" unless client_id.is_a? Numeric
      get("/clients/#{client_id}.json")
    end

    # Custom Fields
    def get_custom_fields(params = nil)
      get("/custom_fields.json")
    end

    # Discussions
    def get_discussions(params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      get("/workrooms/#{params[:workroom_id]}/discussions.json")
    end

    def get_discussion(discussion_id, params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      get("/workrooms/#{params[:workroom_id]}/discussions/#{discussion_id}.json")
    end

    # Discussion Posts
    def get_discussion_post(discussion_id, post_id, params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      raise Error, "Discussion ID is required" unless discussion_id.is_a? Numeric
      raise Error, "Discussion Post ID is required" unless post_id.is_a? Numeric
      get("/workrooms/#{params[:workroom_id]}/discussions/#{discussion_id}/discussion_posts/#{post_id}.json")
    end

    # Event Categories
    def get_event_categories(params = nil)
      get("/eventcolors.json", params)
    end

    def create_event_category(attributes, params = nil)
      post("/eventcolors.json", attributes)
    end

    def update_event_category(id, attributes, params = nil)
      raise Error, "Eventcolor ID is required" unless id.is_a? Numeric
      put("/eventcolors/#{id}.json", attributes)
    end

    def get_event_category(id, params = nil)
      raise Error, "Eventcolor ID is required" unless id.is_a? Numeric
      get("/eventcolors/#{id}.json")
    end

    def delete_event_category(id, params = nil)
      raise Error, "Eventcolor ID is required" unless id.is_a? Numeric
      delete("/eventcolors/#{id}.json")
    end

    # Surveys
    def get_surveys(params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      get("/workrooms/#{params[:workroom_id]}/surveys.json")
    end

    # Userclasses
    def get_userclasses(params = nil)
      get("/userclasses.json", params)
    end

    def create_userclass(attributes, params = nil)
      post("/userclasses.json", attributes)
    end

    def update_userclass(userclass_id, attributes, params = nil)
      raise Error, "Userclass ID is required" unless userclass_id.is_a? Numeric
      put("/userclasses/#{userclass_id}.json", attributes)
    end

    def get_userclass(userclass_id, params = nil)
      raise Error, "Userclass ID is required" unless userclass_id.is_a? Numeric
      get("/userclasses/#{userclass_id}.json")
    end

    def delete_userclass(userclass_id, params = nil)
      raise Error, "Userclass ID is required" unless userclass_id.is_a? Numeric
      delete("/userclasses/#{userclass_id}.json")
    end

    # Users
    def get_users
      get("/users.json")
    end

    def get_user(id)
      raise Error, "User ID is required" unless id.is_a? Numeric
      get("/users/#{id}.json")
    end

    # Workgroups
    def get_workgroups
      get("/committeegroups.json")
    end

    def get_workgroup(id)
      raise Error, "Workgroup ID is required" unless id.is_a? Numeric
      get("/committeegroups/#{id}.json")
    end

    # Workrooms
    def get_workrooms(params = nil)
      get("/workrooms.json")
    end

    def create_workroom(attributes, params = nil)
      post("/workrooms.json", attributes)
    end

    def update_workroom(id, attributes, params = nil)
      raise Error, "Workroom ID is required" unless id.is_a? Numeric
      put("/workrooms/#{id}.json", attributes)
    end

    def get_workroom(id, params = nil)
      raise Error, "Workroom ID is required" unless id.is_a? Numeric
      get("/workrooms/#{id}.json")
    end

    def delete_workroom(id, params = nil)
      raise Error, "Workroom ID is required" unless id.is_a? Numeric
      delete("/workrooms/#{id}.json")
    end

    private

    def workroom_check(params = nil)
      if !params.nil? && params.key?('workroom_id')
        raise Error, "Workroom ID Can not be 0" if params[:workroom_id].to_i == 0
        "workrooms/#{params[:workroom_id].to_i}/"
      end
    end
  end
end