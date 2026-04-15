# frozen_string_literal: true

require "test_helper"

class TestPaymentLinkSession < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_create_payment_link_session
    stub_api_request(
      :post,
      "/v1/payment_link_sessions",
      "payment_link_session.json"
    )

    session = Frame::PaymentLinkSession.create(
      client_reference_id: "ref_123"
    )
    assert_equal "pls_1234567890abcdef", session.id
    assert_equal "ref_123", session.client_reference_id
    assert_equal "payment_link_session", session.object
  end
end
