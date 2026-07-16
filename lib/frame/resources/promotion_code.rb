# frozen_string_literal: true

module Frame
  class PromotionCode < APIResource
    include Frame::APIOperations::Save

    OBJECT_NAME = "promotion_code"

    def self.object_name
      OBJECT_NAME
    end

    def self.create(params = {}, opts = {})
      request_object(:post, "/v1/promotion_codes", params, opts)
    end

    def self.list(params = {}, opts = {})
      request_object(:get, "/v1/promotion_codes", params, opts)
    end

    def self.retrieve(id, opts = {})
      request_object(:get, "/v1/promotion_codes/#{CGI.escape(id)}", {}, opts)
    end

    def self.update(id, params = {}, opts = {})
      request_object(:patch, "/v1/promotion_codes/#{CGI.escape(id)}", params, opts)
    end

    def save(params = {}, opts = {})
      values = serialize_params(self).merge(params)
      return self if values.empty?
      updated = request_object(:patch, "/v1/promotion_codes/#{CGI.escape(self["id"])}", values, opts)
      initialize_from(updated)
      self
    end
  end
end
