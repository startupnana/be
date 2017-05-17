require 'test_helper'

class MpsynthCoordinatesTest < ActiveSupport::TestCase
  test "Coordinates translation works for 1024 x 512 pictures" do
    coordinates = MpsynthCoordinates.new(1024, 512)

    assert_equal -0.5, coordinates.denormalize_x(0)
    assert_equal 1.5, coordinates.denormalize_x(1024)
    assert_equal 0, coordinates.denormalize_y(512)
    assert_equal 1, coordinates.denormalize_y(0)

    assert_equal 0, coordinates.normalize_x(-0.5)
    assert_equal 1024, coordinates.normalize_x(1.5)
    assert_equal 512, coordinates.normalize_y(0)
    assert_equal 0, coordinates.normalize_y(1)
  end

  test "Center is always at 0.5 0.5" do
    [[512, 1024], [4096, 512], [2048, 2048]].each do |image_dim|
      coordinates = MpsynthCoordinates.new(image_dim.first, image_dim.second)
      assert_equal 0.5, coordinates.denormalize_x(image_dim.first / 2)
      assert_equal 0.5, coordinates.denormalize_y(image_dim.second / 2)

      assert_equal image_dim.first / 2, coordinates.normalize_x(0.5)
      assert_equal image_dim.second / 2, coordinates.normalize_y(0.5)
    end
  end

  test "Coordinates translation works for 512 x 1024 pictures" do
    coordinates = MpsynthCoordinates.new(512, 1024)

    assert_equal 0.25, coordinates.denormalize_x(0)
    assert_equal 0.75, coordinates.denormalize_x(512)
    assert_equal 0, coordinates.denormalize_y(1024)
    assert_equal 1, coordinates.denormalize_y(0)

    assert_equal 0, coordinates.normalize_x(0.25)
    assert_equal 512, coordinates.normalize_x(0.75)
    assert_equal 1024, coordinates.normalize_y(0)
    assert_equal 0, coordinates.normalize_y(1)
  end
end
