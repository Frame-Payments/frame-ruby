# frozen_string_literal: true

require "test_helper"

class TestCoupon < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_create_coupon
    stub_api_request(
      :post,
      "/v1/coupons",
      "coupon.json"
    )

    coupon = Frame::Coupon.create(
      name: "Test Coupon",
      discount_type: "percentage",
      discount_value: 10
    )
    assert_equal "cpn_1234567890abcdef", coupon.id
    assert_equal "Test Coupon", coupon.name
    assert_equal "percentage", coupon.discount_type
    assert_equal 10, coupon.discount_value
    assert_equal "coupon", coupon.object
  end

  def test_list_coupons
    stub_api_request(
      :get,
      "/v1/coupons",
      "coupons_list.json"
    )

    coupons = Frame::Coupon.list
    assert_equal 2, coupons.data.size
    assert_equal "cpn_1234567890abcdef", coupons.data.first.id
    assert_equal "Test Coupon", coupons.data.first.name
    assert_equal "cpn_abcdef1234567890", coupons.data.last.id
    assert_equal "Test Coupon 2", coupons.data.last.name
  end

  def test_retrieve_coupon
    coupon_id = "cpn_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/coupons/#{coupon_id}",
      "coupon.json"
    )

    coupon = Frame::Coupon.retrieve(coupon_id)
    assert_equal coupon_id, coupon.id
    assert_equal "Test Coupon", coupon.name
    assert_equal "coupon", coupon.object
  end

  def test_update_coupon
    coupon_id = "cpn_1234567890abcdef"
    stub_api_request(:get, "/v1/coupons/#{coupon_id}", "coupon.json")
    stub_api_request(:patch, "/v1/coupons/#{coupon_id}", "coupon.json")

    coupon = Frame::Coupon.retrieve(coupon_id)
    coupon.name = "Updated Coupon"
    coupon.save

    assert_requested :patch, "#{Frame.api_base}/v1/coupons/#{coupon_id}", times: 1
  end

  def test_class_update_coupon
    coupon_id = "cpn_1234567890abcdef"
    stub_api_request(:patch, "/v1/coupons/#{coupon_id}", "coupon.json")

    coupon = Frame::Coupon.update(coupon_id, name: "Updated Coupon")
    assert_equal coupon_id, coupon.id
    assert_requested :patch, "#{Frame.api_base}/v1/coupons/#{coupon_id}", times: 1
  end
end
