require 'boardeffect/errors'
require 'boardeffect/record'
require 'net/http'
require 'cgi'
require 'json'

module BoardEffect
  class Client
    def initialize(options = {})
      if options.key?(:access_token)
        @auth_header, @auth_value = 'Authorization', "Bearer #{options[:access_token]}"
      else
        @auth_header, @auth_value = 'X-BoardEffectToken', options.fetch(:token)
      end

      @user_agent = options.fetch(:user_agent, 'Ruby BoardEffect::Client')

      @host = (options.key?(:host)) ? options[:host] : 'boardeffect.local'

      @http = Net::HTTP.new(@host)

      @http.use_ssl = (options.key?(:host)) ? true : false
    end

    def get(path, params = nil)
      request(Net::HTTP::Get.new(request_uri(path, params)))
    end

    private

    def post(path, attributes)
      request(Net::HTTP::Post.new(path), attributes)
    end

    def put(path, attributes = nil)
      request(Net::HTTP::Put.new(path), attributes)
    end

    def delete(path)
      request(Net::HTTP::Delete.new(path))
    end

    def request(http_request, body_object = nil)
      http_request['User-Agent'] = @user_agent
      http_request[@auth_header] = @auth_value

      if body_object
        http_request['Content-Type'] = 'application/json'
        http_request.body = JSON.generate(body_object)
      end

      parse(@http.request(http_request))
    end

    def parse(http_response)
      case http_response
      when Net::HTTPNoContent
        :no_content
      when Net::HTTPSuccess
        if http_response['Content-Type'] && http_response['Content-Type'].split(';').first == 'application/json'
          JSON.parse(http_response.body, symbolize_names: true, object_class: Record).tap do |object|
            if http_response['Link'] && next_page = http_response['Link'][/<([^>]+)>; rel="next"/, 1]
              object.singleton_class.module_eval { attr_accessor :next_page }
              object.next_page = URI.parse(next_page).request_uri
            end
          end
        else
          http_response.body
        end
      when Net::HTTPBadRequest
        object = JSON.parse(http_response.body, symbolize_names: true)

        raise Error, "boardeffect api error: #{object.fetch(:message)}"
      when Net::HTTPUnauthorized
        raise AuthenticationError
      else
        raise Error, "boardeffect api error: unexpected #{http_response.code} response from #{@host}"
      end
    end

    def request_uri(path, params = nil)
      return path if params.nil? || params.empty?

      path + '?' + params.map { |k, v| "#{escape(k)}=#{array_escape(v)}" }.join('&')
    end

    def array_escape(object)
      Array(object).map { |value| escape(value) }.join(',')
    end

    def escape(component)
      CGI.escape(component.to_s)
    end
  end
end