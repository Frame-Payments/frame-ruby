# frozen_string_literal: true

require "securerandom"

module Frame
  class Wallet < APIResource
    OBJECT_NAME = "wallet"

    def self.object_name
      OBJECT_NAME
    end

    def self.resource_url
      "/v2/wallets"
    end

    def self.list(params = {}, opts = {})
      request_object(:get, "/v2/wallets", params, opts)
    end

    def self.retrieve(id, opts = {})
      id = Util.normalize_id(id)
      request_object(:get, "/v2/wallets/#{CGI.escape(id)}", {}, opts)
    end

    def self.retrieve_default(params = {}, opts = {})
      request_object(:get, "/v2/wallets/default", params, opts)
    end

    def self.update(id, params = {}, opts = {})
      id = Util.normalize_id(id)
      opts = with_idempotency_key(opts)
      request_object(:patch, "/v2/wallets/#{CGI.escape(id)}", params, opts)
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
  end
end
