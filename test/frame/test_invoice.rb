# frozen_string_literal: true

require "test_helper"

class TestInvoice < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_retrieve_invoice
    invoice_id = "inv_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/invoices/#{invoice_id}",
      "invoice.json"
    )

    invoice = Frame::Invoice.retrieve(invoice_id)
    assert_equal invoice_id, invoice.id
    assert_equal "draft", invoice.status
    assert_equal 10000, invoice.total
    assert_equal "usd", invoice.currency
    assert_equal "invoice", invoice.object
  end

  def test_create_invoice
    stub_api_request(
      :post,
      "/v1/invoices",
      "invoice.json"
    )

    invoice = Frame::Invoice.create(
      customer: "55435398-ec47-4bb4-ac9e-64031481cf48",
      total: 10000,
      currency: "usd"
    )

    assert_equal "inv_1234567890abcdef", invoice.id
    assert_equal "draft", invoice.status
    assert_equal 10000, invoice.total
    assert_equal "invoice", invoice.object
  end

  def test_update_invoice
    invoice_id = "inv_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/invoices/#{invoice_id}",
      "invoice.json"
    )

    stub_api_request(
      :patch,
      "/v1/invoices/#{invoice_id}",
      "invoice.json"
    )

    invoice = Frame::Invoice.retrieve(invoice_id)
    invoice.total = 15000
    invoice.save

    assert_requested :patch, "#{Frame.api_base}/v1/invoices/#{invoice_id}", times: 1
  end

  def test_list_invoices
    stub_api_request(
      :get,
      "/v1/invoices",
      "invoices_list.json"
    )

    invoices = Frame::Invoice.list
    assert_equal 2, invoices.data.size
    assert_equal "inv_1234567890abcdef", invoices.data.first.id
    assert_equal "draft", invoices.data.first.status
    assert_equal "inv_abcdef1234567890", invoices.data.last.id
    assert_equal "paid", invoices.data.last.status

    assert_equal false, invoices.has_more?
    assert_equal 1, invoices.instance_variable_get(:@page)
  end

  def test_list_invoices_with_params
    stub_api_request(
      :get,
      "/v1/invoices",
      "invoices_list.json",
      request_params: {page: 1, per_page: 20}
    )

    invoices = Frame::Invoice.list(page: 1, per_page: 20)

    assert_equal 2, invoices.data.size
    assert_requested :get, "#{Frame.api_base}/v1/invoices",
      query: {page: 1, per_page: 20},
      times: 1
  end

  def test_issue_invoice
    invoice_id = "inv_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/invoices/#{invoice_id}",
      "invoice.json"
    )

    stub_api_request(
      :post,
      "/v1/invoices/#{invoice_id}/issue",
      "finalized_invoice.json"
    )

    invoice = Frame::Invoice.retrieve(invoice_id)
    issued = invoice.issue

    assert_equal invoice_id, issued.id
    assert_equal "open", issued.status

    assert_requested :post, "#{Frame.api_base}/v1/invoices/#{invoice_id}/issue", times: 1
  end

  def test_delete_invoice
    invoice_id = "inv_1234567890abcdef"

    stub_api_request(
      :delete,
      "/v1/invoices/#{invoice_id}",
      "deleted_invoice.json"
    )

    deleted_invoice = Frame::Invoice.delete(invoice_id)

    assert_equal invoice_id, deleted_invoice.id
    assert_equal true, deleted_invoice.deleted
    assert_equal "invoice", deleted_invoice.object

    assert_requested :delete, "#{Frame.api_base}/v1/invoices/#{invoice_id}", times: 1
  end
end
