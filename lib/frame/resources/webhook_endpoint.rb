# frozen_string_literal: true

module Frame
  class WebhookEndpoint < APIResource
    extend Frame::APIOperations::Create
    extend Frame::APIOperations::List
    include Frame::APIOperations::Delete
    include Frame::APIOperations::Save

    OBJECT_NAME = "webhook_endpoint"

    def self.object_name
      OBJECT_NAME
    end

    def self.create(params = {}, opts = {})
      request_object(
        :post,
        "/v1/webhook_endpoints",
        params,
        opts
      )
    end

    def self.list(params = {}, opts = {})
      request_object(
        :get,
        "/v1/webhook_endpoints",
        params,
        opts
      )
    end

    def self.retrieve(id, opts = {})
      id = Util.normalize_id(id)
      request_object(
        :get,
        "/v1/webhook_endpoints/#{CGI.escape(id)}",
        {},
        opts
      )
    end

    def self.delete(id, params = {}, opts = {})
      request_object(
        :delete,
        "/v1/webhook_endpoints/#{CGI.escape(id)}",
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
        "/v1/webhook_endpoints/#{CGI.escape(self["id"])}",
        values,
        opts
      )

      initialize_from(updated)
      self
    end

    def delete(params = {}, opts = {})
      request_object(
        :delete,
        "/v1/webhook_endpoints/#{CGI.escape(self["id"])}",
        params,
        opts
      )
    end

    def enable(params = {}, opts = {})
      request_object(
        :post,
        "/v1/webhook_endpoints/#{CGI.escape(self["id"])}/enable",
        params,
        opts
      )
    end

    def self.enable(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/webhook_endpoints/#{CGI.escape(id)}/enable",
        params,
        opts
      )
    end

    def disable(params = {}, opts = {})
      request_object(
        :post,
        "/v1/webhook_endpoints/#{CGI.escape(self["id"])}/disable",
        params,
        opts
      )
    end

    def self.disable(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/webhook_endpoints/#{CGI.escape(id)}/disable",
        params,
        opts
      )
    end
  end
end
