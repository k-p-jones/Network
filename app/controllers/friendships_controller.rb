class FriendshipsController < ApplicationController
    def create
        @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
        if @friendship.save
            flash[:success] = "Added friend."
            redirect_to root_url
        else
            flash[:warning] = "Unable to add friend."
            redirect_to root_url
        end
    end

    def destroy
      @friendship = current_user.friendships.find_by_id(params[:id])
      @friendship.destroy
      flash[:success] = "Removed friendship."
      redirect_to my_network_show_path
    end
end
