# frozen_string_literal: true

module Frame
  class CustomerIdentityVerification < APIResource
    extend Frame::APIOperations::Create
    extend Frame::APIOperations::List

    OBJECT_NAME = "customer_identity_verification"

    def self.object_name
      OBJECT_NAME
    end

    def self.create(params = {}, opts = {})
      request_object(
        :post,
        "/v1/customer_identity_verifications",
        params,
        opts
      )
    end

    def self.list(params = {}, opts = {})
      request_object(
        :get,
        "/v1/customer_identity_verifications",
        params,
        opts
      )
    end

    def self.retrieve(id, opts = {})
      id = Util.normalize_id(id)
      request_object(
        :get,
        "/v1/customer_identity_verifications/#{CGI.escape(id)}",
        {},
        opts
      )
    end

    def verify(params = {}, opts = {})
      request_object(
        :post,
        "/v1/customer_identity_verifications/#{CGI.escape(self["id"])}/verify",
        params,
        opts
      )
    end

    def self.verify(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/customer_identity_verifications/#{CGI.escape(id)}/verify",
        params,
        opts
      )
    end
  end
end
