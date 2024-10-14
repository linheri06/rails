class UsersController < ApplicationController
    before_action :logged_in_user, only: [:index,:edit, :update]
    before_action :correct_user, only: [:edit, :update]
    def index
        @users = User.all
        #@users = Kaminari.paginate_array(User.first(10)).page(params[:page])
    end

    def show
        @user = User.find(params[:id])
        if flash[:microposts]
            @params = flash[:microposts] 
            @query = flash[:query]
            #binding.pry
            @microposts=[]
            @params.each do |i|
                #binding.pry
                @microposts.push(Micropost.find_by(id: i))
            end
        else
            @microposts = @user.microposts 
        end
        @micropost = current_user.microposts.build if logged_in?
        
    end

    def new 
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            UserMailer.account_activation(@user).deliver_now
            flash[:notice] = "Please check your email to activate your account."
            redirect_to root_url
        else
            flash[:alert] = "Error"
            redirect_to root_url
        end
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
            flash.now[:notice] = 'Profile updated'
            redirect_to @user
            flash.discard(:notice)
        else 
            flash[:alert] = 'Edit eror'
            render :edit, status: :unprocessable_entity
            flash.discard(:alert)
        end
    end

    def destroy
        user =  User.find(params[:id])
        if current_user.admin? && !current_user?(user)
            User.find(params[:id]).destroy
            flash[:notice] = "User deleted"
            redirect_to users_url
        else
            flash[:alert] = "No access"
            redirect_to(users_path)
        end
    end

    def search
        @query = params[:query]

        @users = User.where("name ILIKE ?", "%#{@query}%").or(User.where("email ILIKE ?", "%#{@query}%"))

        render :index
    end

    def logged_in_user
        unless logged_in?
            store_location
            flash[:danger] = "Please log in."
            redirect_to login_url
        end
    end

    def correct_user
        @user = User.find(params[:id])
        
        unless @user == current_user
            flash[:alert] = "No access"
            redirect_to(users_path) 
        end
    end

    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    def admin_user
        redirect_to(root_url) unless current_user.admin?
    end

    def following
        @title = "Following"
        @user = User.find(params[:id])
        @users = @user.following
        flash[:info] = 'Following'
        render 'show_follow', status: :unprocessable_entity
        end
    def followers
        @title = "Followers"
        @user = User.find(params[:id])
        @users = @user.followers
        flash[:info] = 'Followers'
        render 'show_follow', status: :unprocessable_entity
    end

end
