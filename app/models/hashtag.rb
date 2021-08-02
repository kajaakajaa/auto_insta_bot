class Hashtag < ApplicationRecord
  include AjaxHelper
  
  belongs_to :user
  validates :hashtag, length: { in: 0..15 }, presence: true, uniqueness: { scope: :user_id }
  validate :hashtag, :maximun_regi_count


  REGISTAR_LIMIT_COUNT = 2
  def maximun_regi_count
    if Hashtag.includes(:user) > REGISTAR_LIMIT_COUNT
      errors.add(:hashtag, "ハッシュタグの追加は上限１０個までとなります。")
      respond_to do |format|
        format.js { ajax_redirect_to(root_path) }
      end
    end
  end


    # REGISTER_LIMIT_COUNT = 10 # 定数として登録数を管理
  
    # enum sex: { man: 0, female: 1 }
  
    # validate :limit_user_register_count, on: :create  # 作成したメソッドでバリデーション
  
    # def limit_user_register_count
    #   if self.sex == "man" && man.count >= REGISTER_LIMIT_COUNT # enumがman かつ manのレコード数が制限を超えている
    #       errors.add(:user, "man count is over") # エラーを追加
    #   elsif self.sex == "female" && female.count >= REGISTER_LIMIT_COUNT
    #       errors.add(:user, "female count is over")
    #   end
    # end
end
