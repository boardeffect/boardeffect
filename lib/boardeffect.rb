require 'boardeffect/client'

module BoardEffect
  class Client

    # Announcements
    def get_announcements(params = nil)
      get("/services/v2/#{workroom_check(params)}announcements", params)
    end

    def create_announcement(attributes, params = nil)
      post("/services/v2/#{workroom_check(params)}announcements", attributes)
    end

    def update_announcement(announcement_id, attributes, params = nil)
      put("/services/v2/#{workroom_check(params)}announcements/#{announcement_id}", attributes)
    end

    def get_announcement(announcement_id, params = nil)
      get("/services/v2/#{workroom_check(params)}announcements/#{announcement_id}")
    end

    def delete_announcement(announcement_id, params = nil)
      delete("/services/v2/#{workroom_check(params)}announcements/#{announcement_id}")
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