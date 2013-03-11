class UsersController < ApplicationController
  before_filter :correct_user, only: [:edit, :update, :destroy]
  before_filter :signed_in_user

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html {
          flash[:info]='User <'+@user.name+'> was successfully created.'
          redirect_to @user
        }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html {
          flash[:info]='User <'+@user.name+'> was successfully updated.'
          redirect_to @user
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    if current_user != @user
      @user.destroy

      respond_to do |format|
        format.html {
          flash[:info]='User <'+@user.name+'> has been deleted.'
          redirect_to users_url
        }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error]='You cannot delete yourself.'
          redirect_to users_url
        }
        format.json { head :no_content }
      end
    end
  end

  private

  def correct_user #TODO: Check for Admin here too!
    @user = User.find(params[:id])
    redirect_to(users_path, :notice => 'You do not have permissions to edit other user\'s profiles.') unless current_user?(@user)
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end
end
