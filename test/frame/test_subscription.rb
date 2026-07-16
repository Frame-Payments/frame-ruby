# frozen_string_literal: true

require "test_helper"

class TestSubscription < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_retrieve_subscription
    subscription_id = "sub_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/subscriptions/#{subscription_id}",
      "subscription.json"
    )

    subscription = Frame::Subscription.retrieve(subscription_id)
    assert_equal subscription_id, subscription.id
    assert_equal "active", subscription.status
    assert_equal "subscription", subscription.object
  end

  def test_create_subscription
    stub_api_request(
      :post,
      "/v1/subscriptions",
      "subscription.json"
    )

    subscription = Frame::Subscription.create(
      customer: "55435398-ec47-4bb4-ac9e-64031481cf48"
    )

    assert_equal "sub_1234567890abcdef", subscription.id
    assert_equal "active", subscription.status
    assert_equal "subscription", subscription.object
  end

  def test_update_subscription
    subscription_id = "sub_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/subscriptions/#{subscription_id}",
      "subscription.json"
    )

    stub_api_request(
      :patch,
      "/v1/subscriptions/#{subscription_id}",
      "subscription.json"
    )

    subscription = Frame::Subscription.retrieve(subscription_id)
    subscription.save(metadata: {key: "value"})

    assert_requested :patch, "#{Frame.api_base}/v1/subscriptions/#{subscription_id}", times: 1
  end

  def test_list_subscriptions
    stub_api_request(
      :get,
      "/v1/subscriptions",
      "subscriptions_list.json"
    )

    subscriptions = Frame::Subscription.list
    assert_equal 2, subscriptions.data.size
    assert_equal "sub_1234567890abcdef", subscriptions.data.first.id
    assert_equal "active", subscriptions.data.first.status
    assert_equal "sub_abcdef1234567890", subscriptions.data.last.id
    assert_equal "paused", subscriptions.data.last.status

    assert_equal false, subscriptions.has_more?
    assert_equal 1, subscriptions.instance_variable_get(:@page)
  end

  def test_list_subscriptions_with_params
    stub_api_request(
      :get,
      "/v1/subscriptions",
      "subscriptions_list.json",
      request_params: {page: 1, per_page: 20}
    )

    subscriptions = Frame::Subscription.list(page: 1, per_page: 20)

    assert_equal 2, subscriptions.data.size
    assert_requested :get, "#{Frame.api_base}/v1/subscriptions",
      query: {page: 1, per_page: 20},
      times: 1
  end

  def test_cancel_subscription
    subscription_id = "sub_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/subscriptions/#{subscription_id}",
      "subscription.json"
    )

    stub_api_request(
      :post,
      "/v1/subscriptions/#{subscription_id}/cancel",
      "cancelled_subscription.json"
    )

    subscription = Frame::Subscription.retrieve(subscription_id)
    cancelled = subscription.cancel

    assert_equal subscription_id, cancelled.id
    assert_equal "cancelled", cancelled.status

    assert_requested :post, "#{Frame.api_base}/v1/subscriptions/#{subscription_id}/cancel", times: 1
  end

  def test_pause_subscription
    subscription_id = "sub_1234567890abcdef"

    stub_api_request(:post, "/v1/subscriptions/#{subscription_id}/pause", "subscription.json")

    paused = Frame::Subscription.pause(subscription_id)

    assert_equal subscription_id, paused.id
    assert_requested :post, "#{Frame.api_base}/v1/subscriptions/#{subscription_id}/pause", times: 1
  end

  def test_resume_subscription
    subscription_id = "sub_1234567890abcdef"

    stub_api_request(:post, "/v1/subscriptions/#{subscription_id}/resume", "subscription.json")

    resumed = Frame::Subscription.resume(subscription_id)

    assert_equal subscription_id, resumed.id
    assert_requested :post, "#{Frame.api_base}/v1/subscriptions/#{subscription_id}/resume", times: 1
  end

  def test_class_update_subscription
    subscription_id = "sub_1234567890abcdef"

    stub_api_request(
      :patch,
      "/v1/subscriptions/#{subscription_id}",
      "subscription.json"
    )

    subscription = Frame::Subscription.update(subscription_id, metadata: {key: "value"})
    assert_equal subscription_id, subscription.id
    assert_requested :patch, "#{Frame.api_base}/v1/subscriptions/#{subscription_id}", times: 1
  end

  def test_search_subscriptions
    stub_api_request(
      :get,
      "/v1/subscriptions/search",
      "subscriptions_list.json",
      request_params: {status: "active"}
    )

    subscriptions = Frame::Subscription.search(status: "active")

    assert_equal 2, subscriptions.data.size
    assert_requested :get, "#{Frame.api_base}/v1/subscriptions/search",
      query: {status: "active"},
      times: 1
  end
end
