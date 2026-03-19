# frozen_string_literal: true

module Frame
  class PhoneVerification < APIResource
    OBJECT_NAME = "phone_verification"

    def self.object_name
      OBJECT_NAME
    end

    def self.create(account_id, params = {}, opts = {})
      request_object(:post, "/v1/accounts/#{CGI.escape(account_id)}/phone_verifications", params, opts)
    end

    def self.confirm(account_id, id, params = {}, opts = {})
      request_object(:post, "/v1/accounts/#{CGI.escape(account_id)}/phone_verifications/#{CGI.escape(id)}/confirm", params, opts)
    end
  end
end
