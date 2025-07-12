class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_phone_verification_code!
      redirect_to verify_user_path(@user), notice: 'Registration successful! Please verify your phone number.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def verify
    @user = User.find(params[:id])
  end

  def submit_verification
    @user = User.find(params[:id])
    if @user.verify_phone_code(params[:verification_code])
      redirect_to root_path, notice: 'Phone number verified!'
    else
      flash.now[:alert] = 'Invalid or expired code.'
      render :verify, status: :unprocessable_entity
    end
  end

  def resend_verification
    @user = User.find(params[:id])
    if @user.can_resend_verification_code?
      @user.send_phone_verification_code!
      flash[:notice] = 'Verification code resent.'
    else
      flash[:alert] = 'Please wait before resending the code.'
    end
    redirect_to verify_user_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :phone_number)
  end
end
