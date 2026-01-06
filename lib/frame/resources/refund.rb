# frozen_string_literal: true

module Frame
  class Refund < APIResource
    extend Frame::APIOperations::Create
    extend Frame::APIOperations::List

    OBJECT_NAME = "refund"

    def self.object_name
      OBJECT_NAME
    end

    def self.create(params = {}, opts = {})
      request_object(
        :post,
        "/v1/refunds",
        params,
        opts
      )
    end

    def self.list(params = {}, opts = {})
      request_object(
        :get,
        "/v1/refunds",
        params,
        opts
      )
    end

    def self.retrieve(id, opts = {})
      id = Util.normalize_id(id)
      request_object(
        :get,
        "/v1/refunds/#{CGI.escape(id)}",
        {},
        opts
      )
    end

    def cancel(params = {}, opts = {})
      request_object(
        :post,
        "/v1/refunds/#{CGI.escape(self["id"])}/cancel",
        params,
        opts
      )
    end

    def self.cancel(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/refunds/#{CGI.escape(id)}/cancel",
        params,
        opts
      )
    end
  end
end
