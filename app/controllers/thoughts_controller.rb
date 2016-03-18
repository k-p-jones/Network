class ThoughtsController < ApplicationController
  
  before_action :authenticate_user!
  
  def index
    # Gather all confirmed friends and include current user for the news feed
    @friends = current_user.friendships.where(:accepted => true).pluck(:friend_id)
    @friends_inv = current_user.inverse_friendships.where(:accepted => true).pluck(:user_id)
    @the_ids = []
    @the_ids << @friends
    @the_ids << @friends_inv
    @the_ids << current_user.id
    @users = User.where(:id => @the_ids)
    # Gather and order all thoughts created by confirmed friends
    @thoughts = Thought.where(:user_id => @the_ids).all.order('created_at DESC')
    # Create a new thought from the news feed
    @thought = current_user.thoughts.build
  end
  
  def new
    @thought = current_user.thoughts.build
  end
  
  def create 
    @thought = current_user.thoughts.build(thought_params)
    if @thought.save
      flash[:success] = 'Your thought has been published'
       redirect_to root_path
    else
      flash[:warning] = 'There was a problem, try again later!'
      render 'new'
    end
  end 
  
  def show
    @thought = Thought.find_by_id(params[:id])
    @comment = Comment.new
  end
  
  def edit
     @thought = Thought.find_by_id(params[:id])
  end
  
  def update
     @thought = Thought.find_by_id(params[:id])
     if @thought.update_attributes(thought_params)
       flash[:success] = 'Thought updated!'
       redirect_to thought_path(@thought)
     else
       flash[:warning] = 'There was a problem'
       render 'edit'
     end
  end
  
  def destroy
     @thought = Thought.find_by_id(params[:id])
     if @thought.destroy
       flash[:success] = 'Thought destroyed!'
     else
       flash[:warning] = 'There was a problem!'
     end
     redirect_to root_path
  end
  
  private
  
  def thought_params
    params.require(:thought).permit(:content, :id)
  end
end