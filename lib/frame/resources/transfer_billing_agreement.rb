# frozen_string_literal: true

module Frame
  class TransferBillingAgreement < APIResource
    include Frame::APIOperations::Save

    OBJECT_NAME = "transfer_billing_agreement"

    def self.object_name; OBJECT_NAME; end

    def self.create(params = {}, opts = {})
      request_object(:post, "/v1/transfer_billing_agreements", params, opts)
    end

    def self.list(params = {}, opts = {})
      request_object(:get, "/v1/transfer_billing_agreements", params, opts)
    end

    def self.retrieve(id, opts = {})
      request_object(:get, "/v1/transfer_billing_agreements/#{CGI.escape(id)}", {}, opts)
    end

    def self.update(id, params = {}, opts = {})
      request_object(:patch, "/v1/transfer_billing_agreements/#{CGI.escape(id)}", params, opts)
    end

    def save(params = {}, opts = {})
      values = serialize_params(self).merge(params)
      return self if values.empty?
      updated = request_object(:patch, "/v1/transfer_billing_agreements/#{CGI.escape(self["id"])}", values, opts)
      initialize_from(updated)
      self
    end
  end
end
