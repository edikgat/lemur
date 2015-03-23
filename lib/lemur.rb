require "lemur/version"

require 'digest/md5'
require 'multi_json'

module Lemur
  ODNOKLASSNIKI_API_URL = 'http://api.odnoklassniki.ru/fb.do'
  ODNOKLASSNIKI_NEW_TOKEN_URL = 'http://api.odnoklassniki.ru/oauth/token.do'

  class API
    attr_reader :security_options, :request_options, :response, :connection
    attr_accessor :verbose_output

    def initialize(opts)
      check_required_options(opts)
      @verbose_output = opts[:verbose_response]
      @security_options = {
        application_secret_key: opts[:application_secret_key],
        application_key:        opts[:application_key],
        access_token:           opts[:access_token],
        application_id:         opts[:application_id],
        refresh_token:          opts[:refresh_token]
      }
    end

    def get_new_token
      if @security_options[:application_id].blank? || @security_options[:refresh_token].blank?
        raise ArgumentError, 'wrong number of arguments'
      end
      conn = connection_for_endpoint(Lemur::ODNOKLASSNIKI_NEW_TOKEN_URL)
      new_token_response = conn.post do |req|
        req.params = {
          client_id:     @security_options[:application_id],
          client_secret: @security_options[:application_secret_key],
          refresh_token: @security_options[:refresh_token],
          grant_type:    'refresh_token'
        }
      end
      new_token_response = MultiJson.load(new_token_response.body)
      @security_options[:access_token] = new_token_response['access_token']
      new_token_response['access_token']
    end

    def get(request_params)
      @response = get_request(request_params)
      json_data = \
        begin
          MultiJson.load(response.body)
        rescue MultiJson::DecodeError
          # Sometimes invalid json can be returned by Odnoklassniki
          fixed_response = \
            response.body.gsub(/[^"]}/, '"}').gsub(/([^"}]),"([^}])/, '\1","\2')
          MultiJson.load(fixed_response)
        end
      if json_data.is_a?(Hash) && json_data['error_code']
        raise ApiError, json_data
      end

      json_data
    rescue MultiJson::DecodeError
      raise ApiParsingError, @response
    end

    private

    def final_request_params(request_params, access_token)
      signature = ok_signature(
        request_params,
        access_token,
        security_options[:application_secret_key]
      )

      request_options = {
        sig:             signature,
        access_token:    security_options[:access_token],
        application_key: security_options[:application_key]
      }

      request_params.merge(request_options)
    end

    def ok_signature(request_params, access_token)
      sorted_params_string = ""
      key = security_options[:application_secret_key]
      request_params = Hash[request_params.sort]

      request_params.each {|key, value| sorted_params_string += "#{key}=#{value}"}
      secret_part = Digest::MD5.hexdigest("#{access_token}#{key}")
      Digest::MD5.hexdigest("#{sorted_params_string}#{secret_part}")
    end

    def start_faraday
      @connection = init_faraday(faraday_options)
    end

    def connection_for_endpoint(url)
      @connection ||= {}
      @connection[url] ||= begin
        faraday_options = {
          request: {:timeout=>150, :open_timeout=>150},
          url: url
        }

        Faraday.new(faraday_options) do |faraday|
          faraday.headers['Content-Type'] = 'application/json'
          faraday.request  :url_encoded
          faraday.response(:logger) if verbose_output
          faraday.adapter  Faraday.default_adapter
        end
      end
    end

    def get_request(request_params)
      @request_options = request_params
      @response = @connection.get do |request|
        request.params = final_request_params(@request_options.merge(application_key: security_options[:application_key]),
        security_options[:access_token])
      end
    end

    def check_required_options(opts)
      required_options = [:application_secret_key, :application_key, :access_token]
      unless required_options.all? { |it| opts.has_key? it }
        raise "You should provide all needed options (#{required_options}) to connect odnoklassniki"
      end
    end

  end
end
