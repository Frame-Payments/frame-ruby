# frozen_string_literal: true

require "test_helper"

class TestTermsOfService < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_create_token
    stub_api_request(
      :post,
      "/v1/terms_of_service",
      "terms_of_service_token.json"
    )

    result = Frame::TermsOfService.create_token
    assert_equal "tos_token_abc123", result.token
    assert_equal "terms_of_service", result.object

    assert_requested :post, "#{Frame.api_base}/v1/terms_of_service", times: 1
  end

  def test_update_terms_of_service
    stub_api_request(
      :patch,
      "/v1/terms_of_service",
      "terms_of_service_token.json"
    )

    result = Frame::TermsOfService.update(accepted: true)
    assert_equal "terms_of_service", result.object

    assert_requested :patch, "#{Frame.api_base}/v1/terms_of_service", times: 1
  end
end
