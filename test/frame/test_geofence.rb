# frozen_string_literal: true

require "test_helper"

class TestGeofence < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_list_geofences
    stub_api_request(
      :get,
      "/v1/geofences",
      "geofences_list.json"
    )

    geofences = Frame::Geofence.list
    assert_equal 1, geofences.data.size
    assert_equal "gf_1234567890abcdef", geofences.data.first.id
    assert_equal "US Only", geofences.data.first.name
    assert_equal "active", geofences.data.first.status
    assert_equal "geofence", geofences.data.first.object
  end
end
