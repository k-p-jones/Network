class MyNetworkController < ApplicationController
    def show
        # Gather the ID's of all users friendships and place them in an array
        @friends = current_user.friendships.pluck(:friend_id)
        @friends_inv = current_user.inverse_friendships.pluck(:user_id)
        @the_ids = []
        @the_ids << @friends
        @the_ids << @friends_inv
        # Find users who are not friends
        @users = User.where.not(:id => @the_ids)
        # Gather all user friendships
        @pending = current_user.friends
        @requests = current_user.inverse_friends
        @friends = []
        @friends << current_user.friendships.where(:accepted => true) 
        @friends << current_user.inverse_friendships.where(:accepted => true)
        @my_friends = @friends.flatten
    end
end
