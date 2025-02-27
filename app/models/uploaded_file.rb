class UploadedFile < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  validates :file, presence: true
  validates :title, presence: true
end
