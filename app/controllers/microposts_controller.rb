class MicropostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy, :filter]
    before_action :correct_user, only: :destroy

    def create
        # content = Micropost.new(content: params[:content])
        # params =  {"user"=>{"content"=>"aaaaaaaaaaaaaaa\n", "user_id "=> '#(current_user.id)'}}
        #@micropost = Micropost.new(content: params[:content], user_id: current_user.id)
        #@micropost.image.attach(image: params[:image])
        @user = User.find(params[:user_id]) if params[:user_id].present?
        @micropost = current_user.microposts.build(micropost_params)
        @micropost.image.attach(params[:micropost][:image])
        if @micropost.save
            flash[:notice] = "Microposr created!"
            redirect_to root_path
        else
            flash[:alert] = "Error!"
            redirect_to root_path
        end
    end

    def filter
        @user = User.find(params[:user_id]) if params[:user_id].present?
        @query = params[:query]
        @microposts = Micropost.where("created_at between '#{@query} 00:00:00' and '#{@query} 23:59:59'").and(Micropost.where("user_id = ?","#{params[:user_id]}"))
        #binding.pry
        flash[:microposts] = @microposts.pluck(:id)
        flash[:query] = @query
        redirect_to @user
        #render root_path
    end


    def destroy
        @micropost.destroy
        flash[:notice] = "Micropost deleted"
        redirect_to request.referrer || root_url
    end

    def edit
        @micropost = Micropost.find(params[:id])
    end

    def update
        redirect_to root_url
    end

    def micropost_params
        params.require(:micropost).permit(:content, :image)
      end

      def correct_user
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url if @micropost.nil?
    end
    
      
end
