# frozen_string_literal: true

require "test_helper"

class TestTransferV2 < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def stub_v2_create(idempotency_key: nil)
    headers = {
      "Authorization" => "Bearer #{TEST_API_KEY}",
      "Content-Type" => "application/json"
    }
    if idempotency_key
      headers["Idempotency-Key"] = idempotency_key
    end

    stub = stub_request(:post, "#{Frame.api_base}/v2/transfers")
      .with { |req|
        key = req.headers["Idempotency-Key"]
        next false if key.nil? || key.empty?
        next false if idempotency_key && key != idempotency_key
        true
      }
      .to_return(
        body: fixture("transfer_v2.json"),
        status: 200,
        headers: {"Content-Type" => "application/json"}
      )
    stub
  end

  def test_create_transfer_v2_auto_idempotency_key
    stub_v2_create

    transfer = Frame::TransferV2.create(
      amount: {value: 10000, currency: "usd"},
      source: {payment_method_id: "pm_src_123"}
    )
    assert_kind_of Frame::TransferV2, transfer
    assert_equal "tr_v2_1234567890abcdef", transfer.id
    assert_equal 10000, transfer.amount[:value]
    assert_equal "usd", transfer.amount[:currency]
    assert_equal "pending", transfer.status
    assert_requested :post, "#{Frame.api_base}/v2/transfers", times: 1
  end

  def test_create_transfer_v2_provided_idempotency_key
    stub_v2_create(idempotency_key: "my-key-123")

    transfer = Frame::TransferV2.create(
      {amount: {value: 10000, currency: "usd"}},
      {idempotency_key: "my-key-123"}
    )
    assert_equal "tr_v2_1234567890abcdef", transfer.id
    assert_requested :post, "#{Frame.api_base}/v2/transfers",
      headers: {"Idempotency-Key" => "my-key-123"},
      times: 1
  end

  def test_list_transfers_v2
    stub_api_request(:get, "/v2/transfers", "transfers_v2_list.json")

    transfers = Frame::TransferV2.list
    assert_equal 1, transfers.data.size
    assert_kind_of Frame::TransferV2, transfers.data.first
    assert_equal "tr_v2_1234567890abcdef", transfers.data.first.id
  end

  def test_retrieve_transfer_v2
    transfer_id = "tr_v2_1234567890abcdef"
    stub_api_request(:get, "/v2/transfers/#{transfer_id}", "transfer_v2.json")

    transfer = Frame::TransferV2.retrieve(transfer_id)
    assert_kind_of Frame::TransferV2, transfer
    assert_equal transfer_id, transfer.id
    assert_equal "tr_v2_1234567890abcdef_secret_abc", transfer.client_secret
  end

  def test_update_transfer_v2
    transfer_id = "tr_v2_1234567890abcdef"
    stub_api_request(:patch, "/v2/transfers/#{transfer_id}", "transfer_v2.json")

    transfer = Frame::TransferV2.update(transfer_id, description: "updated")
    assert_equal transfer_id, transfer.id
    assert_requested :patch, "#{Frame.api_base}/v2/transfers/#{transfer_id}", times: 1
  end

  def test_confirm_transfer_v2_class_method
    transfer_id = "tr_v2_1234567890abcdef"
    stub_api_request(:post, "/v2/transfers/#{transfer_id}/confirm", "transfer_v2.json")

    transfer = Frame::TransferV2.confirm(transfer_id)
    assert_equal transfer_id, transfer.id
    assert_requested :post, "#{Frame.api_base}/v2/transfers/#{transfer_id}/confirm", times: 1
  end

  def test_confirm_transfer_v2_instance_method
    transfer_id = "tr_v2_1234567890abcdef"
    stub_api_request(:get, "/v2/transfers/#{transfer_id}", "transfer_v2.json")
    stub_api_request(:post, "/v2/transfers/#{transfer_id}/confirm", "transfer_v2.json")

    transfer = Frame::TransferV2.retrieve(transfer_id)
    confirmed = transfer.confirm
    assert_equal transfer_id, confirmed.id
  end

  def test_capture_transfer_v2
    transfer_id = "tr_v2_1234567890abcdef"
    stub_api_request(:post, "/v2/transfers/#{transfer_id}/capture", "transfer_v2.json")

    transfer = Frame::TransferV2.capture(transfer_id, amount: {value: 5000, currency: "usd"})
    assert_equal transfer_id, transfer.id
  end

  def test_void_transfer_v2
    transfer_id = "tr_v2_1234567890abcdef"
    stub_api_request(:post, "/v2/transfers/#{transfer_id}/void", "transfer_v2.json")

    transfer = Frame::TransferV2.void(transfer_id)
    assert_equal transfer_id, transfer.id
  end

  def test_refund_transfer_v2
    transfer_id = "tr_v2_1234567890abcdef"
    stub_api_request(:post, "/v2/transfers/#{transfer_id}/refund", "transfer_v2.json")

    transfer = Frame::TransferV2.refund(transfer_id, amount: {value: 2500, currency: "usd"})
    assert_equal transfer_id, transfer.id
  end
end
