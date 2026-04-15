# frozen_string_literal: true

require "test_helper"

class TestOnboarding < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_create_onboarding_session
    stub_api_request(
      :post,
      "/v1/onboarding/sessions",
      "onboarding_session_end_user.json"
    )

    session = Frame::Onboarding.create(
      customer_id: "cus_123",
      entry_point: "payout"
    )

    assert_equal "os_1234567890abcdef", session.id
    assert_equal "in_progress", session.status
    assert_equal "onboarding_session", session.object
  end

  def test_list_onboarding_sessions
    stub_api_request(
      :get,
      "/v1/onboarding/sessions",
      "onboarding_sessions_end_user_list.json"
    )

    sessions = Frame::Onboarding.list
    refute_nil sessions
    assert_requested :get, "#{Frame.api_base}/v1/onboarding/sessions", times: 1
  end

  def test_retrieve_onboarding_session
    session_id = "os_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/onboarding/sessions/#{session_id}",
      "onboarding_session_end_user.json"
    )

    session = Frame::Onboarding.retrieve(session_id)
    assert_equal session_id, session.id
    assert_equal "in_progress", session.status
  end

  def test_update_onboarding_session
    session_id = "os_1234567890abcdef"

    stub_api_request(
      :patch,
      "/v1/onboarding/sessions/#{session_id}",
      "onboarding_session_end_user.json"
    )

    session = Frame::Onboarding.update(session_id, status: "completed")
    assert_equal session_id, session.id
    assert_requested :patch, "#{Frame.api_base}/v1/onboarding/sessions/#{session_id}", times: 1
  end

  def test_payout_onboarding_session
    session_id = "os_1234567890abcdef"

    stub_api_request(
      :post,
      "/v1/onboarding/sessions/#{session_id}/payout",
      "onboarding_session_end_user.json"
    )

    session = Frame::Onboarding.payout(session_id, payout_method_id: "pm_123")
    assert_equal session_id, session.id
    assert_requested :post, "#{Frame.api_base}/v1/onboarding/sessions/#{session_id}/payout", times: 1
  end
end
