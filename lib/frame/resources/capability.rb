# frozen_string_literal: true

module Frame
  class Capability < APIResource
    OBJECT_NAME = "capability"

    def self.object_name
      OBJECT_NAME
    end

    def self.list(account_id, params = {}, opts = {})
      request_object(:get, "/v1/accounts/#{CGI.escape(account_id)}/capabilities", params, opts)
    end

    def self.request(account_id, params = {}, opts = {})
      request_object(:post, "/v1/accounts/#{CGI.escape(account_id)}/capabilities", params, opts)
    end

    def self.retrieve(account_id, name, opts = {})
      request_object(:get, "/v1/accounts/#{CGI.escape(account_id)}/capabilities/#{CGI.escape(name)}", {}, opts)
    end

    def self.disable(account_id, name, params = {}, opts = {})
      request_object(:delete, "/v1/accounts/#{CGI.escape(account_id)}/capabilities/#{CGI.escape(name)}", params, opts)
    end
  end
end
