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
  end
end
