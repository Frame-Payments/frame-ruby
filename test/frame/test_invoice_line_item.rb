# frozen_string_literal: true

require "test_helper"

class TestInvoiceLineItem < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_retrieve_invoice_line_item
    invoice_id = "inv_1234567890abcdef"
    line_item_id = "ili_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/invoices/#{invoice_id}/line_items/#{line_item_id}",
      "invoice_line_item.json"
    )

    line_item = Frame::InvoiceLineItem.retrieve(invoice_id, line_item_id)
    assert_equal line_item_id, line_item.id
    assert_equal 10000, line_item.unit_amount
    assert_equal 1, line_item.quantity
    assert_equal "invoice_line_item", line_item.object
  end

  def test_create_invoice_line_item
    invoice_id = "inv_1234567890abcdef"
    stub_api_request(
      :post,
      "/v1/invoices/#{invoice_id}/line_items",
      "invoice_line_item.json"
    )

    line_item = Frame::InvoiceLineItem.create(
      invoice_id,
      description: "Product or service description",
      quantity: 1,
      unit_amount: 10000
    )

    assert_equal "ili_1234567890abcdef", line_item.id
    assert_equal 10000, line_item.unit_amount
    assert_equal "invoice_line_item", line_item.object
  end

  def test_update_invoice_line_item
    invoice_id = "inv_1234567890abcdef"
    line_item_id = "ili_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/invoices/#{invoice_id}/line_items/#{line_item_id}",
      "invoice_line_item.json"
    )

    stub_api_request(
      :patch,
      "/v1/invoices/#{invoice_id}/line_items/#{line_item_id}",
      "invoice_line_item.json"
    )

    line_item = Frame::InvoiceLineItem.retrieve(invoice_id, line_item_id)
    line_item.quantity = 2
    line_item.save

    assert_requested :patch, "#{Frame.api_base}/v1/invoices/#{invoice_id}/line_items/#{line_item_id}", times: 1
  end

  def test_list_invoice_line_items
    invoice_id = "inv_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/invoices/#{invoice_id}/line_items",
      "invoice_line_items_list.json"
    )

    line_items = Frame::InvoiceLineItem.list(invoice_id)
    assert_equal 2, line_items.data.size
    assert_equal "ili_1234567890abcdef", line_items.data.first.id
    assert_equal "ili_abcdef1234567890", line_items.data.last.id

    assert_equal false, line_items.has_more?
    assert_equal 1, line_items.instance_variable_get(:@page)
  end

  def test_list_invoice_line_items_with_params
    invoice_id = "inv_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/invoices/#{invoice_id}/line_items",
      "invoice_line_items_list.json",
      request_params: {page: 1, per_page: 20}
    )

    line_items = Frame::InvoiceLineItem.list(invoice_id, page: 1, per_page: 20)

    assert_equal 2, line_items.data.size
    assert_requested :get, "#{Frame.api_base}/v1/invoices/#{invoice_id}/line_items",
      query: {page: 1, per_page: 20},
      times: 1
  end

  def test_delete_invoice_line_item
    invoice_id = "inv_1234567890abcdef"
    line_item_id = "ili_1234567890abcdef"

    stub_api_request(
      :delete,
      "/v1/invoices/#{invoice_id}/line_items/#{line_item_id}",
      "deleted_invoice_line_item.json"
    )

    deleted_line_item = Frame::InvoiceLineItem.delete(invoice_id, line_item_id)

    assert_equal line_item_id, deleted_line_item.id
    assert_equal true, deleted_line_item.deleted
    assert_equal "invoice_line_item", deleted_line_item.object

    assert_requested :delete, "#{Frame.api_base}/v1/invoices/#{invoice_id}/line_items/#{line_item_id}", times: 1
  end

  def test_class_update_invoice_line_item
    invoice_id = "inv_1234567890abcdef"
    line_item_id = "ili_1234567890abcdef"

    stub_api_request(
      :patch,
      "/v1/invoices/#{invoice_id}/line_items/#{line_item_id}",
      "invoice_line_item.json"
    )

    line_item = Frame::InvoiceLineItem.update(invoice_id, line_item_id, quantity: 2)
    assert_equal line_item_id, line_item.id
    assert_requested :patch, "#{Frame.api_base}/v1/invoices/#{invoice_id}/line_items/#{line_item_id}", times: 1
  end
end
