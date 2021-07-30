class User < ApplicationRecord
  has_many :instabots, dependent: :destroy
  has_many :hashtags, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable
end
