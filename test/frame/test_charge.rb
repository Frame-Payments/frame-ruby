# frozen_string_literal: true

require "test_helper"

class TestCharge < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_retrieve_charge
    charge_id = "ch_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/charges/#{charge_id}",
      "charge.json"
    )

    charge = Frame::Charge.retrieve(charge_id)
    assert_equal charge_id, charge.id
    assert_equal "usd", charge.currency
    assert_equal 10000, charge.amount
    assert_equal "succeeded", charge.status
    assert_equal "charge", charge.object
  end

  def test_trace_charge
    charge_id = "ch_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/charges/#{charge_id}/trace",
      "charge.json"
    )

    result = Frame::Charge.trace(charge_id)
    assert_equal charge_id, result.id
    assert_equal "charge", result.object

    assert_requested :get, "#{Frame.api_base}/v1/charges/#{charge_id}/trace", times: 1
  end
end
