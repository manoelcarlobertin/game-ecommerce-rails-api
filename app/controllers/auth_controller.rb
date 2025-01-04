class AuthController < ApplicationController
  def login
    if request.post?
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to root_path, notice: 'Logged in successfully.'
      else
        flash.now[:alert] = 'Invalid email or password.'
        render :login
      end
    end
  end

  def logout
    session.delete(:user_id)
    redirect_to root_path, notice: 'Logged out successfully.'
  end

  def register
    @user = User.new
    if request.post?
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        redirect_to root_path, notice: 'Registered successfully.'
      else
        render :register
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
