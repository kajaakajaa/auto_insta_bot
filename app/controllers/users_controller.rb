class UsersController < ApplicationController
  
  def index
  end

  def create
  end

  def top
    if user_signed_in?
      redirect_to action: :index
    end
  end

  def set
  end
  
end
