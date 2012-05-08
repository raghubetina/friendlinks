require 'open-uri'

class UsersController < ApplicationController

  before_filter :authorized?, :except => [:index, :new, :create]
  
  def authorized?
    if params[:id]
      @user = User.find(params[:id])
      unless current_user == @user
        redirect_to root_url, :notice => "Unauthorized."
      end
    end
  end

  def facebook_callback
    if code = params[:code]
      response = open("https://graph.facebook.com/oauth/access_token?client_id=228982437214493&redirect_uri=http://localhost:3000/facebook_callback&client_secret=fae5bcd4f2f737826c43f4cc02e00651&code=#{code}").read
      access_token = response.split("&")[0].split("=")[1]
      current_user.facebook_access_token = access_token
      current_user.save
      redirect_to user_url(current_user), :notice => "Facebook access granted."
    else
      redirect_to root_url, :notice => "Facebook access not granted."
    end
  end  
  
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

  end

  # POST /users
  # POST /users.json
  def create
    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: 'User was successfully created.' }
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
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
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
    @user.destroy
    reset_session
    
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
end
