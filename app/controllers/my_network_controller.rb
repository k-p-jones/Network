class MyNetworkController < ApplicationController
    def show
        @user = current_user
        @users = User.all
        @pending = current_user.friends
        @requests = current_user.inverse_friends
    end
end
