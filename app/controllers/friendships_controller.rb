class FriendshipsController < ApplicationController
    
    before_action :authenticate_user!
    
    def create
        @user = User.find_by(params[:id])
        @friend_ids = current_user.my_friends
        @pending = current_user.friendships.where('friend_id= ?', params[:friend_id])
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
                flash[:success] = "Added Friend"
            }
        end
    end

    def destroy
      @friendship = Friendship.find_by_id(params[:id])
      respond_to do |format|
        format.html {
           @friendship.destroy
           flash[:success] = "Removed friendship."
           redirect_to :back 
        }
        format.js {
            @friendship.destroy
            flash[:success] = "Removed friendship"
        }
      end
      
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
