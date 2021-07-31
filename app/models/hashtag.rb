class Hashtag < ApplicationRecord
  belongs_to :user
  validates :hashtag, length: { in: 0..15 }, presence: true, uniqueness: { scope: :user_id }
end
