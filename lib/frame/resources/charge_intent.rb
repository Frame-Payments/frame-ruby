# frozen_string_literal: true

module Frame
  class ChargeIntent < APIResource
    extend Frame::APIOperations::Create
    extend Frame::APIOperations::List
    include Frame::APIOperations::Save

    OBJECT_NAME = "charge_intent"

    def self.object_name
      OBJECT_NAME
    end

    DEPRECATED_METHODS = %i[create retrieve list confirm capture cancel void_remaining save].freeze

    # @deprecated Use Frame::Transfer.create instead. Removed at v2.
    def self.create(params = {}, opts = {})
      request_object(
        :post,
        "/v1/charge_intents",
        params,
        opts
      )
    end

    # @deprecated Use Frame::Transfer.list instead. Removed at v2.
    def self.list(params = {}, opts = {})
      request_object(
        :get,
        "/v1/charge_intents",
        params,
        opts
      )
    end

    # @deprecated Use Frame::Transfer.retrieve instead. Removed at v2.
    def self.retrieve(id, opts = {})
      id = Util.normalize_id(id)
      request_object(
        :get,
        "/v1/charge_intents/#{CGI.escape(id)}",
        {},
        opts
      )
    end

    # @deprecated Use Frame::Transfer.confirm instead. Removed at v2.
    def confirm(params = {}, opts = {})
      request_object(
        :post,
        "/v1/charge_intents/#{CGI.escape(self["id"])}/confirm",
        params,
        opts
      )
    end

    # @deprecated Use Frame::Transfer.confirm instead. Removed at v2.
    def self.confirm(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/charge_intents/#{CGI.escape(id)}/confirm",
        params,
        opts
      )
    end

    # @deprecated Removed at v2. No canonical transfer equivalent yet (FRA-4463).
    def capture(params = {}, opts = {})
      request_object(
        :post,
        "/v1/charge_intents/#{CGI.escape(self["id"])}/capture",
        params,
        opts
      )
    end

    # @deprecated Removed at v2. No canonical transfer equivalent yet (FRA-4463).
    def self.capture(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/charge_intents/#{CGI.escape(id)}/capture",
        params,
        opts
      )
    end

    # @deprecated Removed at v2. No canonical transfer equivalent yet (FRA-4463).
    def cancel(params = {}, opts = {})
      request_object(
        :post,
        "/v1/charge_intents/#{CGI.escape(self["id"])}/cancel",
        params,
        opts
      )
    end

    # @deprecated Removed at v2. No canonical transfer equivalent yet (FRA-4463).
    def self.cancel(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/charge_intents/#{CGI.escape(id)}/cancel",
        params,
        opts
      )
    end

    # @deprecated Removed at v2. No canonical transfer equivalent yet (FRA-4463).
    def void_remaining(params = {}, opts = {})
      request_object(
        :post,
        "/v1/charge_intents/#{CGI.escape(self["id"])}/void_remaining",
        params,
        opts
      )
    end

    # @deprecated Removed at v2. No canonical transfer equivalent yet (FRA-4463).
    def self.void_remaining(id, params = {}, opts = {})
      request_object(
        :post,
        "/v1/charge_intents/#{CGI.escape(id)}/void_remaining",
        params,
        opts
      )
    end

    # @deprecated Removed at v2. No canonical transfer equivalent yet (FRA-4463).
    def save(params = {}, opts = {})
      values = serialize_params(self).merge(params)

      if values.empty?
        return self
      end

      updated = request_object(
        :patch,
        "/v1/charge_intents/#{CGI.escape(self["id"])}",
        values,
        opts
      )

      initialize_from(updated)
      self
    end
  end
end
