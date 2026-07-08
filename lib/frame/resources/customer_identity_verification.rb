# frozen_string_literal: true

module Frame
  class CustomerIdentityVerification < APIResource
    extend Frame::APIOperations::Create
    extend Frame::APIOperations::List

    OBJECT_NAME = "customer_identity_verification"

    def self.object_name
      OBJECT_NAME
    end

    # Methods deprecated for removal at v2. `list` has no backing route (the
    # monolith exposes customer_identity_verifications only as [:create, :show];
    # there is no index action / public list endpoint), so it is a no-op that
    # 404s — kept only so existing callers don't NoMethodError before v2.
    DEPRECATED_METHODS = %i[list].freeze

    def self.create(params = {}, opts = {})
      request_object(
        :post,
        "/v1/customer_identity_verifications",
        params,
        opts
      )
    end

    # Create an identity verification for an existing customer.
    # POST /v1/customer_identity_verifications/{customer_id}
    # (monolith customer_identity_verifications#create_from_customer).
    # The documented route takes only the customer_id path param — no request
    # body — so no params argument is exposed.
    def self.create_for_customer(customer_id, opts = {})
      customer_id = Util.normalize_id(customer_id)
      request_object(
        :post,
        "/v1/customer_identity_verifications/#{CGI.escape(customer_id)}",
        {},
        opts
      )
    end

    # @deprecated No public list endpoint exists for this resource; this 404s.
    #   Removed at v2. See DEPRECATED_METHODS.
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

    def upload_documents(params = {}, opts = {})
      request_object(
        :post,
        "/v1/customer_identity_verifications/#{CGI.escape(self["id"])}/upload_documents",
        params,
        opts
      )
    end

    def self.upload_documents(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/customer_identity_verifications/#{CGI.escape(id)}/upload_documents",
        params,
        opts
      )
    end
  end
end
