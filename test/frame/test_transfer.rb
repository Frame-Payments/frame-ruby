# frozen_string_literal: true

require "test_helper"

class TestTransfer < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_create_transfer
    stub_api_request(
      :post,
      "/v1/transfers",
      "transfer.json"
    )

    transfer = Frame::Transfer.create(
      amount: 10000,
      currency: "usd",
      account_id: "acct_123"
    )
    assert_equal "tr_1234567890abcdef", transfer.id
    assert_equal 10000, transfer.amount
    assert_equal "usd", transfer.currency
    assert_equal "pending", transfer.status
    assert_equal "transfer", transfer.object
  end

  def test_list_transfers
    stub_api_request(
      :get,
      "/v1/transfers",
      "transfers_list.json"
    )

    transfers = Frame::Transfer.list
    assert_equal 1, transfers.data.size
    assert_equal "tr_1234567890abcdef", transfers.data.first.id
    assert_equal "transfer", transfers.data.first.object
  end

  def test_retrieve_transfer
    transfer_id = "tr_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/transfers/#{transfer_id}",
      "transfer.json"
    )

    transfer = Frame::Transfer.retrieve(transfer_id)
    assert_equal transfer_id, transfer.id
    assert_equal 10000, transfer.amount
    assert_equal "usd", transfer.currency
    assert_equal "transfer", transfer.object
  end

  def test_confirm_transfer_class_method
    transfer_id = "tr_1234567890abcdef"
    stub_api_request(:post, "/v1/transfers/#{transfer_id}/confirm", "transfer.json")

    transfer = Frame::Transfer.confirm(transfer_id)
    assert_equal transfer_id, transfer.id
    assert_requested :post, "#{Frame.api_base}/v1/transfers/#{transfer_id}/confirm", times: 1
  end

  def test_confirm_transfer_instance_method
    transfer_id = "tr_1234567890abcdef"
    stub_api_request(:get, "/v1/transfers/#{transfer_id}", "transfer.json")
    stub_api_request(:post, "/v1/transfers/#{transfer_id}/confirm", "transfer.json")

    transfer = Frame::Transfer.retrieve(transfer_id)
    confirmed = transfer.confirm
    assert_equal transfer_id, confirmed.id
    assert_requested :post, "#{Frame.api_base}/v1/transfers/#{transfer_id}/confirm", times: 1
  end
end
