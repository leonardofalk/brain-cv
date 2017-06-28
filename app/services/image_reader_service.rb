require 'opencv'

class ImageReaderService
  include OpenCV

  def initialize(image)
    fl = File.open(image.description, 'wb')
    fl.write(image.data)
    fl.flush
    fl.close

    @file = cv_image Rails.root.join(fl).to_s

    FileUtils.rm_rf fl
  end

  def analyze
    ImageAnalyzerService.analyze(@file)
  end

  private

  def cv_image(image)
    CvMat.load(image, CV_LOAD_IMAGE_COLOR)
  end
end
