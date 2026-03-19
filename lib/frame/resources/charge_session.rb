# frozen_string_literal: true

module Frame
  class ChargeSession < APIResource
    include Frame::APIOperations::Save

    OBJECT_NAME = "charge_session"

    def self.object_name
      OBJECT_NAME
    end

    def self.create(params = {}, opts = {})
      request_object(:post, "/v1/charge_sessions", params, opts)
    end

    def self.update(id, params = {}, opts = {})
      request_object(:patch, "/v1/charge_sessions/#{CGI.escape(id)}", params, opts)
    end

    def save(params = {}, opts = {})
      values = serialize_params(self).merge(params)
      return self if values.empty?
      updated = request_object(:patch, "/v1/charge_sessions/#{CGI.escape(self["id"])}", values, opts)
      initialize_from(updated)
      self
    end
  end
end
