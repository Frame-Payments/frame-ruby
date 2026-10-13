# frozen_string_literal: true

require "test_helper"

class TestWallet < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_list_wallets
    stub_api_request(:get, "/v2/wallets", "wallets_list.json")

    wallets = Frame::Wallet.list
    assert_equal 1, wallets.data.size
    assert_kind_of Frame::Wallet, wallets.data.first
    assert_equal "wal_123", wallets.data.first.id
    assert_equal "wallet", wallets.data.first.object
  end

  def test_refresh_uses_v2_path
    stub_api_request(:get, "/v2/wallets/wal_123", "wallet.json")

    wallet = Frame::Wallet.retrieve("wal_123")
    wallet.refresh
    assert_equal "/v2/wallets", Frame::Wallet.resource_url
    assert_requested :get, "#{Frame.api_base}/v2/wallets/wal_123", times: 2
  end

  def test_retrieve_wallet
    stub_api_request(:get, "/v2/wallets/wal_123", "wallet.json")

    wallet = Frame::Wallet.retrieve("wal_123")
    assert_kind_of Frame::Wallet, wallet
    assert_equal "wal_123", wallet.id
    assert_equal "active", wallet.status
    assert_equal true, wallet.default
  end

  def test_retrieve_default_wallet
    stub_api_request(
      :get,
      "/v2/wallets/default",
      "wallet.json",
      request_params: {account_id: "acct_123"}
    )

    wallet = Frame::Wallet.retrieve_default(account_id: "acct_123")
    assert_kind_of Frame::Wallet, wallet
    assert_equal "wal_123", wallet.id
  end

  def test_update_wallet_sends_idempotency_key
    stub_request(:patch, "#{Frame.api_base}/v2/wallets/wal_123")
      .with { |req|
        key = req.headers["Idempotency-Key"]
        !key.nil? && !key.empty?
      }
      .to_return(
        body: fixture("wallet.json"),
        status: 200,
        headers: {"Content-Type" => "application/json"}
      )

    wallet = Frame::Wallet.update("wal_123", name: "Payouts")
    assert_kind_of Frame::Wallet, wallet
    assert_equal "wal_123", wallet.id
  end

  def test_update_wallet_uses_provided_idempotency_key
    stub_request(:patch, "#{Frame.api_base}/v2/wallets/wal_123")
      .with(headers: {"Idempotency-Key" => "my-key-123"})
      .to_return(
        body: fixture("wallet.json"),
        status: 200,
        headers: {"Content-Type" => "application/json"}
      )

    wallet = Frame::Wallet.update("wal_123", {name: "Payouts"}, {idempotency_key: "my-key-123"})
    assert_equal "wal_123", wallet.id
    assert_requested :patch, "#{Frame.api_base}/v2/wallets/wal_123",
      headers: {"Idempotency-Key" => "my-key-123"},
      times: 1
  end
end
