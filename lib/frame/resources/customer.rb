# frozen_string_literal: true

module Frame
  class Customer < APIResource
    extend Frame::APIOperations::Create
    extend Frame::APIOperations::List
    include Frame::APIOperations::Delete
    include Frame::APIOperations::Save

    OBJECT_NAME = "customer"

    def self.object_name
      OBJECT_NAME
    end

    # Customers are deprecated in favor of Accounts (M2 demotion). Only methods
    # with a clear cross-resource target are demoted; create/retrieve/list/
    # search/save stay non-deprecated pending an unambiguous mapping.
    DEPRECATED_METHODS = %i[delete block unblock payment_methods].freeze

    def self.create(params = {}, opts = {})
      request_object(
        :post,
        "/v1/customers",
        params,
        opts
      )
    end

    def self.list(params = {}, opts = {})
      request_object(
        :get,
        "/v1/customers",
        params,
        opts
      )
    end

    def self.retrieve(id, opts = {})
      id = Util.normalize_id(id)
      request_object(
        :get,
        "/v1/customers/#{CGI.escape(id)}",
        {},
        opts
      )
    end

    def self.search(params = {}, opts = {})
      request_object(
        :get,
        "/v1/customers/search",
        params,
        opts
      )
    end

    # @deprecated Use `Account.disable` instead. Removed at v2.
    def self.delete(id, params = {}, opts = {})
      request_object(
        :delete,
        "/v1/customers/#{CGI.escape(id)}",
        params,
        opts
      )
    end

    # @deprecated Account.block pending a monolith route; no re-route yet. Removed at v2.
    def block(params = {}, opts = {})
      request_object(
        :post,
        "/v1/customers/#{CGI.escape(self["id"])}/block",
        params,
        opts
      )
    end

    # @deprecated Account.block pending a monolith route; no re-route yet. Removed at v2.
    def self.block(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/customers/#{CGI.escape(id)}/block",
        params,
        opts
      )
    end

    # @deprecated Account.unblock pending a monolith route; no re-route yet. Removed at v2.
    def unblock(params = {}, opts = {})
      request_object(
        :post,
        "/v1/customers/#{CGI.escape(self["id"])}/unblock",
        params,
        opts
      )
    end

    # @deprecated Account.unblock pending a monolith route; no re-route yet. Removed at v2.
    def self.unblock(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/customers/#{CGI.escape(id)}/unblock",
        params,
        opts
      )
    end

    # @deprecated Use `PaymentMethod.list(account_id:)` instead (FRA-4461). Removed at v2.
    def self.payment_methods(id, opts = {})
      request_object(
        :get,
        "/v1/customers/#{CGI.escape(id)}/payment_methods",
        {},
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
        "/v1/customers/#{CGI.escape(self["id"])}",
        values,
        opts
      )

      initialize_from(updated)
      self
    end

    # @deprecated Use `Account.disable` instead. Removed at v2.
    def delete(params = {}, opts = {})
      request_object(
        :delete,
        "/v1/customers/#{CGI.escape(self["id"])}",
        params,
        opts
      )
    end
  end
end
