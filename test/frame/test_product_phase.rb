# frozen_string_literal: true

require "test_helper"

class TestProductPhase < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_retrieve_product_phase
    phase_id = "pph_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/product_phases/#{phase_id}",
      "product_phase.json"
    )

    phase = Frame::ProductPhase.retrieve(phase_id)
    assert_equal phase_id, phase.id
    assert_equal 10000, phase.price
    assert_equal "usd", phase.currency
    assert_equal "month", phase.interval
    assert_equal "product_phase", phase.object
  end

  def test_create_product_phase
    stub_api_request(
      :post,
      "/v1/product_phases",
      "product_phase.json"
    )

    phase = Frame::ProductPhase.create(
      product: "prod_1234567890abcdef",
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
    phase_id = "pph_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/product_phases/#{phase_id}",
      "product_phase.json"
    )

    stub_api_request(
      :patch,
      "/v1/product_phases/#{phase_id}",
      "product_phase.json"
    )

    phase = Frame::ProductPhase.retrieve(phase_id)
    phase.price = 15000
    phase.save

    assert_requested :patch, "#{Frame.api_base}/v1/product_phases/#{phase_id}", times: 1
  end

  def test_list_product_phases
    stub_api_request(
      :get,
      "/v1/product_phases",
      "product_phases_list.json"
    )

    phases = Frame::ProductPhase.list
    assert_equal 2, phases.data.size
    assert_equal "pph_1234567890abcdef", phases.data.first.id
    assert_equal "month", phases.data.first.interval
    assert_equal "pph_abcdef1234567890", phases.data.last.id
    assert_equal "year", phases.data.last.interval

    assert_equal false, phases.has_more?
    assert_equal 1, phases.instance_variable_get(:@page)
  end

  def test_list_product_phases_with_params
    stub_api_request(
      :get,
      "/v1/product_phases",
      "product_phases_list.json",
      request_params: {page: 1, per_page: 20}
    )

    phases = Frame::ProductPhase.list(page: 1, per_page: 20)

    assert_equal 2, phases.data.size
    assert_requested :get, "#{Frame.api_base}/v1/product_phases",
      query: {page: 1, per_page: 20},
      times: 1
  end

  def test_delete_product_phase
    phase_id = "pph_1234567890abcdef"

    stub_api_request(
      :delete,
      "/v1/product_phases/#{phase_id}",
      "deleted_product_phase.json"
    )

    deleted_phase = Frame::ProductPhase.delete(phase_id)

    assert_equal phase_id, deleted_phase.id
    assert_equal true, deleted_phase.deleted
    assert_equal "product_phase", deleted_phase.object

    assert_requested :delete, "#{Frame.api_base}/v1/product_phases/#{phase_id}", times: 1
  end
end
