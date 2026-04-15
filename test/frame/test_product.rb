# frozen_string_literal: true

require "test_helper"

class TestProduct < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_retrieve_product
    product_id = "prod_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/products/#{product_id}",
      "product.json"
    )

    product = Frame::Product.retrieve(product_id)
    assert_equal product_id, product.id
    assert_equal "Premium Plan", product.name
    assert_equal true, product.active
    assert_equal "product", product.object
  end

  def test_create_product
    stub_api_request(
      :post,
      "/v1/products",
      "product.json"
    )

    product = Frame::Product.create(
      name: "Premium Plan",
      description: "A premium subscription plan",
      active: true
    )

    assert_equal "prod_1234567890abcdef", product.id
    assert_equal "Premium Plan", product.name
    assert_equal "product", product.object
  end

  def test_update_product
    product_id = "prod_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/products/#{product_id}",
      "product.json"
    )

    stub_api_request(
      :patch,
      "/v1/products/#{product_id}",
      "product.json"
    )

    product = Frame::Product.retrieve(product_id)
    product.name = "Updated Plan"
    product.save

    assert_requested :patch, "#{Frame.api_base}/v1/products/#{product_id}", times: 1
  end

  def test_list_products
    stub_api_request(
      :get,
      "/v1/products",
      "products_list.json"
    )

    products = Frame::Product.list
    assert_equal 2, products.data.size
    assert_equal "prod_1234567890abcdef", products.data.first.id
    assert_equal "Premium Plan", products.data.first.name
    assert_equal "prod_abcdef1234567890", products.data.last.id
    assert_equal "Basic Plan", products.data.last.name

    assert_equal false, products.has_more?
    assert_equal 1, products.instance_variable_get(:@page)
  end

  def test_list_products_with_params
    stub_api_request(
      :get,
      "/v1/products",
      "products_list.json",
      request_params: {page: 1, per_page: 20}
    )

    products = Frame::Product.list(page: 1, per_page: 20)

    assert_equal 2, products.data.size
    assert_requested :get, "#{Frame.api_base}/v1/products",
      query: {page: 1, per_page: 20},
      times: 1
  end

  def test_delete_product
    product_id = "prod_1234567890abcdef"

    stub_api_request(
      :delete,
      "/v1/products/#{product_id}",
      "deleted_product.json"
    )

    deleted_product = Frame::Product.delete(product_id)

    assert_equal product_id, deleted_product.id
    assert_equal true, deleted_product.deleted
    assert_equal "product", deleted_product.object

    assert_requested :delete, "#{Frame.api_base}/v1/products/#{product_id}", times: 1
  end

  def test_search_products
    stub_api_request(
      :get,
      "/v1/products/search",
      "search_products.json",
      request_params: {name: "Test"}
    )

    products = Frame::Product.search(name: "Test")

    assert_equal 1, products.data.size
    assert_equal "Test Product", products.data.first.name

    assert_requested :get, "#{Frame.api_base}/v1/products/search",
      query: {name: "Test"},
      times: 1
  end
end
