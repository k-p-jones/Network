class ProfilesController < ApplicationController
  
  def show
    @user = User.find_by_id(params[:id])
    @thoughts = @user.thoughts
    @thought = current_user.thoughts.build
  end

end
