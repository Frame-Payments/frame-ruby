# frozen_string_literal: true

module Frame
  # Base class for all Frame Payments API resources.
  #
  # All API resources inherit from APIResource, which provides common
  # functionality like retrieving resources by ID and building resource URLs.
  #
  # @abstract Subclass and implement {object_name} to create a new resource type.
  class APIResource < FrameObject
    include Frame::APIOperations::Request

    def self.class_name
      name.split("::")[-1]
    end

    # Builds the base URL for this resource type
    # @return [String] the resource URL (e.g., "/v1/customers")
    def self.resource_url
      if self == APIResource
        raise NotImplementedError,
          "APIResource is an abstract class. You should perform actions " \
          "on its subclasses (Customer, etc.)"
      end

      "/v1/#{object_name.downcase}s"
    end

    # Retrieves a resource by its ID
    # @param id [String] the resource ID
    # @param opts [Hash] additional options
    # @return [APIResource] the retrieved resource instance
    # @example
    #   customer = Frame::Customer.retrieve('cus_123456789')
    def self.retrieve(id, opts = {})
      id = Util.normalize_id(id)
      instance = new(id, opts)
      instance.refresh(opts)
      instance
    end

    # Builds the URL for this specific resource instance
    # @return [String] the resource instance URL
    # @raise [InvalidRequestError] if the resource doesn't have an ID
    def resource_url
      unless (id = self["id"])
        raise InvalidRequestError.new(
          "Could not determine which URL to request: #{self.class} instance " \
          "has invalid ID: #{id.inspect}",
          "id"
        )
      end
      "#{self.class.resource_url}/#{CGI.escape(id)}"
    end

    # Refreshes the resource data from the API
    # @param opts [Hash] additional options
    # @return [APIResource] self, with updated data
    # @example
    #   customer.refresh
    def refresh(opts = {})
      response = request(:get, resource_url, {}, opts)
      initialize_from(response, opts)
      self
    end
  end
end
