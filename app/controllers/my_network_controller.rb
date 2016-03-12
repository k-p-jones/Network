class MyNetworkController < ApplicationController
    def show
        @users = User.all
        @pending = current_user.friends
        @requests = current_user.inverse_friends
    end
end
