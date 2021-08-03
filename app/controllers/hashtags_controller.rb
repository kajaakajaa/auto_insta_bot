class HashtagsController < ApplicationController
  def destroy
    @hashtag_rcd = Hashtag.find(params[:id])
    @hashtag_rcd.destroy
    redirect_to root_path
  end
end
