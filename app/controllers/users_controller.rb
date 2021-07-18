class UsersController < ApplicationController
  before_action :redirect, except: :top

  def index
  end
 
  def top
  end
  
  def destroy
  end

  private

  def redirect
    unless user_signed_in?
      redirect_to action: :top
    end
  end  
end
