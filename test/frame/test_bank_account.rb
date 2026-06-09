# frozen_string_literal: true

require "test_helper"

class TestBankAccount < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_create_bank_account
    stub_api_request(:post, "/v1/bank_accounts", "bank_account.json")

    bank_account = Frame::BankAccount.create(
      processor: "plaid",
      processor_token: "processor-sandbox-token",
      customer_id: "cus_1234567890abcdef"
    )

    assert_equal "ba_1234567890abcdef", bank_account.id
    assert_equal "bank_account", bank_account.object
    assert_equal "110000000", bank_account.routing_number
    assert_equal "6789", bank_account.account_number_last_4
    assert_equal "active", bank_account.status
    assert_requested :post, "#{Frame.api_base}/v1/bank_accounts", times: 1
  end
end
