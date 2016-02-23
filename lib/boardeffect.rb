require 'boardeffect/client'
require 'boardeffect/version'

module BoardEffect
  class Client

    # Announcements
    def get_announcements(params = nil)
      get("/services/v2/#{workroom_check(params)}announcements.json", params)
    end

    def create_announcement(attributes, params = nil)
      post("/services/v2/#{workroom_check(params)}announcements.json", attributes)
    end

    def update_announcement(announcement_id, attributes, params = nil)
      put("/services/v2/#{workroom_check(params)}announcements/#{announcement_id}.json", attributes)
    end

    def get_announcement(announcement_id, params = nil)
      get("/services/v2/#{workroom_check(params)}announcements/#{announcement_id}.json")
    end

    def delete_announcement(announcement_id, params = nil)
      delete("/services/v2/#{workroom_check(params)}announcements/#{announcement_id}.json")
    end

    # Events
    def get_events(params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      get("/services/v2/events.json", params)
    end

    def create_event(attributes, params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      post("/services/v2/workrooms/#{params[:workroom_id].to_i}/events.json", attributes)
    end

    def update_event(event_id, attributes, params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      put("/services/v2/workrooms/#{params[:workroom_id].to_i}/events/#{event_id}.json", attributes)
    end

    def get_event(event_id, params = nil)
      raise Error, "Workroom ID is required" unless params[:workroom_id].is_a? Numeric
      get("/services/v2/workrooms/#{params[:workroom_id].to_i}/events/#{event_id}.json")
    end

    def delete_event(event_id, params = nil)
      delete("/services/v2/workrooms/#{params[:workroom_id].to_i}/events/#{event_id}.json")
    end

    # RSVPS

    # Books

    # Userclasses

    # Users

    # Workrooms



    private

    def workroom_check(params = nil)
      if !params.nil? && params.key?('workroom_id')
        raise Error, "Workroom ID Can not be 0" if params[:workroom_id].to_i == 0
        "workrooms/#{params[:workroom_id].to_i}/"
      end
    end
  end
end