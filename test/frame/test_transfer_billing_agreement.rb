# frozen_string_literal: true

require "test_helper"

class TestTransferBillingAgreement < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_create_transfer_billing_agreement
    stub_api_request(
      :post,
      "/v1/transfer_billing_agreements",
      "transfer_billing_agreement.json"
    )

    agreement = Frame::TransferBillingAgreement.create(
      transfer_fee_plan_id: "tfp_123",
      account_id: "acct_123"
    )
    assert_equal "tba_1234567890abcdef", agreement.id
    assert_equal "tfp_123", agreement.transfer_fee_plan_id
    assert_equal "acct_123", agreement.account_id
    assert_equal "active", agreement.status
    assert_equal "transfer_billing_agreement", agreement.object
  end

  def test_list_transfer_billing_agreements
    stub_api_request(
      :get,
      "/v1/transfer_billing_agreements",
      "transfer_billing_agreements_list.json"
    )

    agreements = Frame::TransferBillingAgreement.list
    assert_equal 1, agreements.data.size
    assert_equal "tba_1234567890abcdef", agreements.data.first.id
    assert_equal "transfer_billing_agreement", agreements.data.first.object
  end

  def test_retrieve_transfer_billing_agreement
    agreement_id = "tba_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/transfer_billing_agreements/#{agreement_id}",
      "transfer_billing_agreement.json"
    )

    agreement = Frame::TransferBillingAgreement.retrieve(agreement_id)
    assert_equal agreement_id, agreement.id
    assert_equal "active", agreement.status
    assert_equal "transfer_billing_agreement", agreement.object
  end

  def test_update_transfer_billing_agreement
    agreement_id = "tba_1234567890abcdef"
    stub_api_request(:get, "/v1/transfer_billing_agreements/#{agreement_id}", "transfer_billing_agreement.json")
    stub_api_request(:patch, "/v1/transfer_billing_agreements/#{agreement_id}", "transfer_billing_agreement.json")

    agreement = Frame::TransferBillingAgreement.retrieve(agreement_id)
    agreement.status = "inactive"
    agreement.save

    assert_requested :patch, "#{Frame.api_base}/v1/transfer_billing_agreements/#{agreement_id}", times: 1
  end
end
