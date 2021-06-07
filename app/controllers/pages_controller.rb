class PagesController < ApplicationController

  def index
    unless user_signed_in?
      redirect_to action: :top
    end
  end

  def show
  end

  def top
  end
  
end
