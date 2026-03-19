# frozen_string_literal: true

module Frame
  class SubscriptionPhase < APIResource
    extend Frame::APIOperations::Create
    extend Frame::APIOperations::List
    include Frame::APIOperations::Delete
    include Frame::APIOperations::Save

    OBJECT_NAME = "subscription_phase"

    def self.object_name
      OBJECT_NAME
    end

    def self.create(subscription_id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/subscriptions/#{CGI.escape(subscription_id)}/phases",
        params,
        opts
      )
    end

    def self.list(subscription_id, params = {}, opts = {})
      request_object(
        :get,
        "/v1/subscriptions/#{CGI.escape(subscription_id)}/phases",
        params,
        opts
      )
    end

    def self.retrieve(subscription_id, id, opts = {})
      request_object(
        :get,
        "/v1/subscriptions/#{CGI.escape(subscription_id)}/phases/#{CGI.escape(id)}",
        {},
        opts
      )
    end

    def self.delete(subscription_id, id, params = {}, opts = {})
      request_object(
        :delete,
        "/v1/subscriptions/#{CGI.escape(subscription_id)}/phases/#{CGI.escape(id)}",
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
        "/v1/subscriptions/#{CGI.escape(self["subscription"])}/phases/#{CGI.escape(self["id"])}",
        values,
        opts
      )

      initialize_from(updated)
      self
    end

    def delete(params = {}, opts = {})
      request_object(
        :delete,
        "/v1/subscriptions/#{CGI.escape(self["subscription"])}/phases/#{CGI.escape(self["id"])}",
        params,
        opts
      )
    end
  end
end
