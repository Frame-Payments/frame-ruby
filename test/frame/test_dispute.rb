# frozen_string_literal: true

require "test_helper"

class TestDispute < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_list_disputes
    stub_api_request(
      :get,
      "/v1/disputes",
      "disputes_list.json"
    )

    disputes = Frame::Dispute.list
    assert_equal 1, disputes.data.size
    assert_equal "dp_1234567890abcdef", disputes.data.first.id
    assert_equal "under_review", disputes.data.first.status
    assert_equal "dispute", disputes.data.first.object
  end

  def test_retrieve_dispute
    dispute_id = "dp_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/disputes/#{dispute_id}",
      "dispute.json"
    )

    dispute = Frame::Dispute.retrieve(dispute_id)
    assert_equal dispute_id, dispute.id
    assert_equal 5000, dispute.amount_cents
    assert_equal "usd", dispute.amount_currency
    assert_equal "under_review", dispute.status
    assert_equal "dispute", dispute.object
  end

  def test_update_dispute
    dispute_id = "dp_1234567890abcdef"
    stub_api_request(:get, "/v1/disputes/#{dispute_id}", "dispute.json")
    stub_api_request(:patch, "/v1/disputes/#{dispute_id}", "dispute.json")

    dispute = Frame::Dispute.retrieve(dispute_id)
    dispute.status = "accepted"
    dispute.save

    assert_requested :patch, "#{Frame.api_base}/v1/disputes/#{dispute_id}", times: 1
  end

  def test_create_document
    dispute_id = "dp_1234567890abcdef"
    stub_api_request(:get, "/v1/disputes/#{dispute_id}", "dispute.json")
    stub_api_request(:post, "/v1/disputes/#{dispute_id}/documents", "dispute.json")

    dispute = Frame::Dispute.retrieve(dispute_id)
    dispute.create_document(type: "receipt", file: "file_123")

    assert_requested :post, "#{Frame.api_base}/v1/disputes/#{dispute_id}/documents", times: 1
  end
end
