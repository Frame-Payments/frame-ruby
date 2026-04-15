# frozen_string_literal: true

require "test_helper"

class TestDiscount < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_list_discounts
    stub_api_request(
      :get,
      "/v1/discounts",
      "discounts_list.json"
    )

    discounts = Frame::Discount.list
    assert_equal 1, discounts.data.size
    assert_equal "disc_1234567890abcdef", discounts.data.first.id
    assert_equal "cpn_123", discounts.data.first.coupon_id
    assert_equal "discount", discounts.data.first.object
  end

  def test_retrieve_discount
    discount_id = "disc_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/discounts/#{discount_id}",
      "discount.json"
    )

    discount = Frame::Discount.retrieve(discount_id)
    assert_equal discount_id, discount.id
    assert_equal "cpn_123", discount.coupon_id
    assert_equal "cus_123", discount.customer_id
    assert_equal "discount", discount.object
  end

  def test_validate_discounts
    stub_api_request(
      :post,
      "/v1/discounts/validate",
      "validated_discounts.json"
    )

    result = Frame::Discount.validate(coupon_ids: ["cpn_123"])
    assert_equal 1, result.data.size
    assert_equal true, result.data.first.valid

    assert_requested :post, "#{Frame.api_base}/v1/discounts/validate", times: 1
  end
end
