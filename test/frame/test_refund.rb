# frozen_string_literal: true

require "test_helper"

class TestRefund < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_retrieve_refund
    refund_id = "rf_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/refunds/#{refund_id}",
      "refund.json"
    )

    refund = Frame::Refund.retrieve(refund_id)
    assert_equal refund_id, refund.id
    assert_equal 5000, refund.amount
    assert_equal "usd", refund.currency
    assert_equal "pending", refund.status
    assert_equal "refund", refund.object
  end

  def test_create_refund
    stub_api_request(
      :post,
      "/v1/refunds",
      "refund.json"
    )

    refund = Frame::Refund.create(
      charge: "ch_1234567890abcdef",
      amount: 5000
    )

    assert_equal "rf_1234567890abcdef", refund.id
    assert_equal 5000, refund.amount
    assert_equal "usd", refund.currency
    assert_equal "refund", refund.object
  end

  def test_list_refunds
    stub_api_request(
      :get,
      "/v1/refunds",
      "refunds_list.json"
    )

    refunds = Frame::Refund.list
    assert_equal 2, refunds.data.size
    assert_equal "rf_1234567890abcdef", refunds.data.first.id
    assert_equal "pending", refunds.data.first.status
    assert_equal "rf_abcdef1234567890", refunds.data.last.id
    assert_equal "succeeded", refunds.data.last.status

    assert_equal false, refunds.has_more?
    assert_equal 1, refunds.instance_variable_get(:@page)
  end

  def test_list_refunds_with_params
    stub_api_request(
      :get,
      "/v1/refunds",
      "refunds_list.json",
      request_params: {page: 1, per_page: 20}
    )

    refunds = Frame::Refund.list(page: 1, per_page: 20)

    assert_equal 2, refunds.data.size
    assert_requested :get, "#{Frame.api_base}/v1/refunds",
      query: {page: 1, per_page: 20},
      times: 1
  end

  def test_cancel_refund
    refund_id = "rf_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/refunds/#{refund_id}",
      "refund.json"
    )

    stub_api_request(
      :post,
      "/v1/refunds/#{refund_id}/cancel",
      "cancelled_refund.json"
    )

    refund = Frame::Refund.retrieve(refund_id)
    cancelled_refund = refund.cancel

    assert_equal refund_id, cancelled_refund.id
    assert_equal "cancelled", cancelled_refund.status

    assert_requested :post, "#{Frame.api_base}/v1/refunds/#{refund_id}/cancel", times: 1
  end
end
