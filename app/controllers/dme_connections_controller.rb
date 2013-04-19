class DmeConnectionsController < ApplicationController
  helper_method :test, :database_list

  def destroy
    @dme_connection = DmeConnection.find(params[:id])
    @dme_connection.destroy

    respond_to do |format|
      format.html {
        flash[:info]='Connection <'+@dme_connection.name+'> has been deleted.'
        redirect_to connections_url
      }
      format.json { head :no_content }
    end
  end

  def index
    @dme_connections = DmeConnection.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dme_connections }
    end
  end

  def update
    @dme_connection = DmeConnection.find(params[:id])

    respond_to do |format|
      if @dme_connection.update_attributes(params[:dme_connection])
        format.html {
          flash[:info]='Connection <'+@dme_connection.name+'> was successfully updated.'
          redirect_to @dme_connection
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dme_connection.errors, status: :unprocessable_entity }
      end
    end
  end

  def test
    if params[:id].nil? || params[:id].empty?
      @dme_connection = DmeConnection.new()
      @dme_connection.adapter = params[:adapter]
      @dme_connection.host = params[:host]
      @dme_connection.default_database = params[:defaultdatabase]
      @dme_connection.username = params[:username]
      @dme_connection.password = params[:password]
      @dme_connection.name = params[:name]
      if !params[:previous_id].nil? && !params[:previous_id].empty?
        @previous_dme_connection = DmeConnection.find(params[:previous_id])
      end
    else
      @dme_connection = DmeConnection.find(params[:id])
    end

    respond_to do |format|
      format.js { render :partial => 'dme_connections/testconnection', :layout => false }
    end
  end

  def new
    @dme_connection = DmeConnection.new

    respond_to do |format|
      format.html
      format.json { render json: @dme_connection }
    end
  end

  def edit
    @dme_connection = DmeConnection.find(params[:id])
  end

  def database_list
    @dme_connection = DmeConnection.find(params[:id])
    respond_to do |format|
      format.json { render json: @dme_connection.database_list }
    end
  end

  def table_list
    @dme_connection = DmeConnection.find(params[:id])
    @dme_connection.default_database = params[:dbname]
    @dme_connection.test_connection
    respond_to do |format|
      format.json { render json: @dme_connection.table_list }
    end
  end

  def create
    @dme_connection = DmeConnection.new(params[:dme_connection])

    respond_to do |format|
      if @dme_connection.save
        format.html {
          flash[:info]='Connection <'+@dme_connection.name+'> was successfully created.'
          redirect_to @dme_connection
        }
        format.json { render json: @dme_connection, status: :created, location: @dme_connection }
      else
        format.html { render action: 'new' }
        format.json { render json: @dme_connection.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @dme_connection = DmeConnection.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dme_connection }
    end
  end

end
