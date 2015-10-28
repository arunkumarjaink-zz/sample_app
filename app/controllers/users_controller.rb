class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
	before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    if !signed_in?
  	   @user = User.new
    else
      redirect_to root_path
    end
  end

  def destroy
    user = User.find(params[:id])
    if (user == current_user) && (current_user.admin?)
      flash[:error] = "You're admin. Can't destroy yourself."
    else
      user.destroy
      flash[:notice] = "User destroyed."
    end
    redirect_to users_path
  end

  def create
    if !signed_in?
  	   @user = User.new(params[:user])
       respond_to do |format|
  	   if @user.save
          ExampleMailer.sample_email(@user).deliver
          sign_in @user
  		    flash[:success] = "Welcome to the Sample App!"
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render :show, status: :created, location: @user }
  	   else
  		    format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
  	   end
     end
    else
        redirect_to root_path
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success]="Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
  	@users = User.paginate(page: params[:page])
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  	def correct_user
  		@user = User.find(params[:id])
  		redirect_to(root_path) unless current_user?(@user)
  	end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
