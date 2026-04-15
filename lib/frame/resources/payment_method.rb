# frozen_string_literal: true

module Frame
  class PaymentMethod < APIResource
    extend Frame::APIOperations::Create
    extend Frame::APIOperations::List
    include Frame::APIOperations::Save

    OBJECT_NAME = "payment_method"

    def self.object_name
      OBJECT_NAME
    end

    def self.create(params = {}, opts = {})
      request_object(
        :post,
        "/v1/payment_methods",
        params,
        opts
      )
    end

    def self.list(params = {}, opts = {})
      request_object(
        :get,
        "/v1/payment_methods",
        params,
        opts
      )
    end

    def self.retrieve(id, opts = {})
      id = Util.normalize_id(id)
      request_object(
        :get,
        "/v1/payment_methods/#{CGI.escape(id)}",
        {},
        opts
      )
    end

    def self.connect_plaid(params = {}, opts = {})
      request_object(
        :post,
        "/v1/payment_methods/connect_plaid",
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
        "/v1/payment_methods/#{CGI.escape(self["id"])}",
        values,
        opts
      )

      initialize_from(updated)
      self
    end

    def attach(customer_id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/payment_methods/#{CGI.escape(self["id"])}/attach",
        {customer: customer_id}.merge(params),
        opts
      )
    end

    def self.attach(id, customer_id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/payment_methods/#{CGI.escape(id)}/attach",
        {customer: customer_id}.merge(params),
        opts
      )
    end

    def detach(params = {}, opts = {})
      request_object(
        :post,
        "/v1/payment_methods/#{CGI.escape(self["id"])}/detach",
        params,
        opts
      )
    end

    def self.detach(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/payment_methods/#{CGI.escape(id)}/detach",
        params,
        opts
      )
    end

    def block(params = {}, opts = {})
      request_object(
        :post,
        "/v1/payment_methods/#{CGI.escape(self["id"])}/block",
        params,
        opts
      )
    end

    def self.block(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/payment_methods/#{CGI.escape(id)}/block",
        params,
        opts
      )
    end

    def unblock(params = {}, opts = {})
      request_object(
        :post,
        "/v1/payment_methods/#{CGI.escape(self["id"])}/unblock",
        params,
        opts
      )
    end

    def self.unblock(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/payment_methods/#{CGI.escape(id)}/unblock",
        params,
        opts
      )
    end
  end
end
