# frozen_string_literal: true

require "test_helper"

class TestSubscriptionChangeLog < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_list_subscription_change_logs
    subscription_id = "sub_123"
    stub_api_request(
      :get,
      "/v1/subscriptions/#{subscription_id}/change_logs",
      "subscription_change_logs_list.json"
    )

    logs = Frame::SubscriptionChangeLog.list(subscription_id)
    assert_equal 1, logs.data.size
    assert_equal "scl_123", logs.data.first.id
    assert_equal subscription_id, logs.data.first.subscription_id
    assert_equal "status", logs.data.first.change_type
    assert_equal "subscription_change_log", logs.data.first.object
  end
end
