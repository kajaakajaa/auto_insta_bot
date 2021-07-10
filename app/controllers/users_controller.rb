class UsersController < ApplicationController
  before_action :redirect_top, except: :top
  
  def index
  end

  def create
  end

  def top
  end

  def set
  end

  private

  def redirect_top
    redirect_to action: :top unless user_signed_in?
  end
  
end
