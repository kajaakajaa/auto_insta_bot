class Instabot < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }
end
