class UsersController < ApplicationController
    skip_before_action :login_required, only: [:new, :create]
    before_action :correct_user, only: [:show, :update, :edit, :destroy]

    def new
        @user = User.new
    end

    def create
      @user = User.new(user_params)

      respond_to do |format|
        if @user.save
          log_in(@user)
          format.html { redirect_to user_path(@user.id), notice: 'Account registered' }
          format.json { render :index, status: :created, location: @session }
        else
          if @user.name.empty?
            flash.now[:notice] = "Please enter your name"
          elsif @user.email.empty?
            flash.now[:notice] = "Please enter your e-mail address"
          elsif @user.password.blank?
            flash.now[:notice] = "Enter your password"
          elsif @user.password.to_s.length < 6
            flash.now[:notice] = "Please enter the password with at least 6 characters"
          elsif @user.password.to_s != @user.password_confirmation.to_s
            flash.now[:notice] = "Password (confirmation) and password input do not match"
          elsif User.exists?(email: params[:user][:email])
            flash.now[:notice] = "Your email address is already in use"
          end
          
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end 

    def show
        @user = User.find(params[:id])
    end

    def edit
        @user = current_user
    end
    
    def update
        @user= current_user
        if @user.update(user_params)
            flash[:notice] = 'account Updated succefully.'
            redirect_to user_path(@user.id)
        else
            render 'edit'
        end
    end

    def destroy
        session[:user_id] = nil
        @user = User.find(params[:id])
        @user.destroy
        redirect_to new_session_path, flash[:notice] = 'destroyed.'
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
        @user = User.find(params[:id])
        redirect_to current_user unless current_user?(@user)
    end
end
