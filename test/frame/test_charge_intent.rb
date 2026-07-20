# frozen_string_literal: true

require "test_helper"

class TestChargeIntent < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_retrieve_charge_intent
    charge_intent_id = "ci_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/charge_intents/#{charge_intent_id}",
      "charge_intent.json"
    )

    charge_intent = Frame::ChargeIntent.retrieve(charge_intent_id)
    assert_equal charge_intent_id, charge_intent.id
    assert_equal 10000, charge_intent.amount
    assert_equal "usd", charge_intent.currency
    assert_equal "pending", charge_intent.status
    assert_equal "charge_intent", charge_intent.object
  end

  def test_create_charge_intent
    stub_api_request(
      :post,
      "/v1/charge_intents",
      "charge_intent.json"
    )

    charge_intent = Frame::ChargeIntent.create(
      amount: 10000,
      currency: "usd",
      description: "Test charge intent"
    )

    assert_equal "ci_1234567890abcdef", charge_intent.id
    assert_equal 10000, charge_intent.amount
    assert_equal "usd", charge_intent.currency
    assert_equal "charge_intent", charge_intent.object
  end

  def test_create_charge_intent_with_sonar_session_id
    stub_api_request(
      :post,
      "/v1/charge_intents",
      "charge_intent.json"
    )

    Frame::ChargeIntent.create(
      amount: 10000,
      currency: "usd",
      description: "Test charge intent",
      sonar_session_id: "fps_sandbox_01H8X9Y2Z3A4B5C6D7E8F9G0H1"
    )

    assert_requested :post, "#{Frame.api_base}/v1/charge_intents", times: 1 do |req|
      body = JSON.parse(req.body)
      body["sonar_session_id"] == "fps_sandbox_01H8X9Y2Z3A4B5C6D7E8F9G0H1"
    end
  end

  def test_update_charge_intent
    charge_intent_id = "ci_1234567890abcdef"

    # Stub retrieve request
    stub_api_request(
      :get,
      "/v1/charge_intents/#{charge_intent_id}",
      "charge_intent.json"
    )

    # Stub update request
    stub_api_request(
      :patch,
      "/v1/charge_intents/#{charge_intent_id}",
      "charge_intent.json"
    )

    charge_intent = Frame::ChargeIntent.retrieve(charge_intent_id)
    charge_intent.description = "Updated description"
    charge_intent.save

    assert_requested :patch, "#{Frame.api_base}/v1/charge_intents/#{charge_intent_id}", times: 1
  end

  def test_list_charge_intents
    stub_api_request(
      :get,
      "/v1/charge_intents",
      "charge_intents_list.json"
    )

    charge_intents = Frame::ChargeIntent.list
    assert_equal 2, charge_intents.data.size
    assert_equal "ci_1234567890abcdef", charge_intents.data.first.id
    assert_equal "pending", charge_intents.data.first.status
    assert_equal "ci_abcdef1234567890", charge_intents.data.last.id
    assert_equal "succeeded", charge_intents.data.last.status

    assert_equal false, charge_intents.has_more?
    assert_equal 1, charge_intents.instance_variable_get(:@page)
  end

  def test_list_charge_intents_with_params
    stub_api_request(
      :get,
      "/v1/charge_intents",
      "charge_intents_list.json",
      request_params: {page: 1, per_page: 20}
    )

    charge_intents = Frame::ChargeIntent.list(page: 1, per_page: 20)

    assert_equal 2, charge_intents.data.size
    assert_requested :get, "#{Frame.api_base}/v1/charge_intents",
      query: {page: 1, per_page: 20},
      times: 1
  end

  def test_confirm_charge_intent
    charge_intent_id = "ci_1234567890abcdef"

    # Stub retrieve request
    stub_api_request(
      :get,
      "/v1/charge_intents/#{charge_intent_id}",
      "charge_intent.json"
    )

    # Stub confirm request
    stub_api_request(
      :post,
      "/v1/charge_intents/#{charge_intent_id}/confirm",
      "authorized_charge_intent.json"
    )

    charge_intent = Frame::ChargeIntent.retrieve(charge_intent_id)
    confirmed_intent = charge_intent.confirm

    assert_equal charge_intent_id, confirmed_intent.id
    assert_equal "authorized", confirmed_intent.status

    assert_requested :post, "#{Frame.api_base}/v1/charge_intents/#{charge_intent_id}/confirm", times: 1
  end

  def test_capture_charge_intent
    charge_intent_id = "ci_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/charge_intents/#{charge_intent_id}",
      "authorized_charge_intent.json"
    )

    stub_api_request(
      :post,
      "/v1/charge_intents/#{charge_intent_id}/capture",
      "captured_charge_intent.json"
    )

    charge_intent = Frame::ChargeIntent.retrieve(charge_intent_id)
    captured_intent = charge_intent.capture

    assert_equal charge_intent_id, captured_intent.id
    assert_equal "succeeded", captured_intent.status

    assert_requested :post, "#{Frame.api_base}/v1/charge_intents/#{charge_intent_id}/capture", times: 1
  end

  def test_cancel_charge_intent
    charge_intent_id = "ci_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/charge_intents/#{charge_intent_id}",
      "charge_intent.json"
    )

    stub_api_request(
      :post,
      "/v1/charge_intents/#{charge_intent_id}/cancel",
      "cancelled_charge_intent.json"
    )

    charge_intent = Frame::ChargeIntent.retrieve(charge_intent_id)
    cancelled_intent = charge_intent.cancel

    assert_equal charge_intent_id, cancelled_intent.id
    assert_equal "cancelled", cancelled_intent.status

    assert_requested :post, "#{Frame.api_base}/v1/charge_intents/#{charge_intent_id}/cancel", times: 1
  end

  def test_void_remaining_charge_intent
    charge_intent_id = "ci_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/charge_intents/#{charge_intent_id}",
      "charge_intent.json"
    )

    stub_api_request(
      :post,
      "/v1/charge_intents/#{charge_intent_id}/void_remaining",
      "charge_intent.json"
    )

    charge_intent = Frame::ChargeIntent.retrieve(charge_intent_id)
    voided_intent = charge_intent.void_remaining

    assert_equal charge_intent_id, voided_intent.id

    assert_requested :post, "#{Frame.api_base}/v1/charge_intents/#{charge_intent_id}/void_remaining", times: 1
  end

  # FRA-4462: chargeIntents is demoted in favor of transfers. The methods must
  # remain fully functional (verified by the tests above) but be flagged
  # deprecated in the surface manifest via DEPRECATED_METHODS.
  def test_deprecated_methods_are_registered
    expected = %i[create retrieve list confirm capture cancel void_remaining save]

    assert Frame::ChargeIntent.const_defined?(:DEPRECATED_METHODS, false)
    assert_equal expected.sort, Frame::ChargeIntent::DEPRECATED_METHODS.sort
  end
end
