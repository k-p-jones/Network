class FriendshipsController < ApplicationController
    
    before_action :authenticate_user!
    
    def create
        @test = current_user.friendships.last
        @user = User.find_by(params[:id])
        @friend_ids = current_user.my_friends
        @pending = current_user.friendships.where('friend_id= ?', params[:friend_id])
        @recieved = current_user.inverse_friendships.where('user_id= ?', @user.id)
        @confirmed = current_user.confirmed_profile_friendship(@user.id, current_user)
        @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
        respond_to do |format|
            format.html {
              if @friendship.save
                flash[:success] = "Added friend."
                redirect_to :back
              else
                flash[:warning] = "Unable to add friend."
                redirect_to :back
              end  
            }

            format.js {
                @friendship.save
            }
        end
    end

    def destroy
      @friendship = Friendship.find_by_id(params[:id])
      @friendship.destroy
      flash[:success] = "Removed friendship."
      redirect_to :back
    end
    
    def update
        @friendship = current_user.inverse_friendships.find_by_id(params[:id])
        @friendship.update_attributes(accepted: true)
        if @friendship.save
            flash[:success] = "You are now friends!"
        else
            flash[:warning] = "There was a problem"
        end
        redirect_to :back
    end
    
end
