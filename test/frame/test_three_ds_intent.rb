# frozen_string_literal: true

require "test_helper"

class TestThreeDsIntent < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_create_three_ds_intent
    stub_api_request(
      :post,
      "/v1/3ds/intents",
      "three_ds_intent.json"
    )

    intent = Frame::ThreeDsIntent.create(payment_method_id: "pm_123")
    assert_equal "3ds_1234567890abcdef", intent.id
    assert_equal "pm_123", intent.payment_method_id
    assert_equal "pending", intent.status
    assert_equal "three_ds_intent", intent.object
  end

  def test_retrieve_three_ds_intent
    intent_id = "3ds_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/3ds/intents/#{intent_id}",
      "three_ds_intent.json"
    )

    intent = Frame::ThreeDsIntent.retrieve(intent_id)
    assert_equal intent_id, intent.id
    assert_equal "pending", intent.status
    assert_equal "three_ds_intent", intent.object
  end

  def test_resend_three_ds_intent
    intent_id = "3ds_1234567890abcdef"
    stub_api_request(
      :post,
      "/v1/3ds/intents/#{intent_id}/resend",
      "three_ds_intent.json"
    )

    result = Frame::ThreeDsIntent.resend(intent_id)
    assert_equal intent_id, result.id
    assert_equal "three_ds_intent", result.object

    assert_requested :post, "#{Frame.api_base}/v1/3ds/intents/#{intent_id}/resend", times: 1
  end
end
