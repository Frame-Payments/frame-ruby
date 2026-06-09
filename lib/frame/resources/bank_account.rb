# frozen_string_literal: true

module Frame
  class BankAccount < APIResource
    extend Frame::APIOperations::Create

    OBJECT_NAME = "bank_account"

    def self.object_name
      OBJECT_NAME
    end

    def self.create(params = {}, opts = {})
      request_object(:post, "/v1/bank_accounts", params, opts)
    end
  end
end
