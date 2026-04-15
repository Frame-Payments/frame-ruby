# frozen_string_literal: true

require "test_helper"

class TestSonarSession < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_create_sonar_session
    stub_api_request(
      :post,
      "/v1/sonar_sessions",
      "sonar_session.json"
    )

    session = Frame::SonarSession.create(visitor_id: "v_123")
    assert_equal "fps_1234567890abcdef", session.id
    assert_equal "v_123", session.visitor_id
    assert_equal "sonar_session", session.object
  end

  def test_update_sonar_session
    id = "fps_1234567890abcdef"
    stub_api_request(:patch, "/v1/sonar_sessions/#{id}", "sonar_session.json")

    result = Frame::SonarSession.update(id, visitor_id: "v_456")
    assert_equal id, result.id
    assert_equal "sonar_session", result.object

    assert_requested :patch, "#{Frame.api_base}/v1/sonar_sessions/#{id}", times: 1
  end
end
