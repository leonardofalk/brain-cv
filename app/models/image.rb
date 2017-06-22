class Image < ApplicationRecord
  validates :data, presence: true
end
