class LikesController < ApplicationController

def create
    @thought = Thought.find_by_id(params[:id])
  	@like = current_user.likes.build(:thought_id => params[:id])
  	respond_to do |format|
  	format.html {  
      if @like.save
         flash[:success] = 'You liked this post!'
         redirect_to :back
      else
         flash[:warning] = 'There was a problem, try again later!'
         redirect_to :back
      end
  	}
  	format.js {
  	  @like.save
  	}
  end
end

  def destroy
    @thought = Thought.find_by_id(params[:id])
    @like = Like.find_by(user_id: params[:user_id], thought_id: params[:thought_id])
    respond_to do |format|
      format.html {
        if @like.destroy
          flash[:success] = 'Unliked thought!'
        else
          flash[:warning] = 'Whoops, try again later'
        end
        redirect_to :back
      }
      format.js {
        @like.destroy
      }
    end
  end 
end