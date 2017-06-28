require 'opencv'

class ImageAnalyzerService
  include OpenCV
  attr_accessor :brain

  def initialize(image_file)
    @cv_image = image_file
    @brain = NetworkService.instance
  end

  def self.analyze(image_file)
    new(image_file).analyze
  end

  # rubocop:disable Metrics/BlockNesting
  # rubocop:disable Style/For
  def analyze
    boundaries = { width: @cv_image.width - 1, height: @cv_image.height - 1 }

    for threshold_limit in 0..255 do
      threshold_image = @cv_image.threshold(threshold_limit, 255, CV_THRESH_BINARY)

      for x in 0..boundaries[:width] do
        for y in 0..boundaries[:height] do
          point = threshold_image[y, x].to_a
          sum = point.collect(&:to_i).sum
          answer = sum / 255 == 3 ? 1 : 0

          brain.teach do |it, error, t|
            t.that(threshold_limit, sum).is(answer)

            Rails.logger.info "Learning iteration: #{it} | Error: #{error}"
          end

          Rails.logger.info "#{threshold_limit}|#{x}|#{y} - Learning took #{brain.last_iterations}, error: #{brain.error}, time: #{brain.learning_time} s."
        end
      end
    end
  end
end
