class User < ApplicationRecord
  has_many :instabots
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable
end
