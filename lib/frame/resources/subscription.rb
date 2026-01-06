# frozen_string_literal: true

module Frame
  class Subscription < APIResource
    extend Frame::APIOperations::Create
    extend Frame::APIOperations::List
    include Frame::APIOperations::Delete
    include Frame::APIOperations::Save

    OBJECT_NAME = "subscription"

    def self.object_name
      OBJECT_NAME
    end

    def self.create(params = {}, opts = {})
      request_object(
        :post,
        "/v1/subscriptions",
        params,
        opts
      )
    end

    def self.list(params = {}, opts = {})
      request_object(
        :get,
        "/v1/subscriptions",
        params,
        opts
      )
    end

    def self.retrieve(id, opts = {})
      id = Util.normalize_id(id)
      request_object(
        :get,
        "/v1/subscriptions/#{CGI.escape(id)}",
        {},
        opts
      )
    end

    def self.delete(id, params = {}, opts = {})
      request_object(
        :delete,
        "/v1/subscriptions/#{CGI.escape(id)}",
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
        "/v1/subscriptions/#{CGI.escape(self["id"])}",
        values,
        opts
      )

      initialize_from(updated)
      self
    end

    def delete(params = {}, opts = {})
      request_object(
        :delete,
        "/v1/subscriptions/#{CGI.escape(self["id"])}",
        params,
        opts
      )
    end

    def cancel(params = {}, opts = {})
      request_object(
        :post,
        "/v1/subscriptions/#{CGI.escape(self["id"])}/cancel",
        params,
        opts
      )
    end

    def self.cancel(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/subscriptions/#{CGI.escape(id)}/cancel",
        params,
        opts
      )
    end

    def resume(params = {}, opts = {})
      request_object(
        :post,
        "/v1/subscriptions/#{CGI.escape(self["id"])}/resume",
        params,
        opts
      )
    end

    def self.resume(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/subscriptions/#{CGI.escape(id)}/resume",
        params,
        opts
      )
    end

    def pause(params = {}, opts = {})
      request_object(
        :post,
        "/v1/subscriptions/#{CGI.escape(self["id"])}/pause",
        params,
        opts
      )
    end

    def self.pause(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/subscriptions/#{CGI.escape(id)}/pause",
        params,
        opts
      )
    end
  end
end
