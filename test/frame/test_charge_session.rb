# frozen_string_literal: true

require "test_helper"

class TestChargeSession < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_create_charge_session
    stub_api_request(
      :post,
      "/v1/charge_sessions",
      "charge_session.json"
    )

    charge_session = Frame::ChargeSession.create(visitor_id: "v_123")
    assert_equal "cs_1234567890abcdef", charge_session.id
    assert_equal "v_123", charge_session.visitor_id
    assert_equal "charge_session", charge_session.object
  end

  def test_update_charge_session
    id = "cs_1234567890abcdef"
    stub_api_request(:patch, "/v1/charge_sessions/#{id}", "charge_session.json")

    result = Frame::ChargeSession.update(id, visitor_id: "v_456")
    assert_equal id, result.id
    assert_equal "charge_session", result.object

    assert_requested :patch, "#{Frame.api_base}/v1/charge_sessions/#{id}", times: 1
  end
end
