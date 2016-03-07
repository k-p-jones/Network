class ThoughtsController < ApplicationController
  def index
    @thoughts = Thought.all
  end
  
  def new
    @thought = Thought.new
  end
  
  def create 
    @thought = Thought.new(thought_params)
    if @thought.save
      flash[:success] = 'Your thought has been published'
       redirect_to root_path
    else
      flash[:warning] = 'There was a problem, try again later!'
      render 'new'
    end
  end 
  
  def show
    @thought = Thought.find_by(params[:id])  
  end
  
  def edit
     @thought = Thought.find_by(params[:id])
  end
  
  def update
     @thought = Thought.find_by(params[:id])
     if @thought.update_attributes(thought_params)
       flash[:success] = 'Thought updated!'
       redirect_to thought_path(@thought)
     else
       flash[:warning] = 'There was a problem'
       render 'edit'
     end
  end
  
  def destroy
     @thought = Thought.find_by(params[:id])
     if @thought.destroy
       flash[:success] = 'Thought destroyed!'
     else
       flash[:warning] = 'There was a problem!'
     end
     redirect_to root_path
  end 
end