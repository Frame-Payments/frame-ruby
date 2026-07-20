# frozen_string_literal: true

module Frame
  class Payout < APIResource
    OBJECT_NAME = "payout"

    def self.object_name
      OBJECT_NAME
    end

    # `retrieve` is inherited from APIResource but the payout vocabulary is
    # `create` only — the API exposes no `GET /v1/payouts/{id}` endpoint.
    # Flag it deprecated so it stays out of the parity denominator; removed at v2.
    DEPRECATED_METHODS = %i[retrieve].freeze

    def self.create(params = {}, opts = {})
      request_object(:post, "/v1/payouts", params, opts)
    end
  end
end
