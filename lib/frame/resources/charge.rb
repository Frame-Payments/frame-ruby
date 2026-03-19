# frozen_string_literal: true

module Frame
  class Charge < APIResource
    OBJECT_NAME = "charge"

    def self.object_name; OBJECT_NAME; end

    def self.retrieve(id, opts = {})
      request_object(:get, "/v1/charges/#{CGI.escape(id)}", {}, opts)
    end

    def self.trace(id, opts = {})
      request_object(:get, "/v1/charges/#{CGI.escape(id)}/trace", {}, opts)
    end
  end
end
