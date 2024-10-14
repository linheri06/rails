class StaticPagesController < ApplicationController
    def home
        @microposts = @current_user.feed if logged_in?
        #binding.pry
        @micropost = current_user.microposts.build if logged_in?
    end
    def help
    end
    def about
    end
end
