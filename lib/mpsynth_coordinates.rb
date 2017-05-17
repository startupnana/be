## This class convert coordinates from pixel model  to mpsynth model.

# In case out image is 1024 x 512
#   y
#    ^          . (1.5, 1)
#    |
#    |     .      (0.5, 0.5)
#    |
#    |___________> x
#(-0.5,0)
#
# In case our image is 512 x 1024
#   y
#    ^          .    (0.75, 1)
#    |
#    |     .         (0.5,0.5)
#    |
#    |___________> x
#(0.25,0)
#


class MpsynthCoordinates
  def initialize width, height
    @width = width.to_f
    @height = height.to_f
  end

  def denormalize_x x
    (x.to_f / @width) / (@height / @width) + ((@height - @width) / @height) / 2
  end

  def denormalize_y y
    y = @height - y
    y.to_f / @height  # top left => bottom left and 0-1 scale
  end

    #convert to pixel coordinates
  def normalize_x x
    (x.to_f + ((@width - @height) / @height) / 2)  * @width /  (@width/@height)
  end

  def normalize_y y
    y = y.to_f * @height
    @height - y
  end
end
