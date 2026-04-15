# frozen_string_literal: true

require "test_helper"

class TestTransferFeePlan < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_create_transfer_fee_plan
    stub_api_request(
      :post,
      "/v1/transfer_fee_plans",
      "transfer_fee_plan.json"
    )

    plan = Frame::TransferFeePlan.create(
      name: "Standard Plan",
      fee_application_mode: "per_transaction"
    )
    assert_equal "tfp_1234567890abcdef", plan.id
    assert_equal "Standard Plan", plan.name
    assert_equal "per_transaction", plan.fee_application_mode
    assert_equal "transfer_fee_plan", plan.object
  end

  def test_list_transfer_fee_plans
    stub_api_request(
      :get,
      "/v1/transfer_fee_plans",
      "transfer_fee_plans_list.json"
    )

    plans = Frame::TransferFeePlan.list
    assert_equal 1, plans.data.size
    assert_equal "tfp_1234567890abcdef", plans.data.first.id
    assert_equal "Standard Plan", plans.data.first.name
    assert_equal "transfer_fee_plan", plans.data.first.object
  end

  def test_retrieve_transfer_fee_plan
    plan_id = "tfp_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/transfer_fee_plans/#{plan_id}",
      "transfer_fee_plan.json"
    )

    plan = Frame::TransferFeePlan.retrieve(plan_id)
    assert_equal plan_id, plan.id
    assert_equal "Standard Plan", plan.name
    assert_equal "transfer_fee_plan", plan.object
  end
end
