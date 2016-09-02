require 'boardeffect/errors'
require 'boardeffect/record'
require 'net/http'
require 'cgi'
require 'json'

module BoardEffect

  class Client

    API_VERSION = 3
    API_PATH    = '/api/v3'

    def initialize(options = {})
      setup_client(options)
      if !options.key?(:test)
        auth = auth("#{API_PATH}/auth/api_key.json", { api_key: options[:access_token]})
        if auth[:success] == true
          @auth_header, @auth_value = 'Authorization', "Bearer #{auth[:data][:token]}"
        else
          raise Error, auth[:error][:message]
        end
      else
         @auth_header, @auth_value = 'Authorization', "Bearer #{options[:access_token]}"
      end
    end

    def auth(path, attributes)
      http_request = Net::HTTP::Post.new(path)
      http_request['Content-Type'] = 'application/json'
      http_request.body = JSON.generate(attributes)
      parse(@http.request(http_request))
    end

    def get(path, params = nil)
      request(Net::HTTP::Get.new(request_uri(path, params)))
    end

    private

    def setup_client(options = {})
      @user_agent = options.fetch(:user_agent, 'Ruby BoardEffect::Client')

      @host = (options.key?(:host)) ? options[:host] : 'boardeffect.local'

      @http = Net::HTTP.new(URI.parse(@host).host, Net::HTTP.https_default_port())
      @http.use_ssl = true
    end

    def post(path, attributes)
      request(Net::HTTP::Post.new(request_uri(path)), attributes)
    end

    def put(path, attributes = nil)
      request(Net::HTTP::Put.new(request_uri(path)), attributes)
    end

    def delete(path)
      request(Net::HTTP::Delete.new(request_uri(path)))
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

        raise Error, "boardeffect api error: #{object[:error][:message]}"
      when Net::HTTPUnauthorized
        raise AuthenticationError, "boardeffect api error: unexpected #{http_response.code} response from #{@host}"
      else
        raise Error, "boardeffect api error: unexpected #{http_response.code} response from #{@host}"
      end
    end

    def request_uri(path, params = nil)
      path = API_PATH + path unless path.include? API_PATH
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