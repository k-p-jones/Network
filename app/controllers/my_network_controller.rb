class MyNetworkController < ApplicationController
    def show
        @my_friends = current_user.my_friends
        @users = User.where.not(:id => @my_friends)
    end
end
