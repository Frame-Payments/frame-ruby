# frozen_string_literal: true

require "test_helper"

class TestPromotionCode < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_create_promotion_code
    stub_api_request(
      :post,
      "/v1/promotion_codes",
      "promotion_code.json"
    )

    promo = Frame::PromotionCode.create(
      code: "SAVE10",
      coupon_id: "cpn_123"
    )
    assert_equal "promo_1234567890abcdef", promo.id
    assert_equal "SAVE10", promo.code
    assert_equal "cpn_123", promo.coupon_id
    assert_equal true, promo.active
    assert_equal "promotion_code", promo.object
  end

  def test_list_promotion_codes
    stub_api_request(
      :get,
      "/v1/promotion_codes",
      "promotion_codes_list.json"
    )

    promos = Frame::PromotionCode.list
    assert_equal 1, promos.data.size
    assert_equal "promo_1234567890abcdef", promos.data.first.id
    assert_equal "SAVE10", promos.data.first.code
    assert_equal "promotion_code", promos.data.first.object
  end

  def test_retrieve_promotion_code
    promo_id = "promo_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/promotion_codes/#{promo_id}",
      "promotion_code.json"
    )

    promo = Frame::PromotionCode.retrieve(promo_id)
    assert_equal promo_id, promo.id
    assert_equal "SAVE10", promo.code
    assert_equal "promotion_code", promo.object
  end

  def test_update_promotion_code
    promo_id = "promo_1234567890abcdef"
    stub_api_request(:get, "/v1/promotion_codes/#{promo_id}", "promotion_code.json")
    stub_api_request(:patch, "/v1/promotion_codes/#{promo_id}", "promotion_code.json")

    promo = Frame::PromotionCode.retrieve(promo_id)
    promo.active = false
    promo.save

    assert_requested :patch, "#{Frame.api_base}/v1/promotion_codes/#{promo_id}", times: 1
  end

  def test_class_update_promotion_code
    promo_id = "promo_1234567890abcdef"
    stub_api_request(:patch, "/v1/promotion_codes/#{promo_id}", "promotion_code.json")

    promo = Frame::PromotionCode.update(promo_id, active: false)
    assert_equal promo_id, promo.id
    assert_requested :patch, "#{Frame.api_base}/v1/promotion_codes/#{promo_id}", times: 1
  end
end
