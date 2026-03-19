# frozen_string_literal: true

module Frame
  class Dispute < APIResource
    include Frame::APIOperations::Save

    OBJECT_NAME = "dispute"

    def self.object_name; OBJECT_NAME; end

    def self.list(params = {}, opts = {})
      request_object(:get, "/v1/disputes", params, opts)
    end

    def self.retrieve(id, opts = {})
      request_object(:get, "/v1/disputes/#{CGI.escape(id)}", {}, opts)
    end

    def self.update(id, params = {}, opts = {})
      request_object(:patch, "/v1/disputes/#{CGI.escape(id)}", params, opts)
    end

    def save(params = {}, opts = {})
      values = serialize_params(self).merge(params)
      return self if values.empty?
      updated = request_object(:patch, "/v1/disputes/#{CGI.escape(self["id"])}", values, opts)
      initialize_from(updated)
      self
    end

    def create_document(params = {}, opts = {})
      request_object(:post, "/v1/disputes/#{CGI.escape(self["id"])}/documents", params, opts)
    end

    def self.create_document(id, params = {}, opts = {})
      request_object(:post, "/v1/disputes/#{CGI.escape(id)}/documents", params, opts)
    end
  end
end
