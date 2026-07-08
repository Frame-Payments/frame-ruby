# frozen_string_literal: true

require "test_helper"

class TestMerchantBalance < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_retrieve_merchant_balance
    stub_api_request(
      :get,
      "/v1/merchant_balance",
      "merchant_balance.json"
    )

    balance = Frame::MerchantBalance.retrieve

    assert_equal "USD", balance.currency
    assert_equal 40000.0, balance.available_for_payout
    assert_equal "AVAILABLE", balance.status
    assert_requested :get, "#{Frame.api_base}/v1/merchant_balance", times: 1
  end
end
