# frozen_string_literal: true

module Frame
  class Onboarding < APIResource
    OBJECT_NAME = "onboarding_session"

    def self.object_name
      OBJECT_NAME
    end

    def self.list(params = {}, opts = {})
      request_object(:get, "/v1/onboarding/sessions", params, opts)
    end

    def self.create(params = {}, opts = {})
      request_object(:post, "/v1/onboarding/sessions", params, opts)
    end

    def self.retrieve(session_id, opts = {})
      request_object(:get, "/v1/onboarding/sessions/#{CGI.escape(session_id)}", {}, opts)
    end

    def self.update(session_id, params = {}, opts = {})
      request_object(:patch, "/v1/onboarding/sessions/#{CGI.escape(session_id)}", params, opts)
    end

    def self.payout(session_id, params = {}, opts = {})
      request_object(:post, "/v1/onboarding/sessions/#{CGI.escape(session_id)}/payout", params, opts)
    end
  end
end
