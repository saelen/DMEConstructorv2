class ConnectionsController < ApplicationController
  helper_method :test

  def destroy
    @connection = Connection.find(params[:id])
    @connection.destroy

    respond_to do |format|
      format.html {
        flash[:info]='Connection <'+@connection.name+'> has been deleted.'
        redirect_to connections_url
      }
      format.json { head :no_content }
    end
  end

  def index
    @connections = Connection.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @connections }
    end
  end

  def update
    @connection = Connection.find(params[:id])

    respond_to do |format|
      if @connection.update_attributes(params[:connection])
        format.html {
          flash[:info]='Connection <'+@connection.name+'> was successfully updated.'
          redirect_to @connection
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @connection.errors, status: :unprocessable_entity }
      end
    end
  end

  def test
    if params[:id].nil? || params[:id].empty?
      @connection = Connection.new()
      @connection.adapter = params[:adapter]
      @connection.host = params[:host]
      @connection.default_database = params[:defaultdatabase]
      @connection.username = params[:username]
      @connection.password = params[:password]
      @connection.name = params[:name]
      if !params[:previous_id].nil? && !params[:previous_id].empty?
        @previous_connection = Connection.find(params[:previous_id])
      end
    else
      @connection = Connection.find(params[:id])
    end

    respond_to do |format|
      format.js { render :partial => 'connections/testconnection', :layout => false }
    end
  end

  def new
    @connection = Connection.new

    respond_to do |format|
      format.html
      format.json { render json: @connection }
    end
  end

  def edit
    @connection = Connection.find(params[:id])
  end

  def create
    @connection = Connection.new(params[:connection])

    respond_to do |format|
      if @connection.save
        format.html {
          flash[:info]='Connection <'+@connection.name+'> was successfully created.'
          redirect_to @connection
        }
        format.json { render json: @connection, status: :created, location: @connection }
      else
        format.html { render action: 'new' }
        format.json { render json: @connection.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @connection = Connection.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @connection }
    end
  end
end
