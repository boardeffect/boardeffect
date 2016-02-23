require 'boardeffect/client'

module BoardEffect
  class Client
    def get_announcements(params = nil)
      get('/v2/announcements', params)
    end
  end
end