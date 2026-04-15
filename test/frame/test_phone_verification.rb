# frozen_string_literal: true

require "test_helper"

class TestPhoneVerification < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_create_phone_verification
    account_id = "acct_123"
    stub_api_request(
      :post,
      "/v1/accounts/#{account_id}/phone_verifications",
      "phone_verification.json"
    )

    verification = Frame::PhoneVerification.create(
      account_id,
      phone_number: "+15551234567"
    )
    assert_equal "pv_1234567890abcdef", verification.id
    assert_equal account_id, verification.account_id
    assert_equal "pending", verification.status
    assert_equal "phone_verification", verification.object
  end

  def test_confirm_phone_verification
    account_id = "acct_123"
    verification_id = "pv_1234567890abcdef"
    stub_api_request(
      :post,
      "/v1/accounts/#{account_id}/phone_verifications/#{verification_id}/confirm",
      "confirmed_phone_verification.json"
    )

    verification = Frame::PhoneVerification.confirm(
      account_id,
      verification_id,
      code: "123456"
    )
    assert_equal verification_id, verification.id
    assert_equal "confirmed", verification.status
    assert_equal "phone_verification", verification.object

    assert_requested :post, "#{Frame.api_base}/v1/accounts/#{account_id}/phone_verifications/#{verification_id}/confirm", times: 1
  end
end
