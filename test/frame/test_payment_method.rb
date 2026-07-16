# frozen_string_literal: true

require "test_helper"

class TestPaymentMethod < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_retrieve_payment_method
    payment_method_id = "pm_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/payment_methods/#{payment_method_id}",
      "payment_method.json"
    )

    payment_method = Frame::PaymentMethod.retrieve(payment_method_id)
    assert_equal payment_method_id, payment_method.id
    assert_equal "card", payment_method.type
    assert_equal "visa", payment_method.card[:brand]
    assert_equal "payment_method", payment_method.object
  end

  def test_create_payment_method
    stub_api_request(
      :post,
      "/v1/payment_methods",
      "payment_method.json"
    )

    payment_method = Frame::PaymentMethod.create(
      type: "card",
      card: {
        number: "4242424242424242",
        exp_month: 12,
        exp_year: 2025
      }
    )

    assert_equal "pm_1234567890abcdef", payment_method.id
    assert_equal "card", payment_method.type
    assert_equal "payment_method", payment_method.object
  end

  def test_update_payment_method
    payment_method_id = "pm_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/payment_methods/#{payment_method_id}",
      "payment_method.json"
    )

    stub_api_request(
      :patch,
      "/v1/payment_methods/#{payment_method_id}",
      "payment_method.json"
    )

    payment_method = Frame::PaymentMethod.retrieve(payment_method_id)
    payment_method.save(metadata: {key: "value"})

    assert_requested :patch, "#{Frame.api_base}/v1/payment_methods/#{payment_method_id}", times: 1
  end

  def test_list_payment_methods
    stub_api_request(
      :get,
      "/v1/payment_methods",
      "payment_methods_list.json"
    )

    payment_methods = Frame::PaymentMethod.list
    assert_equal 2, payment_methods.data.size
    assert_equal "pm_1234567890abcdef", payment_methods.data.first.id
    assert_equal "visa", payment_methods.data.first.card[:brand]
    assert_equal "pm_abcdef1234567890", payment_methods.data.last.id
    assert_equal "mastercard", payment_methods.data.last.card[:brand]

    assert_equal false, payment_methods.has_more?
    assert_equal 1, payment_methods.instance_variable_get(:@page)
  end

  def test_list_payment_methods_with_params
    stub_api_request(
      :get,
      "/v1/payment_methods",
      "payment_methods_list.json",
      request_params: {page: 1, per_page: 20}
    )

    payment_methods = Frame::PaymentMethod.list(page: 1, per_page: 20)

    assert_equal 2, payment_methods.data.size
    assert_requested :get, "#{Frame.api_base}/v1/payment_methods",
      query: {page: 1, per_page: 20},
      times: 1
  end

  def test_attach_payment_method
    payment_method_id = "pm_1234567890abcdef"
    customer_id = "55435398-ec47-4bb4-ac9e-64031481cf48"

    stub_api_request(
      :get,
      "/v1/payment_methods/#{payment_method_id}",
      "payment_method.json"
    )

    stub_api_request(
      :post,
      "/v1/payment_methods/#{payment_method_id}/attach",
      "attached_payment_method.json"
    )

    payment_method = Frame::PaymentMethod.retrieve(payment_method_id)
    attached = payment_method.attach(customer_id)

    assert_equal payment_method_id, attached.id
    assert_equal customer_id, attached.customer

    assert_requested :post, "#{Frame.api_base}/v1/payment_methods/#{payment_method_id}/attach", times: 1
  end

  def test_detach_payment_method
    payment_method_id = "pm_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/payment_methods/#{payment_method_id}",
      "attached_payment_method.json"
    )

    stub_api_request(
      :post,
      "/v1/payment_methods/#{payment_method_id}/detach",
      "payment_method.json"
    )

    payment_method = Frame::PaymentMethod.retrieve(payment_method_id)
    detached = payment_method.detach

    assert_equal payment_method_id, detached.id

    assert_requested :post, "#{Frame.api_base}/v1/payment_methods/#{payment_method_id}/detach", times: 1
  end

  def test_block_payment_method
    payment_method_id = "pm_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/payment_methods/#{payment_method_id}",
      "payment_method.json"
    )

    stub_api_request(
      :post,
      "/v1/payment_methods/#{payment_method_id}/block",
      "payment_method.json"
    )

    payment_method = Frame::PaymentMethod.retrieve(payment_method_id)
    blocked = payment_method.block

    assert_equal payment_method_id, blocked.id
    assert_requested :post, "#{Frame.api_base}/v1/payment_methods/#{payment_method_id}/block", times: 1
  end

  def test_unblock_payment_method
    payment_method_id = "pm_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/payment_methods/#{payment_method_id}",
      "payment_method.json"
    )

    stub_api_request(
      :post,
      "/v1/payment_methods/#{payment_method_id}/unblock",
      "payment_method.json"
    )

    payment_method = Frame::PaymentMethod.retrieve(payment_method_id)
    unblocked = payment_method.unblock

    assert_equal payment_method_id, unblocked.id
    assert_requested :post, "#{Frame.api_base}/v1/payment_methods/#{payment_method_id}/unblock", times: 1
  end

  def test_connect_plaid
    stub_api_request(
      :post,
      "/v1/payment_methods/connect_plaid",
      "payment_method.json"
    )

    payment_method = Frame::PaymentMethod.connect_plaid(
      account: "acct_123",
      public_token: "public-sandbox-abc123",
      account_id: "plaid_acct_456"
    )

    assert_equal "pm_1234567890abcdef", payment_method.id
    assert_equal "payment_method", payment_method.object
    assert_requested :post, "#{Frame.api_base}/v1/payment_methods/connect_plaid", times: 1
  end

  def test_class_update_payment_method
    payment_method_id = "pm_1234567890abcdef"

    stub_api_request(
      :patch,
      "/v1/payment_methods/#{payment_method_id}",
      "payment_method.json"
    )

    payment_method = Frame::PaymentMethod.update(payment_method_id, metadata: {key: "value"})
    assert_equal payment_method_id, payment_method.id
    assert_requested :patch, "#{Frame.api_base}/v1/payment_methods/#{payment_method_id}", times: 1
  end
end
