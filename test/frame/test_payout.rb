# frozen_string_literal: true

require "test_helper"

class TestPayout < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_create_payout
    stub_api_request(
      :post,
      "/v1/payouts",
      "payout.json"
    )

    payout = Frame::Payout.create(
      amount: 10000,
      currency: "usd",
      payment_method: "pm_123"
    )
    assert_equal "po_1234567890abcdef", payout.id
    assert_equal 10000, payout.amount
    assert_equal "usd", payout.currency
    assert_equal "pending", payout.status
    assert_equal "payout", payout.object
  end
end
