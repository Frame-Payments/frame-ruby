# frozen_string_literal: true

module Frame
  class Invoice < APIResource
    extend Frame::APIOperations::Create
    extend Frame::APIOperations::List
    include Frame::APIOperations::Delete
    include Frame::APIOperations::Save

    OBJECT_NAME = "invoice"

    def self.object_name
      OBJECT_NAME
    end

    def self.create(params = {}, opts = {})
      request_object(
        :post,
        "/v1/invoices",
        params,
        opts
      )
    end

    def self.list(params = {}, opts = {})
      request_object(
        :get,
        "/v1/invoices",
        params,
        opts
      )
    end

    def self.retrieve(id, opts = {})
      id = Util.normalize_id(id)
      request_object(
        :get,
        "/v1/invoices/#{CGI.escape(id)}",
        {},
        opts
      )
    end

    def self.delete(id, params = {}, opts = {})
      request_object(
        :delete,
        "/v1/invoices/#{CGI.escape(id)}",
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
        "/v1/invoices/#{CGI.escape(self["id"])}",
        values,
        opts
      )

      initialize_from(updated)
      self
    end

    def delete(params = {}, opts = {})
      request_object(
        :delete,
        "/v1/invoices/#{CGI.escape(self["id"])}",
        params,
        opts
      )
    end

    def finalize(params = {}, opts = {})
      request_object(
        :post,
        "/v1/invoices/#{CGI.escape(self["id"])}/finalize",
        params,
        opts
      )
    end

    def self.finalize(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/invoices/#{CGI.escape(id)}/finalize",
        params,
        opts
      )
    end

    def pay(params = {}, opts = {})
      request_object(
        :post,
        "/v1/invoices/#{CGI.escape(self["id"])}/pay",
        params,
        opts
      )
    end

    def self.pay(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/invoices/#{CGI.escape(id)}/pay",
        params,
        opts
      )
    end

    def void(params = {}, opts = {})
      request_object(
        :post,
        "/v1/invoices/#{CGI.escape(self["id"])}/void",
        params,
        opts
      )
    end

    def self.void(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/invoices/#{CGI.escape(id)}/void",
        params,
        opts
      )
    end
  end
end
