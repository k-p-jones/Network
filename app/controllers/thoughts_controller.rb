class ThoughtsController < ApplicationController
  
  before_action :authenticate_user!
  
  def index
    #include current user in the thoughts loop
    @my_friends = current_user.confirmed_friends_ids << current_user.id
    @thoughts = Thought.where(:user_id => @my_friends).all.order('created_at DESC')
    @thought = current_user.thoughts.build
  end
  
  def new
    @thought = current_user.thoughts.build
  end
  
  def create 
    @thought = current_user.thoughts.build(thought_params)
    respond_to do |format|
      format.html {
        if @thought.save
          flash[:success] = 'Your thought has been published'
          redirect_to params[:referer]
        else
          flash[:warning] = 'There was a problem, try again later!'
          render 'new'
        end
      }
      format.js {
         @thought.save
      }
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
     respond_to do |format|
      format.html {
        if @thought.destroy
        flash[:success] = 'Thought destroyed!'
        else
        flash[:warning] = 'There was a problem!'
        end
        redirect_to root_path
      }
      format.js {
        @thought.destroy
      }
     end
     
  end
  
  private
  
  def thought_params
    params.require(:thought).permit(:content, :id)
  end
end