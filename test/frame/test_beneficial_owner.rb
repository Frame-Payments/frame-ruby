# frozen_string_literal: true

require "test_helper"

class TestBeneficialOwner < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_list_beneficial_owners
    account_id = "acct_123"
    stub_api_request(
      :get,
      "/v1/accounts/#{account_id}/beneficial_owners",
      "beneficial_owners_list.json"
    )

    response = Frame::BeneficialOwner.list(account_id)
    assert_equal 1, response.data.size
    assert_equal "Janet", response.data.first.first_name
    assert_equal "beneficial_owner", response.data.first.object

    assert_requested :get, "#{Frame.api_base}/v1/accounts/#{account_id}/beneficial_owners", times: 1
  end

  def test_create_beneficial_owner
    account_id = "acct_123"
    stub_api_request(
      :post,
      "/v1/accounts/#{account_id}/beneficial_owners",
      "beneficial_owner.json"
    )

    owner = Frame::BeneficialOwner.create(
      account_id,
      first_name: "Janet",
      last_name: "Jones",
      email: "janet@example.com",
      roles: ["owner", "controller"]
    )
    assert_equal "bo_1234567890abcdef", owner.id
    assert_equal account_id, owner.account_id
    assert_equal "beneficial_owner", owner.object

    assert_requested :post, "#{Frame.api_base}/v1/accounts/#{account_id}/beneficial_owners", times: 1
  end

  def test_retrieve_beneficial_owner
    account_id = "acct_123"
    owner_id = "bo_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/accounts/#{account_id}/beneficial_owners/#{owner_id}",
      "beneficial_owner.json"
    )

    owner = Frame::BeneficialOwner.retrieve(account_id, owner_id)
    assert_equal owner_id, owner.id
    assert_equal "beneficial_owner", owner.object

    assert_requested :get, "#{Frame.api_base}/v1/accounts/#{account_id}/beneficial_owners/#{owner_id}", times: 1
  end

  def test_update_beneficial_owner
    account_id = "acct_123"
    owner_id = "bo_1234567890abcdef"
    stub_api_request(
      :patch,
      "/v1/accounts/#{account_id}/beneficial_owners/#{owner_id}",
      "beneficial_owner.json"
    )

    owner = Frame::BeneficialOwner.update(account_id, owner_id, percent_ownership: 40)
    assert_equal owner_id, owner.id

    assert_requested :patch, "#{Frame.api_base}/v1/accounts/#{account_id}/beneficial_owners/#{owner_id}", times: 1
  end

  def test_delete_beneficial_owner
    account_id = "acct_123"
    owner_id = "bo_1234567890abcdef"
    stub_api_request(
      :delete,
      "/v1/accounts/#{account_id}/beneficial_owners/#{owner_id}",
      "empty.json",
      status: 204
    )

    Frame::BeneficialOwner.delete(account_id, owner_id)

    assert_requested :delete, "#{Frame.api_base}/v1/accounts/#{account_id}/beneficial_owners/#{owner_id}", times: 1
  end

  def test_confirm_roster
    account_id = "acct_123"
    stub_api_request(
      :post,
      "/v1/accounts/#{account_id}/beneficial_owners/confirm",
      "account.json"
    )

    account = Frame::BeneficialOwner.confirm_roster(account_id)
    assert_equal "account", account.object

    assert_requested :post, "#{Frame.api_base}/v1/accounts/#{account_id}/beneficial_owners/confirm", times: 1
  end

  def test_resend_invite
    account_id = "acct_123"
    owner_id = "bo_1234567890abcdef"
    stub_api_request(
      :post,
      "/v1/accounts/#{account_id}/beneficial_owners/#{owner_id}/resend_invite",
      "beneficial_owner.json"
    )

    owner = Frame::BeneficialOwner.resend_invite(account_id, owner_id)
    assert_equal owner_id, owner.id

    assert_requested :post, "#{Frame.api_base}/v1/accounts/#{account_id}/beneficial_owners/#{owner_id}/resend_invite", times: 1
  end
end
