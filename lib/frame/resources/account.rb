# frozen_string_literal: true

module Frame
  class Account < APIResource
    extend Frame::APIOperations::Create
    extend Frame::APIOperations::List
    include Frame::APIOperations::Save

    OBJECT_NAME = "account"

    def self.object_name
      OBJECT_NAME
    end

    def self.create(params = {}, opts = {})
      request_object(:post, "/v1/accounts", params, opts)
    end

    def self.list(params = {}, opts = {})
      request_object(:get, "/v1/accounts", params, opts)
    end

    def self.retrieve(id, opts = {})
      request_object(:get, "/v1/accounts/#{CGI.escape(id)}", {}, opts)
    end

    def self.disable(id, params = {}, opts = {})
      request_object(:delete, "/v1/accounts/#{CGI.escape(id)}", params, opts)
    end

    def self.geo_compliance(id, opts = {})
      request_object(:get, "/v1/accounts/#{CGI.escape(id)}/geo_compliance", {}, opts)
    end

    def save(params = {}, opts = {})
      values = serialize_params(self).merge(params)
      return self if values.empty?
      updated = request_object(:patch, "/v1/accounts/#{CGI.escape(self["id"])}", values, opts)
      initialize_from(updated)
      self
    end
  end
end
