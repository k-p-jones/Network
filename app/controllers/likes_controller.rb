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

  def destroy
    @like = Like.find_by(params[:id])
    if @like.destroy
      flash[:success] = 'Unliked thought!'
    else
      flash[:warning] = 'Whoops, try again later'
    end
    redirect_to :back
  end 
end