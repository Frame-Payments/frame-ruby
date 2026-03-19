# frozen_string_literal: true

module Frame
  class Geofence < APIResource
    OBJECT_NAME = "geofence"

    def self.object_name
      OBJECT_NAME
    end

    def self.list(params = {}, opts = {})
      request_object(:get, "/v1/geofences", params, opts)
    end
  end
end
