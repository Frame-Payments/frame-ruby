# frozen_string_literal: true

module Frame
  class Capability < APIResource
    OBJECT_NAME = "capability"

    def self.object_name
      OBJECT_NAME
    end

    # Public `request` shadows the HTTP helper `request_object` calls, so this goes to the client.
    def self.request_object(method, path, params = {}, opts = {})
      resp = Frame::FrameClient.active_client.request(method, path, params, opts)
      Util.convert_to_frame_object(resp, opts)
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

    def self.reactivate(account_id, name, opts = {})
      request_object(:post, "/v1/accounts/#{CGI.escape(account_id)}/capabilities/#{CGI.escape(name)}/reactivate", {}, opts)
    end
  end
end
