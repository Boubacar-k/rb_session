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
            redirect_to user_path(@user.id)
            format.html { redirect_to root_url, notice: 'Account registered' }
            format.json { render :index, status: :created, location: @session }
          else
            if @user.name.empty?
              format.html { render :new, notice: "Please enter your name" }
              format.json { render json: @user.errors, status: :unprocessable_entity }
            elsif @user.email.empty?
              format.html { render :new, notice: "Please enter your e-mail address" }
              format.json { render json: @user.errors, status: :unprocessable_entity }
            elsif @user.password == nil
              format.html { render :new, notice: "Enter your password" }
              format.json { render json: @user.errors, status: :unprocessable_entity }
            elsif @user.password.to_s.length < 6
              format.html { render :new, notice: "Please enter the password with at least 6 characters" }
              format.json { render json: @user.errors, status: :unprocessable_entity }
            elsif @user.password.to_s != @user.password_confirmation.to_s
              format.html { render :new, notice: "Password (confirmation) and password input do not match" }
              format.json { render json: @user.errors, status: :unprocessable_entity }
            elsif User.exists?(email: params[:user][:email])
              format.html { render :new, notice: "Your email address is already in use" }
              format.json { render json: { error: "Your email address is already in use" }, status: :unprocessable_entity }
            else
              render :new
            end
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
