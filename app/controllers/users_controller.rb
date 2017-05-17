class UsersController < ApplicationController
  skip_before_filter :authenicate_with_db!

  def create
    @user = User.find_by(:username => params[:username])
    @user = User.new if @user.nil?
    @user.username = params[:username]
    @user.password = params[:password]
    if @user.save
      render :nothing => true, :status => :ok
    else
      render :json => {:message =>  @user.errors.messages}, :status => :not_acceptable
    end
  end
end
