require 'singleton'
require 'brainz'

class NetworkService
  include Singleton

  delegate_missing_to :@brain

  def initialize
    @brain = Brainz::Brainz.new
    @brain.num_hidden = [4, 7, 3]
  end

  def teach(*args)
    @brain.teach(*args) do |it, error|
      yield it, error, @brain
    end
  end

  def guess(threshold, sum)
    @brain.guess(a: threshold, b: sum)
  end
end
