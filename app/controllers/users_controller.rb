class UsersController < ApplicationController
  before_action :redirect_top, except: :top
  
  def index
  end

  def create
  end

  def top
    if user_signed_in?
      redirect_to root_path
    end
  end

  def set
  end

  private

  def redirect_top
    redirect_to action: :top unless user_signed_in?
  end
  
end
