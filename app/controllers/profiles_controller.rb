class ProfilesController < ApplicationController
  
  before_action :authenticate_user!
  
  def show
    @friend_ids = current_user.my_friends
    @user = User.find_by_id(params[:id])
    @thoughts = @user.thoughts.order('created_at DESC')
    @thought = current_user.thoughts.build
  end
end
