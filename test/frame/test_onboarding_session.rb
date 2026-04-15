# frozen_string_literal: true

require "test_helper"

class TestOnboardingSession < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_create_onboarding_session
    stub_api_request(
      :post,
      "/v1/onboarding_sessions",
      "onboarding_session_account.json"
    )

    session = Frame::OnboardingSession.create(
      account_id: "acct_123",
      return_url: "https://example.com/return"
    )
    assert_equal "acs_1234567890abcdef", session.id
    assert_equal "acct_123", session.account_id
    assert_equal "onboarding_session", session.object
  end

  def test_list_onboarding_sessions
    stub_api_request(
      :get,
      "/v1/onboarding_sessions",
      "onboarding_sessions_list.json",
      request_params: {account_id: "acct_123"}
    )

    Frame::OnboardingSession.list(account_id: "acct_123")

    assert_requested :get, "#{Frame.api_base}/v1/onboarding_sessions",
      query: {account_id: "acct_123"},
      times: 1
  end
end
