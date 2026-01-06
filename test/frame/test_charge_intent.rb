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

  def test_authorize_charge_intent
    charge_intent_id = "ci_1234567890abcdef"

    # Stub retrieve request
    stub_api_request(
      :get,
      "/v1/charge_intents/#{charge_intent_id}",
      "charge_intent.json"
    )

    # Stub authorize request
    stub_api_request(
      :post,
      "/v1/charge_intents/#{charge_intent_id}/authorize",
      "authorized_charge_intent.json"
    )

    charge_intent = Frame::ChargeIntent.retrieve(charge_intent_id)
    authorized_intent = charge_intent.authorize

    assert_equal charge_intent_id, authorized_intent.id
    assert_equal "authorized", authorized_intent.status

    assert_requested :post, "#{Frame.api_base}/v1/charge_intents/#{charge_intent_id}/authorize", times: 1
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
end
