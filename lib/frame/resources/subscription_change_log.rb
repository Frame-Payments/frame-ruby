# frozen_string_literal: true

module Frame
  class SubscriptionChangeLog < APIResource
    OBJECT_NAME = "subscription_change_log"

    def self.object_name; OBJECT_NAME; end

    def self.list(subscription_id, params = {}, opts = {})
      request_object(:get, "/v1/subscriptions/#{CGI.escape(subscription_id)}/change_logs", params, opts)
    end
  end
end
