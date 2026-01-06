# frozen_string_literal: true

module Frame
  class ChargeIntent < APIResource
    extend Frame::APIOperations::Create
    extend Frame::APIOperations::List
    include Frame::APIOperations::Save

    OBJECT_NAME = "charge_intent"

    def self.object_name
      OBJECT_NAME
    end

    def self.create(params = {}, opts = {})
      request_object(
        :post,
        "/v1/charge_intents",
        params,
        opts
      )
    end

    def self.list(params = {}, opts = {})
      request_object(
        :get,
        "/v1/charge_intents",
        params,
        opts
      )
    end

    def self.retrieve(id, opts = {})
      id = Util.normalize_id(id)
      request_object(
        :get,
        "/v1/charge_intents/#{CGI.escape(id)}",
        {},
        opts
      )
    end

    def authorize(params = {}, opts = {})
      request_object(
        :post,
        "/v1/charge_intents/#{CGI.escape(self["id"])}/authorize",
        params,
        opts
      )
    end

    def self.authorize(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/charge_intents/#{CGI.escape(id)}/authorize",
        params,
        opts
      )
    end

    def capture(params = {}, opts = {})
      request_object(
        :post,
        "/v1/charge_intents/#{CGI.escape(self["id"])}/capture",
        params,
        opts
      )
    end

    def self.capture(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/charge_intents/#{CGI.escape(id)}/capture",
        params,
        opts
      )
    end

    def cancel(params = {}, opts = {})
      request_object(
        :post,
        "/v1/charge_intents/#{CGI.escape(self["id"])}/cancel",
        params,
        opts
      )
    end

    def self.cancel(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/charge_intents/#{CGI.escape(id)}/cancel",
        params,
        opts
      )
    end

    def save(params = {}, opts = {})
      values = serialize_params(self).merge(params)

      if values.empty?
        return self
      end

      updated = request_object(
        :patch,
        "/v1/charge_intents/#{CGI.escape(self["id"])}",
        values,
        opts
      )

      initialize_from(updated)
      self
    end
  end
end
