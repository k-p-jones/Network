class LikesController < ApplicationController
  def create
  	@like = current_user.likes.build(:thought_id => params[:id])
    if @like.save
       flash[:success] = 'You liked this post!'
       redirect_to :back
    else
       flash[:warning] = 'There was a problem, try again later!'
       redirect_to :back
     end
  end

  
end