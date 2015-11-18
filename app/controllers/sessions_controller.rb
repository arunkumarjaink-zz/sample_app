class SessionsController < ApplicationController
	
	def new
	end

	def create
		user = User.find_by_email(params[:session][:email])
		if user && user.authenticate(params[:session][:password])
			if user.activated?
		        log_in user
		        redirect_back_or user
		    else
		        message  = "Account not activated. "
		        message += "Check your email for the activation link."
		        flash[:warning] = message
		        redirect_to root_path
		    end
		else
			flash.now[:error] = 'Invalid email/password combination'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end

end