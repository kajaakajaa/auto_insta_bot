class HashtagsController < ApplicationController
  include AjaxHelper

  # hashtag_path POST
  def hashtag
    @hash_rcd = Hashtag.new(hashtag_params)
    if @hash_rcd.save
      redirect_to root_path
    elsif @hash_rcd.hashtag.blank?
      flash[:error] = "空欄では登録出来ません。"
      respond_to do |format|
        format.js { render ajax_redirect_to(root_path) }
      end
    else
      flash[:error] = "ハッシュタグの追加は上限１０個までとなります。"
      respond_to do |format|
        format.js { render ajax_redirect_to(root_path) }
      end
    end
  end

  # number_path POST
  def number
    @number = Hashtag.find_by(user_id: current_user.id)
    @number.update(number: params[:hashtag][:number])
  end

  def destroy
    @hashtag_rcd = Hashtag.find(params[:id])
    @hashtag_rcd.destroy
    redirect_to root_path
  end
end

private
def hashtag_params
  params.require(:hashtag).permit(:hashtag).merge(user_id: current_user.id)
end

def number_prams
  params.require(:hashtag).permit(:number).merge(user_id: current_user.id)
end
