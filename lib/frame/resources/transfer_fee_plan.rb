# frozen_string_literal: true

module Frame
  class TransferFeePlan < APIResource
    OBJECT_NAME = "transfer_fee_plan"

    def self.object_name; OBJECT_NAME; end

    def self.create(params = {}, opts = {})
      request_object(:post, "/v1/transfer_fee_plans", params, opts)
    end

    def self.list(params = {}, opts = {})
      request_object(:get, "/v1/transfer_fee_plans", params, opts)
    end

    def self.retrieve(id, opts = {})
      request_object(:get, "/v1/transfer_fee_plans/#{CGI.escape(id)}", {}, opts)
    end
  end
end
