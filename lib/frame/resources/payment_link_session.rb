# frozen_string_literal: true

module Frame
  class PaymentLinkSession < APIResource
    OBJECT_NAME = "payment_link_session"

    def self.object_name; OBJECT_NAME; end

    def self.create(params = {}, opts = {})
      request_object(:post, "/v1/payment_link_sessions", params, opts)
    end
  end
end
