# frozen_string_literal: true

require "securerandom"

module Frame
  # Additive V2 Transfers resource (`/v2/transfers`). V1 remains on {Transfer}.
  #
  # The API still returns `object: "transfer"`, so responses are constructed as
  # TransferV2 explicitly rather than remapping the shared object name in Util
  # (which would break V1).
  class TransferV2 < APIResource
    OBJECT_NAME = "transfer_v2"

    def self.object_name
      OBJECT_NAME
    end

    def self.create(params = {}, opts = {})
      opts = with_idempotency_key(opts)
      resp = request(:post, "/v2/transfers", params, opts)
      construct_from(resp, opts)
    end

    def self.list(params = {}, opts = {})
      resp = request(:get, "/v2/transfers", params, opts)
      data = Array(resp[:data]).map { |item| construct_from(item, opts) }
      ListObject.construct_from(resp.merge(data: data), opts.merge(resource_url: "/v2/transfers"))
    end

    def self.retrieve(id, opts = {})
      id = Util.normalize_id(id)
      resp = request(:get, "/v2/transfers/#{CGI.escape(id)}", {}, opts)
      construct_from(resp, opts)
    end

    def self.update(id, params = {}, opts = {})
      id = Util.normalize_id(id)
      resp = request(:patch, "/v2/transfers/#{CGI.escape(id)}", params, opts)
      construct_from(resp, opts)
    end

    def self.confirm(id, params = {}, opts = {})
      id = Util.normalize_id(id)
      opts = with_idempotency_key(opts) unless client_secret_param?(params)
      resp = request(:post, "/v2/transfers/#{CGI.escape(id)}/confirm", params, opts)
      construct_from(resp, opts)
    end

    def confirm(params = {}, opts = {})
      opts = self.class.send(:with_idempotency_key, opts) unless self.class.send(:client_secret_param?, params)
      resp = request(:post, "/v2/transfers/#{CGI.escape(self["id"])}/confirm", params, opts)
      self.class.construct_from(resp, opts)
    end

    def self.capture(id, params = {}, opts = {})
      id = Util.normalize_id(id)
      opts = with_idempotency_key(opts)
      resp = request(:post, "/v2/transfers/#{CGI.escape(id)}/capture", params, opts)
      construct_from(resp, opts)
    end

    def capture(params = {}, opts = {})
      opts = self.class.send(:with_idempotency_key, opts)
      resp = request(:post, "/v2/transfers/#{CGI.escape(self["id"])}/capture", params, opts)
      self.class.construct_from(resp, opts)
    end

    def self.void(id, params = {}, opts = {})
      id = Util.normalize_id(id)
      opts = with_idempotency_key(opts)
      resp = request(:post, "/v2/transfers/#{CGI.escape(id)}/void", params, opts)
      construct_from(resp, opts)
    end

    def void(params = {}, opts = {})
      opts = self.class.send(:with_idempotency_key, opts)
      resp = request(:post, "/v2/transfers/#{CGI.escape(self["id"])}/void", params, opts)
      self.class.construct_from(resp, opts)
    end

    def self.refund(id, params = {}, opts = {})
      id = Util.normalize_id(id)
      opts = with_idempotency_key(opts)
      resp = request(:post, "/v2/transfers/#{CGI.escape(id)}/refund", params, opts)
      construct_from(resp, opts)
    end

    def refund(params = {}, opts = {})
      opts = self.class.send(:with_idempotency_key, opts)
      resp = request(:post, "/v2/transfers/#{CGI.escape(self["id"])}/refund", params, opts)
      self.class.construct_from(resp, opts)
    end

    def self.with_idempotency_key(opts)
      opts = Util.normalize_opts(opts)
      key = opts.delete(:idempotency_key)
      key = SecureRandom.uuid if key.nil? || key.to_s.empty?
      headers = (opts[:headers] || {}).dup
      headers["Idempotency-Key"] = key.to_s
      opts.merge(headers: headers)
    end
    private_class_method :with_idempotency_key

    def self.client_secret_param?(params)
      params.is_a?(Hash) && (params[:client_secret] || params["client_secret"])
    end
    private_class_method :client_secret_param?
  end
end
