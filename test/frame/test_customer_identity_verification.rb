# frozen_string_literal: true

require "test_helper"

class TestCustomerIdentityVerification < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_retrieve_customer_identity_verification
    verification_id = "civ_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/customer_identity_verifications/#{verification_id}",
      "customer_identity_verification.json"
    )

    verification = Frame::CustomerIdentityVerification.retrieve(verification_id)
    assert_equal verification_id, verification.id
    assert_equal "pending", verification.status
    assert_equal "identity_document", verification.type
    assert_equal "customer_identity_verification", verification.object
  end

  def test_create_customer_identity_verification
    stub_api_request(
      :post,
      "/v1/customer_identity_verifications",
      "customer_identity_verification.json"
    )

    verification = Frame::CustomerIdentityVerification.create(
      customer: "55435398-ec47-4bb4-ac9e-64031481cf48",
      type: "identity_document"
    )

    assert_equal "civ_1234567890abcdef", verification.id
    assert_equal "pending", verification.status
    assert_equal "customer_identity_verification", verification.object
  end

  def test_list_customer_identity_verifications
    stub_api_request(
      :get,
      "/v1/customer_identity_verifications",
      "customer_identity_verifications_list.json"
    )

    verifications = Frame::CustomerIdentityVerification.list
    assert_equal 2, verifications.data.size
    assert_equal "civ_1234567890abcdef", verifications.data.first.id
    assert_equal "pending", verifications.data.first.status
    assert_equal "civ_abcdef1234567890", verifications.data.last.id
    assert_equal "verified", verifications.data.last.status

    assert_equal false, verifications.has_more?
    assert_equal 1, verifications.instance_variable_get(:@page)
  end

  def test_list_customer_identity_verifications_with_params
    stub_api_request(
      :get,
      "/v1/customer_identity_verifications",
      "customer_identity_verifications_list.json",
      request_params: {page: 1, per_page: 20}
    )

    verifications = Frame::CustomerIdentityVerification.list(page: 1, per_page: 20)

    assert_equal 2, verifications.data.size
    assert_requested :get, "#{Frame.api_base}/v1/customer_identity_verifications",
      query: {page: 1, per_page: 20},
      times: 1
  end

  def test_upload_documents_customer_identity_verification
    verification_id = "civ_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/customer_identity_verifications/#{verification_id}",
      "customer_identity_verification.json"
    )

    stub_api_request(
      :post,
      "/v1/customer_identity_verifications/#{verification_id}/upload_documents",
      "verified_customer_identity_verification.json"
    )

    verification = Frame::CustomerIdentityVerification.retrieve(verification_id)
    verified = verification.upload_documents

    assert_equal verification_id, verified.id
    assert_equal "verified", verified.status

    assert_requested :post, "#{Frame.api_base}/v1/customer_identity_verifications/#{verification_id}/upload_documents", times: 1
  end
end
