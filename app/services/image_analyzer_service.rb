require 'opencv'

class ImageAnalyzerService
  include OpenCV
  attr_accessor :brain

  def initialize(image_file)
    @cv_image = image_file
    # @brain = NetworkService.instance
  end

  def self.analyze(image_file)
    new(image_file)
  end

  def generate_samples(samples = 3)
    boundaries = { width: @cv_image.width - 1, height: @cv_image.height - 1 }
    sample_results = []

    samples.times do |sample_id|
      new_image = @cv_image.clone
      threshold = (0..255).to_a.sample
      threshold_image = @cv_image.threshold(threshold, 255, CV_THRESH_BINARY)

      (0..boundaries[:width]).each do |x|
        (0..boundaries[:height]).each do |y|
          point = threshold_image[y, x].to_a

          if point[0] == 255.0 && point[1] == 255.0 && point[2] == 255.0
            new_image[y, x] = [0, 0, 255, 0]
          end
        end
      end

      new_image.save('tmpfile')

      sample_results[sample_id - 1] = File.read('tmpfile')
    end

    sample_results
  end

  def analyze
    boundaries = { width: @cv_image.width - 1, height: @cv_image.height - 1 }

    for threshold_limit in 0..255 do
      threshold_image = @cv_image.threshold(threshold_limit, 255, CV_THRESH_BINARY)

      for x in 0..boundaries[:width] do
        for y in 0..boundaries[:height] do
          point = threshold_image[y, x].to_a
          sum = point.collect(&:to_i).sum
          answer = sum / 255 == 3 ? 1 : 0

          brain.teach do |_it, _error, t|
            t.that(threshold_limit, sum).is(answer)
          end

          Rails.logger.info "#{threshold_limit}|#{x}|#{y} - Aprendendo... #{brain.last_iterations} iterações, margem de erro: #{brain.error}, tempo: #{brain.learning_time} s."
        end
      end
    end
  end
end
