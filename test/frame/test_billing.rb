# frozen_string_literal: true

require "test_helper"

class TestBilling < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_create_metering
    stub_api_request(
      :post,
      "/v1/billing/metering",
      "billing_metering.json"
    )

    metering = Frame::Billing.create_metering(name: "api_calls")
    assert_equal "met_1234567890abcdef", metering.id
    assert_equal "api_calls", metering.name

    assert_requested :post, "#{Frame.api_base}/v1/billing/metering", times: 1
  end

  def test_get_metering
    metering_id = "met_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/billing/metering/#{metering_id}",
      "billing_metering.json"
    )

    metering = Frame::Billing.get_metering(metering_id)
    assert_equal metering_id, metering.id
    assert_equal "api_calls", metering.name

    assert_requested :get, "#{Frame.api_base}/v1/billing/metering/#{metering_id}", times: 1
  end

  def test_create_metering_event
    stub_api_request(
      :post,
      "/v1/billing/metering_events",
      "billing_metering_event.json"
    )

    event = Frame::Billing.create_metering_event(
      metering_id: "met_123",
      quantity: 1
    )
    assert_equal "mev_1234567890abcdef", event.id

    assert_requested :post, "#{Frame.api_base}/v1/billing/metering_events", times: 1
  end

  def test_create_billing_credit
    stub_api_request(
      :post,
      "/v1/billing/billing_credit",
      "billing_credit.json"
    )

    credit = Frame::Billing.create_billing_credit(
      amount: 5000,
      currency: "usd"
    )
    assert_equal "bcr_1234567890abcdef", credit.id
    assert_equal 5000, credit.amount

    assert_requested :post, "#{Frame.api_base}/v1/billing/billing_credit", times: 1
  end

  def test_customer_report
    stub_api_request(
      :get,
      "/v1/billing/report/customer",
      "billing_customer_report.json"
    )

    Frame::Billing.customer_report
    assert_requested :get, "#{Frame.api_base}/v1/billing/report/customer", times: 1
  end
end
