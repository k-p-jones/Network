class FriendshipsController < ApplicationController
    
    before_action :authenticate_user!
    
    def create
        @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
        if @friendship.save
            flash[:success] = "Added friend."
            redirect_to my_network_show_path
        else
            flash[:warning] = "Unable to add friend."
            redirect_to my_network_show_path
        end
    end

    def destroy
      @friendship = Friendship.find_by_id(params[:id])
      @friendship.destroy
      flash[:success] = "Removed friendship."
      redirect_to my_network_show_path
    end
    # Accept recieved friend request
    def update
        @friendship = current_user.inverse_friendships.find_by_id(params[:id])
        @friendship.update_attributes(accepted: true)
        if @friendship.save
            flash[:success] = "You are now friends!"
        else
            flash[:warning] = "There was a problem"
        end
        redirect_to my_network_show_path
    end
    
end
