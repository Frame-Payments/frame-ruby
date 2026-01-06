# frozen_string_literal: true

require "test_helper"

class TestWebhookEndpoint < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_retrieve_webhook_endpoint
    endpoint_id = "we_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/webhook_endpoints/#{endpoint_id}",
      "webhook_endpoint.json"
    )

    endpoint = Frame::WebhookEndpoint.retrieve(endpoint_id)
    assert_equal endpoint_id, endpoint.id
    assert_equal "https://example.com/webhook", endpoint.url
    assert_equal true, endpoint.enabled
    assert_equal "webhook_endpoint", endpoint.object
  end

  def test_create_webhook_endpoint
    stub_api_request(
      :post,
      "/v1/webhook_endpoints",
      "webhook_endpoint.json"
    )

    endpoint = Frame::WebhookEndpoint.create(
      url: "https://example.com/webhook",
      events: ["charge.succeeded", "charge.failed"]
    )

    assert_equal "we_1234567890abcdef", endpoint.id
    assert_equal "https://example.com/webhook", endpoint.url
    assert_equal true, endpoint.enabled
    assert_equal "webhook_endpoint", endpoint.object
  end

  def test_update_webhook_endpoint
    endpoint_id = "we_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/webhook_endpoints/#{endpoint_id}",
      "webhook_endpoint.json"
    )

    stub_api_request(
      :patch,
      "/v1/webhook_endpoints/#{endpoint_id}",
      "webhook_endpoint.json"
    )

    endpoint = Frame::WebhookEndpoint.retrieve(endpoint_id)
    endpoint.save(events: ["charge.succeeded"])

    assert_requested :patch, "#{Frame.api_base}/v1/webhook_endpoints/#{endpoint_id}", times: 1
  end

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

  def test_enable_webhook_endpoint
    endpoint_id = "we_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/webhook_endpoints/#{endpoint_id}",
      "disabled_webhook_endpoint.json"
    )

    stub_api_request(
      :post,
      "/v1/webhook_endpoints/#{endpoint_id}/enable",
      "enabled_webhook_endpoint.json"
    )

    endpoint = Frame::WebhookEndpoint.retrieve(endpoint_id)
    enabled = endpoint.enable

    assert_equal endpoint_id, enabled.id
    assert_equal true, enabled.enabled

    assert_requested :post, "#{Frame.api_base}/v1/webhook_endpoints/#{endpoint_id}/enable", times: 1
  end

  def test_disable_webhook_endpoint
    endpoint_id = "we_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/webhook_endpoints/#{endpoint_id}",
      "webhook_endpoint.json"
    )

    stub_api_request(
      :post,
      "/v1/webhook_endpoints/#{endpoint_id}/disable",
      "disabled_webhook_endpoint.json"
    )

    endpoint = Frame::WebhookEndpoint.retrieve(endpoint_id)
    disabled = endpoint.disable

    assert_equal endpoint_id, disabled.id
    assert_equal false, disabled.enabled

    assert_requested :post, "#{Frame.api_base}/v1/webhook_endpoints/#{endpoint_id}/disable", times: 1
  end

  def test_delete_webhook_endpoint
    endpoint_id = "we_1234567890abcdef"

    stub_api_request(
      :delete,
      "/v1/webhook_endpoints/#{endpoint_id}",
      "deleted_webhook_endpoint.json"
    )

    deleted_endpoint = Frame::WebhookEndpoint.delete(endpoint_id)

    assert_equal endpoint_id, deleted_endpoint.id
    assert_equal true, deleted_endpoint.deleted
    assert_equal "webhook_endpoint", deleted_endpoint.object

    assert_requested :delete, "#{Frame.api_base}/v1/webhook_endpoints/#{endpoint_id}", times: 1
  end
end
