# frozen_string_literal: true

module Frame
  # HTTP client for making requests to the Frame Payments API.
  #
  # Handles connection management, request execution, and response processing.
  # Automatically handles authentication, error parsing, and response formatting.
  class FrameClient
    attr_accessor :conn, :config

    @default_client_mutex = Mutex.new

    def self.active_client
      Thread.current[:frame_client] || default_client
    end

    def self.default_client
      return @default_client if @default_client

      @default_client_mutex.synchronize do
        @default_client ||= FrameClient.new(
          api_key: Frame.api_key,
          api_base: Frame.api_base,
          open_timeout: Frame.open_timeout,
          read_timeout: Frame.read_timeout,
          verify_ssl_certs: Frame.verify_ssl_certs,
          logger: Frame.logger,
          log_level: Frame.log_level
        )
      end
    end

    def initialize(api_key: nil, api_base: nil, open_timeout: nil, read_timeout: nil, verify_ssl_certs: nil, logger: nil, log_level: nil)
      @config = {
        api_key: api_key || Frame.api_key,
        api_base: api_base || Frame.api_base,
        open_timeout: open_timeout || Frame.open_timeout,
        read_timeout: read_timeout || Frame.read_timeout,
        verify_ssl_certs: verify_ssl_certs.nil? ? Frame.verify_ssl_certs : verify_ssl_certs,
        logger: logger || Frame.logger,
        log_level: log_level || Frame.log_level
      }

      @conn = create_connection
    end

    def request(method, path, params = {}, opts = {})
      response = execute_request(method, path, params, opts)
      process_response(response)
    rescue Faraday::ConnectionFailed => e
      raise APIConnectionError.new("Connection failed: #{e.message}")
    rescue Faraday::TimeoutError => e
      raise APIConnectionError.new("Request timed out: #{e.message}")
    rescue Faraday::ClientError => e
      raise APIConnectionError.new("Client error: #{e.message}")
    end

    private

    def create_connection
      Faraday.new(url: @config[:api_base]) do |faraday|
        faraday.request :json
        faraday.response :json, content_type: /\bjson$/
        faraday.adapter Faraday.default_adapter

        # SSL verification setting
        faraday.ssl.verify = @config[:verify_ssl_certs]

        faraday.options.timeout = @config[:read_timeout]
        faraday.options.open_timeout = @config[:open_timeout]
      end
    end

    def execute_request(method, path, params, opts)
      unless @config[:api_key]
        raise AuthenticationError.new(
          "API key is required. Set Frame.api_key before making requests.",
          http_status: nil
        )
      end

      headers = {
        "Authorization" => "Bearer #{@config[:api_key]}",
        "Content-Type" => "application/json",
        "User-Agent" => "FrameRuby/#{Frame::VERSION}"
      }

      log_request(method, path, params, headers) if should_log?

      response = case method.to_s.downcase.to_sym
      when :get
        @conn.get(path) do |req|
          req.params = params
          req.headers = headers
        end
      when :post
        @conn.post(path) do |req|
          req.body = params.to_json
          req.headers = headers
        end
      when :patch
        @conn.patch(path) do |req|
          req.body = params.to_json
          req.headers = headers
        end
      when :delete
        @conn.delete(path) do |req|
          req.params = params
          req.headers = headers
        end
      else
        raise APIConnectionError.new("Unrecognized HTTP method: #{method}")
      end

      log_response(response) if should_log?

      response
    end

    def process_response(response)
      case response.status
      when 200, 201, 202
        parsed_response = Util.symbolize_names(response.body)
      when 204
        parsed_response = {}
      when 400, 404
        error = Util.symbolize_names(response.body)
        raise InvalidRequestError.new(
          error[:error],
          http_status: response.status,
          http_body: response.body,
          json_body: error
        )
      when 401
        error = Util.symbolize_names(response.body)
        raise AuthenticationError.new(
          error[:error],
          http_status: response.status,
          http_body: response.body,
          json_body: error
        )
      when 429
        error = Util.symbolize_names(response.body)
        raise RateLimitError.new(
          error[:error],
          http_status: response.status,
          http_body: response.body,
          json_body: error
        )
      else
        error = Util.symbolize_names(response.body)
        raise APIError.new(
          error[:error] || "Unknown error",
          http_status: response.status,
          http_body: response.body,
          json_body: error
        )
      end

      parsed_response
    end

    def should_log?
      @config[:logger] && @config[:log_level]
    end

    def log_request(method, path, params, headers)
      return unless should_log?

      sanitized_headers = headers.dup
      sanitized_headers["Authorization"] = "Bearer [REDACTED]" if sanitized_headers["Authorization"]

      sanitized_params = sanitize_sensitive_data(params)

      @config[:logger].public_send(@config[:log_level], "[Frame] #{method.to_s.upcase} #{path}")
      @config[:logger].public_send(@config[:log_level], "[Frame] Headers: #{sanitized_headers.inspect}")
      @config[:logger].public_send(@config[:log_level], "[Frame] Params: #{sanitized_params.inspect}") unless sanitized_params.empty?
    end

    def log_response(response)
      return unless should_log?

      @config[:logger].public_send(@config[:log_level], "[Frame] Response: #{response.status} #{response.reason_phrase}")
      if response.body && response.body.is_a?(Hash)
        sanitized_body = sanitize_sensitive_data(response.body)
        @config[:logger].public_send(@config[:log_level], "[Frame] Body: #{sanitized_body.inspect}")
      end
    end

    def sanitize_sensitive_data(data)
      return data unless data.is_a?(Hash)

      sensitive_keys = %w[api_key secret key password card_number cvc cvv number]
      data.each_with_object({}) do |(key, value), sanitized|
        key_str = key.to_s.downcase
        sanitized[key] = if sensitive_keys.any? { |sensitive| key_str.include?(sensitive) }
          "[REDACTED]"
        elsif value.is_a?(Hash)
          sanitize_sensitive_data(value)
        elsif value.is_a?(Array)
          value.map { |v| v.is_a?(Hash) ? sanitize_sensitive_data(v) : v }
        else
          value
        end
      end
    end
  end
end
