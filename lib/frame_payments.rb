# frozen_string_literal: true

# Core dependencies
require "json"
require "logger"
require "uri"
require "cgi"
require "forwardable"
require "faraday"

# Frame SDK core components
require "frame/version"
require "frame/error"
require "frame/util"
require "frame/configuration"
require "frame/frame_client"
require "frame/frame_object"

# API operation modules (must be loaded before classes that use them)
require "frame/api_operations/create"
require "frame/api_operations/delete"
require "frame/api_operations/list"
require "frame/api_operations/request"
require "frame/api_operations/save"

# Core resource classes
require "frame/list_object"
require "frame/api_resource"

# All API resources
require "frame/resources"

# Main Frame module
#
# The Frame module provides the main interface for interacting with the Frame Payments API.
# Configure your API key and start making requests:
#
#   Frame.api_key = 'your_api_key_here'
#   customer = Frame::Customer.create(name: 'John Doe', email: 'john@example.com')
#
# @see https://docs.framepayments.com for API documentation
module Frame
  @config = Configuration.setup

  class << self
    extend Forwardable

    # @return [Configuration] the current configuration object
    attr_reader :config

    # Delegates to the configuration object for easy access to settings
    def_delegators :@config, :api_key, :api_key=
    def_delegators :@config, :api_base, :api_base=
    def_delegators :@config, :open_timeout, :open_timeout=
    def_delegators :@config, :read_timeout, :read_timeout=
    def_delegators :@config, :verify_ssl_certs, :verify_ssl_certs=
    def_delegators :@config, :log_level, :log_level=
    def_delegators :@config, :logger, :logger=
  end
end
