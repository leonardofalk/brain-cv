require 'singleton'
require 'brainz'

class NetworkService
  include Singleton

  delegate_missing_to :@brain

  def initialize
    @brain = Brainz::Brainz.new
  end

  def teach(*args)
    @brain.teach(*args) do |it, error|
      yield it, error, @brain
    end
  end
end
