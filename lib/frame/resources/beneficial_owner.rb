# frozen_string_literal: true

module Frame
  class BeneficialOwner < APIResource
    OBJECT_NAME = "beneficial_owner"

    def self.object_name
      OBJECT_NAME
    end

    def self.list(account_id, params = {}, opts = {})
      request_object(:get, "/v1/accounts/#{CGI.escape(account_id)}/beneficial_owners", params, opts)
    end

    def self.create(account_id, params = {}, opts = {})
      request_object(:post, "/v1/accounts/#{CGI.escape(account_id)}/beneficial_owners", params, opts)
    end

    def self.retrieve(account_id, id, opts = {})
      request_object(:get, "/v1/accounts/#{CGI.escape(account_id)}/beneficial_owners/#{CGI.escape(id)}", {}, opts)
    end

    def self.update(account_id, id, params = {}, opts = {})
      request_object(:patch, "/v1/accounts/#{CGI.escape(account_id)}/beneficial_owners/#{CGI.escape(id)}", params, opts)
    end

    def self.delete(account_id, id, params = {}, opts = {})
      request_object(:delete, "/v1/accounts/#{CGI.escape(account_id)}/beneficial_owners/#{CGI.escape(id)}", params, opts)
    end

    def self.confirm_roster(account_id, params = {}, opts = {})
      request_object(:post, "/v1/accounts/#{CGI.escape(account_id)}/beneficial_owners/confirm", params, opts)
    end

    def self.resend_invite(account_id, id, params = {}, opts = {})
      request_object(:post, "/v1/accounts/#{CGI.escape(account_id)}/beneficial_owners/#{CGI.escape(id)}/resend_invite", params, opts)
    end
  end
end
