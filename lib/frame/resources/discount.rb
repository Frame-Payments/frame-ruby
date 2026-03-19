# frozen_string_literal: true

module Frame
  class Discount < APIResource
    OBJECT_NAME = "discount"

    def self.object_name
      OBJECT_NAME
    end

    def self.list(params = {}, opts = {})
      request_object(:get, "/v1/discounts", params, opts)
    end

    def self.retrieve(id, opts = {})
      request_object(:get, "/v1/discounts/#{CGI.escape(id)}", {}, opts)
    end

    def self.validate(params = {}, opts = {})
      request_object(:post, "/v1/discounts/validate", params, opts)
    end
  end
end
