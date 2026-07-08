# frozen_string_literal: true

module Frame
  # Top-level singleton: the authenticated merchant's balance (available funds,
  # reserved amounts, pending payouts). GET /v1/merchant_balance — no id.
  class MerchantBalance < APIResource
    OBJECT_NAME = "merchant_balance"

    def self.object_name
      OBJECT_NAME
    end

    def self.retrieve(opts = {})
      request_object(:get, "/v1/merchant_balance", {}, opts)
    end
  end
end
