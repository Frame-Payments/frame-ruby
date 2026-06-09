# frozen_string_literal: true

module Frame
  class Transfer < APIResource
    OBJECT_NAME = "transfer"

    def self.object_name
      OBJECT_NAME
    end

    def self.create(params = {}, opts = {})
      request_object(:post, "/v1/transfers", params, opts)
    end

    def self.list(params = {}, opts = {})
      request_object(:get, "/v1/transfers", params, opts)
    end

    def self.retrieve(id, opts = {})
      request_object(:get, "/v1/transfers/#{CGI.escape(id)}", {}, opts)
    end

    def self.confirm(id, params = {}, opts = {})
      id = Util.normalize_id(id)
      request_object(:post, "/v1/transfers/#{CGI.escape(id)}/confirm", params, opts)
    end

    def confirm(params = {}, opts = {})
      request_object(:post, "/v1/transfers/#{CGI.escape(self["id"])}/confirm", params, opts)
    end
  end
end
