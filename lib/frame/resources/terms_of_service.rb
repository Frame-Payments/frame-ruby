# frozen_string_literal: true

module Frame
  class TermsOfService < APIResource
    OBJECT_NAME = "terms_of_service"

    def self.object_name
      OBJECT_NAME
    end

    def self.create_token(opts = {})
      request_object(:post, "/v1/terms_of_service", {}, opts)
    end

    def self.update(params = {}, opts = {})
      request_object(:patch, "/v1/terms_of_service", params, opts)
    end
  end
end
