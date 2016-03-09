class ThoughtsController < ApplicationController
  
  before_action :authenticate_user!
  
  def index
    @thoughts = Thought.all.order('created_at DESC')
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