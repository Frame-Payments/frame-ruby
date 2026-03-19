# frozen_string_literal: true

module Frame
  class ThreeDsIntent < APIResource
    OBJECT_NAME = "three_ds_intent"

    def self.object_name; OBJECT_NAME; end

    def self.create(params = {}, opts = {})
      request_object(:post, "/v1/3ds/intents", params, opts)
    end

    def self.retrieve(id, opts = {})
      request_object(:get, "/v1/3ds/intents/#{CGI.escape(id)}", {}, opts)
    end

    def self.resend(id, params = {}, opts = {})
      request_object(:post, "/v1/3ds/intents/#{CGI.escape(id)}/resend", params, opts)
    end

    def resend(params = {}, opts = {})
      request_object(:post, "/v1/3ds/intents/#{CGI.escape(self["id"])}/resend", params, opts)
    end
  end
end
