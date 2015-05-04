class Histogram < ActiveRecord::Base
  belongs_to :picture

  # Set this Histogram's dominant hue from given ImageMagick image
    num_colors = 8

    img   = img.quantize(num_colors)
    hist  = img.color_histogram
    simplified_hist = Hash.new{ 0 }

    # Sort 8-color histogram into 18 buckets
    hist.each do |h|
      hsla = h.first.to_hsla
      pos  = (hsla[0].to_i / 20) % 18
      simplified_hist[pos] += h.last
    end

    # Sort by number of times pixel appeared from greatest to least
    sorted = simplified_hist.sort_by { |pos, v| v }.reverse
    self.dominant_hue = sorted.first.first
  end
end
