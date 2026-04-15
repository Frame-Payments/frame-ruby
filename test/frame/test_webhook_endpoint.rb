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
end
