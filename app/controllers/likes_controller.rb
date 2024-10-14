class LikesController < ApplicationController
    before_action :logged_in_user
    def create
        @micropost = Micropost.find(params[:micropost_id])
        current_user.like(@micropost)
        #redirect_to root_path

        respond_to do |format|
            format.html { redirect_to root_path } # Xử lý thông thường khi không phải là AJAX request
            #format.js
        end

    end
    def destroy
        user = Like.find(params[:id]).user_like
        @micropost = Micropost.find(params[:micropost_id])
        #user = Relationship.find(params[:id]).followed
        @micropost.unlike(user)
        redirect_to root_path
    end
end
