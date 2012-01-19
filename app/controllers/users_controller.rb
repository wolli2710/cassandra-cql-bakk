class UsersController < ApplicationController

  require 'json'

  def index
    @users = User.get_users
  end

  def show
    @user = User.get_user params[:id]
    @messages = User.get_messages params[:id]
  end

  def new
    @uid = User.new_user
  end

  def create
    uid = params[:uid]
    @user = User.update_user uid, params[:first_name], params[:last_name], params[:e_mail]
    redirect_to users_path
  end

  def destroy
    User.delete_user(params[:id])
    redirect_to users_path
  end

  def delete_users
    User.delete_users
    redirect_to users_path
  end

  def timeline
    @user = User.get_user params[:id]
    @timeline = User.get_timeline params[:id]
  end
end
