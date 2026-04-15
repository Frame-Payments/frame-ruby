# frozen_string_literal: true

require "test_helper"

class TestAccount < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_retrieve_account
    account_id = "acct_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/accounts/#{account_id}",
      "account.json"
    )

    account = Frame::Account.retrieve(account_id)
    assert_equal account_id, account.id
    assert_equal "individual", account.type
    assert_equal "active", account.status
    assert_equal "account", account.object
  end

  def test_create_account
    stub_api_request(
      :post,
      "/v1/accounts",
      "account.json"
    )

    account = Frame::Account.create(
      type: "individual",
      profile: {
        individual: {
          name: {first_name: "John", last_name: "Doe"},
          email: "john@example.com"
        }
      }
    )

    assert_equal "acct_1234567890abcdef", account.id
    assert_equal "individual", account.type
    assert_equal "account", account.object
  end

  def test_update_account
    account_id = "acct_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/accounts/#{account_id}",
      "account.json"
    )

    stub_api_request(
      :patch,
      "/v1/accounts/#{account_id}",
      "account.json"
    )

    account = Frame::Account.retrieve(account_id)
    account.external_id = "ext_123"
    account.save

    assert_requested :patch, "#{Frame.api_base}/v1/accounts/#{account_id}", times: 1
  end

  def test_disable_account
    account_id = "acct_1234567890abcdef"

    stub_api_request(
      :delete,
      "/v1/accounts/#{account_id}",
      "account.json"
    )

    account = Frame::Account.disable(account_id)
    assert_equal account_id, account.id
    assert_requested :delete, "#{Frame.api_base}/v1/accounts/#{account_id}", times: 1
  end

  def test_list_accounts
    stub_api_request(
      :get,
      "/v1/accounts",
      "accounts_list.json"
    )

    accounts = Frame::Account.list
    assert_equal 2, accounts.data.size
    assert_equal "acct_1234567890abcdef", accounts.data.first.id
    assert_equal "acct_abcdef1234567890", accounts.data.last.id

    assert_equal false, accounts.has_more?
    assert_equal 1, accounts.instance_variable_get(:@page)
  end

  def test_list_accounts_with_params
    stub_api_request(
      :get,
      "/v1/accounts",
      "accounts_list.json",
      request_params: {page: 1, per_page: 20}
    )

    accounts = Frame::Account.list(page: 1, per_page: 20)

    assert_equal 2, accounts.data.size
    assert_requested :get, "#{Frame.api_base}/v1/accounts",
      query: {page: 1, per_page: 20},
      times: 1
  end

  def test_search_accounts
    stub_api_request(
      :get,
      "/v1/accounts/search",
      "accounts_list.json",
      request_params: {type: "individual"}
    )

    accounts = Frame::Account.search(type: "individual")

    assert_equal 2, accounts.data.size
    assert_requested :get, "#{Frame.api_base}/v1/accounts/search",
      query: {type: "individual"},
      times: 1
  end

  def test_restrict_account
    account_id = "acct_1234567890abcdef"

    stub_api_request(
      :post,
      "/v1/accounts/#{account_id}/restrict",
      "account.json"
    )

    account = Frame::Account.restrict(account_id)
    assert_equal account_id, account.id
    assert_requested :post, "#{Frame.api_base}/v1/accounts/#{account_id}/restrict", times: 1
  end

  def test_unrestrict_account
    account_id = "acct_1234567890abcdef"

    stub_api_request(
      :post,
      "/v1/accounts/#{account_id}/unrestrict",
      "account.json"
    )

    account = Frame::Account.unrestrict(account_id)
    assert_equal account_id, account.id
    assert_requested :post, "#{Frame.api_base}/v1/accounts/#{account_id}/unrestrict", times: 1
  end

  def test_plaid_link_token
    account_id = "acct_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/accounts/#{account_id}/plaid_link_token",
      "plaid_link_token.json"
    )

    result = Frame::Account.plaid_link_token(account_id)
    assert_equal "link-sandbox-abc123def456", result.link_token
    assert_requested :get, "#{Frame.api_base}/v1/accounts/#{account_id}/plaid_link_token", times: 1
  end

  def test_payment_methods
    account_id = "acct_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/accounts/#{account_id}/payment_methods",
      "payment_methods_list.json"
    )

    payment_methods = Frame::Account.payment_methods(account_id)
    assert_equal 2, payment_methods.data.size
    assert_requested :get, "#{Frame.api_base}/v1/accounts/#{account_id}/payment_methods", times: 1
  end

  def test_geo_compliance
    account_id = "acct_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/accounts/#{account_id}/geo_compliance",
      "account.json"
    )

    Frame::Account.geo_compliance(account_id)
    assert_requested :get, "#{Frame.api_base}/v1/accounts/#{account_id}/geo_compliance", times: 1
  end
end
