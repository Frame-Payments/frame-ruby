# frozen_string_literal: true

module Frame
  class Payout < APIResource
    OBJECT_NAME = "payout"

    def self.object_name; OBJECT_NAME; end

    def self.create(params = {}, opts = {})
      request_object(:post, "/v1/payouts", params, opts)
    end
  end
end
