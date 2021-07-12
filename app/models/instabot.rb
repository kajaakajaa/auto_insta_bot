class Instabot < ApplicationRecord
  belongs_to :user
  validates :user_name, length: { minimum: 6 }, presence: true
  validates :password, length: { minimum: 6 }, presence: true
end
