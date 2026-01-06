# frozen_string_literal: true

module Frame
  class ProductPhase < APIResource
    extend Frame::APIOperations::Create
    extend Frame::APIOperations::List
    include Frame::APIOperations::Delete
    include Frame::APIOperations::Save

    OBJECT_NAME = "product_phase"

    def self.object_name
      OBJECT_NAME
    end

    def self.create(params = {}, opts = {})
      request_object(
        :post,
        "/v1/product_phases",
        params,
        opts
      )
    end

    def self.list(params = {}, opts = {})
      request_object(
        :get,
        "/v1/product_phases",
        params,
        opts
      )
    end

    def self.retrieve(id, opts = {})
      id = Util.normalize_id(id)
      request_object(
        :get,
        "/v1/product_phases/#{CGI.escape(id)}",
        {},
        opts
      )
    end

    def self.delete(id, params = {}, opts = {})
      request_object(
        :delete,
        "/v1/product_phases/#{CGI.escape(id)}",
        params,
        opts
      )
    end

    def save(params = {}, opts = {})
      values = serialize_params(self).merge(params)

      if values.empty?
        return self
      end

      updated = request_object(
        :patch,
        "/v1/product_phases/#{CGI.escape(self["id"])}",
        values,
        opts
      )

      initialize_from(updated)
      self
    end

    def delete(params = {}, opts = {})
      request_object(
        :delete,
        "/v1/product_phases/#{CGI.escape(self["id"])}",
        params,
        opts
      )
    end
  end
end
