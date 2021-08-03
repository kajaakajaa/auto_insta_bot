class Hashtag < ApplicationRecord
  include AjaxHelper
  
  belongs_to :user
  validates :hashtag, length: { in: 1..15 }, presence: true, uniqueness: { scope: :user_id }
  validate :maximun_regi_count


  REGISTAR_LIMIT_COUNT = 10
  def maximun_regi_count
    if Hashtag.includes(:user).length >= REGISTAR_LIMIT_COUNT
      errors.add(:hashtag, "ハッシュタグの追加は上限2個までとなります。")
    end
  end
end
