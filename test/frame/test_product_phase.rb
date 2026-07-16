# frozen_string_literal: true

require "test_helper"

class TestProductPhase < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_retrieve_product_phase
    product_id = "prod_1234567890abcdef"
    phase_id = "pph_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/products/#{product_id}/phases/#{phase_id}",
      "product_phase.json"
    )

    phase = Frame::ProductPhase.retrieve(product_id, phase_id)
    assert_equal phase_id, phase.id
    assert_equal 10000, phase.price
    assert_equal "usd", phase.currency
    assert_equal "month", phase.interval
    assert_equal "product_phase", phase.object
  end

  def test_create_product_phase
    product_id = "prod_1234567890abcdef"
    stub_api_request(
      :post,
      "/v1/products/#{product_id}/phases",
      "product_phase.json"
    )

    phase = Frame::ProductPhase.create(
      product_id,
      price: 10000,
      currency: "usd",
      interval: "month",
      interval_count: 1
    )

    assert_equal "pph_1234567890abcdef", phase.id
    assert_equal 10000, phase.price
    assert_equal "product_phase", phase.object
  end

  def test_update_product_phase
    product_id = "prod_1234567890abcdef"
    phase_id = "pph_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/products/#{product_id}/phases/#{phase_id}",
      "product_phase.json"
    )

    stub_api_request(
      :patch,
      "/v1/products/#{product_id}/phases/#{phase_id}",
      "product_phase.json"
    )

    phase = Frame::ProductPhase.retrieve(product_id, phase_id)
    phase.price = 15000
    phase.save

    assert_requested :patch, "#{Frame.api_base}/v1/products/#{product_id}/phases/#{phase_id}", times: 1
  end

  def test_list_product_phases
    product_id = "prod_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/products/#{product_id}/phases",
      "product_phases_list.json"
    )

    phases = Frame::ProductPhase.list(product_id)
    assert_equal 2, phases.data.size
    assert_equal "pph_1234567890abcdef", phases.data.first.id
    assert_equal "month", phases.data.first.interval
    assert_equal "pph_abcdef1234567890", phases.data.last.id
    assert_equal "year", phases.data.last.interval

    assert_equal false, phases.has_more?
    assert_equal 1, phases.instance_variable_get(:@page)
  end

  def test_list_product_phases_with_params
    product_id = "prod_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/products/#{product_id}/phases",
      "product_phases_list.json",
      request_params: {page: 1, per_page: 20}
    )

    phases = Frame::ProductPhase.list(product_id, page: 1, per_page: 20)

    assert_equal 2, phases.data.size
    assert_requested :get, "#{Frame.api_base}/v1/products/#{product_id}/phases",
      query: {page: 1, per_page: 20},
      times: 1
  end

  def test_delete_product_phase
    product_id = "prod_1234567890abcdef"
    phase_id = "pph_1234567890abcdef"

    stub_api_request(
      :delete,
      "/v1/products/#{product_id}/phases/#{phase_id}",
      "deleted_product_phase.json"
    )

    deleted_phase = Frame::ProductPhase.delete(product_id, phase_id)

    assert_equal phase_id, deleted_phase.id
    assert_equal true, deleted_phase.deleted
    assert_equal "product_phase", deleted_phase.object

    assert_requested :delete, "#{Frame.api_base}/v1/products/#{product_id}/phases/#{phase_id}", times: 1
  end

  def test_class_update_product_phase
    product_id = "prod_1234567890abcdef"
    phase_id = "pph_1234567890abcdef"

    stub_api_request(
      :patch,
      "/v1/products/#{product_id}/phases/#{phase_id}",
      "product_phase.json"
    )

    phase = Frame::ProductPhase.update(product_id, phase_id, price: 15000)
    assert_equal phase_id, phase.id
    assert_requested :patch, "#{Frame.api_base}/v1/products/#{product_id}/phases/#{phase_id}", times: 1
  end
end
