# frozen_string_literal: true

require "test_helper"

class TestWebhookEndpoint < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_list_webhook_endpoints
    stub_api_request(
      :get,
      "/v1/webhook_endpoints",
      "webhook_endpoints_list.json"
    )

    endpoints = Frame::WebhookEndpoint.list
    assert_equal 2, endpoints.data.size
    assert_equal "we_1234567890abcdef", endpoints.data.first.id
    assert_equal true, endpoints.data.first.enabled
    assert_equal "we_abcdef1234567890", endpoints.data.last.id
    assert_equal false, endpoints.data.last.enabled

    assert_equal false, endpoints.has_more?
    assert_equal 1, endpoints.instance_variable_get(:@page)
  end

  def test_list_webhook_endpoints_with_params
    stub_api_request(
      :get,
      "/v1/webhook_endpoints",
      "webhook_endpoints_list.json",
      request_params: {page: 1, per_page: 20}
    )

    endpoints = Frame::WebhookEndpoint.list(page: 1, per_page: 20)

    assert_equal 2, endpoints.data.size
    assert_requested :get, "#{Frame.api_base}/v1/webhook_endpoints",
      query: {page: 1, per_page: 20},
      times: 1
  end

  def test_retrieve_webhook_endpoint
    endpoint_id = "we_1234567890abcdef"
    stub_api_request(:get, "/v1/webhook_endpoints/#{endpoint_id}", "webhook_endpoint.json")

    endpoint = Frame::WebhookEndpoint.retrieve(endpoint_id)
    assert_equal endpoint_id, endpoint.id
    assert_equal "https://example.com/webhook", endpoint.url
    assert_equal "active", endpoint.status
    assert_requested :get, "#{Frame.api_base}/v1/webhook_endpoints/#{endpoint_id}", times: 1
  end

  def test_create_webhook_endpoint
    stub_api_request(:post, "/v1/webhook_endpoints", "webhook_endpoint.json")

    endpoint = Frame::WebhookEndpoint.create(
      url: "https://example.com/webhook",
      description: "My webhook",
      event_codes: ["charge.succeeded", "charge.failed"]
    )

    assert_equal "we_1234567890abcdef", endpoint.id
    assert_equal "https://example.com/webhook", endpoint.url
    assert_requested :post, "#{Frame.api_base}/v1/webhook_endpoints", times: 1
  end

  def test_rotate_secret_class_method
    endpoint_id = "we_1234567890abcdef"
    stub_api_request(:post, "/v1/webhook_endpoints/#{endpoint_id}/rotate_secret", "webhook_endpoint_rotated.json")

    endpoint = Frame::WebhookEndpoint.rotate_secret(endpoint_id)
    assert_equal "whsec_newrotatedsecret1234", endpoint.secret
    assert_requested :post, "#{Frame.api_base}/v1/webhook_endpoints/#{endpoint_id}/rotate_secret", times: 1
  end

  def test_rotate_secret_instance_method
    endpoint_id = "we_1234567890abcdef"
    stub_api_request(:get, "/v1/webhook_endpoints/#{endpoint_id}", "webhook_endpoint.json")
    stub_api_request(:post, "/v1/webhook_endpoints/#{endpoint_id}/rotate_secret", "webhook_endpoint_rotated.json")

    endpoint = Frame::WebhookEndpoint.retrieve(endpoint_id)
    rotated = endpoint.rotate_secret
    assert_equal "whsec_newrotatedsecret1234", rotated.secret
  end

  def test_delete_webhook_endpoint
    endpoint_id = "we_1234567890abcdef"
    stub_api_request(:get, "/v1/webhook_endpoints/#{endpoint_id}", "webhook_endpoint.json")
    stub_api_request(:delete, "/v1/webhook_endpoints/#{endpoint_id}", "webhook_endpoint.json")

    endpoint = Frame::WebhookEndpoint.retrieve(endpoint_id)
    endpoint.delete
    assert_requested :delete, "#{Frame.api_base}/v1/webhook_endpoints/#{endpoint_id}", times: 1
  end

  def test_update_webhook_endpoint_class_method
    endpoint_id = "we_1234567890abcdef"
    stub_api_request(:patch, "/v1/webhook_endpoints/#{endpoint_id}", "webhook_endpoint.json")

    endpoint = Frame::WebhookEndpoint.update(endpoint_id, url: "https://example.com/new")
    assert_equal endpoint_id, endpoint.id
    assert_requested :patch, "#{Frame.api_base}/v1/webhook_endpoints/#{endpoint_id}", times: 1
  end

  def test_delete_webhook_endpoint_class_method
    endpoint_id = "we_1234567890abcdef"
    stub_api_request(:delete, "/v1/webhook_endpoints/#{endpoint_id}", "webhook_endpoint.json")

    Frame::WebhookEndpoint.delete(endpoint_id)
    assert_requested :delete, "#{Frame.api_base}/v1/webhook_endpoints/#{endpoint_id}", times: 1
  end
end
