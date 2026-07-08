# frozen_string_literal: true

module Frame
  class OnboardingSession < APIResource
    OBJECT_NAME = "onboarding_session"

    def self.object_name
      OBJECT_NAME
    end

    def self.create(params = {}, opts = {})
      request_object(:post, "/v1/onboarding_sessions", params, opts)
    end

    def self.list(params = {}, opts = {})
      request_object(:get, "/v1/onboarding_sessions", params, opts)
    end

    # Bootstrap the embedded onboarding Web Component from a client_secret.
    # GET /v1/onboarding_sessions/bootstrap — authenticate with the onb_sess_*
    # token (pass via opts). Returns session metadata, the ordered step list,
    # and full account context in one call.
    def self.bootstrap(opts = {})
      request_object(:get, "/v1/onboarding_sessions/bootstrap", {}, opts)
    end
  end
end
