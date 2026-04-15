# frozen_string_literal: true

module Frame
  class WebhookEndpoint < APIResource
    extend Frame::APIOperations::List

    OBJECT_NAME = "webhook_endpoint"

    def self.object_name
      OBJECT_NAME
    end

    def self.list(params = {}, opts = {})
      request_object(
        :get,
        "/v1/webhook_endpoints",
        params,
        opts
      )
    end
  end
end
