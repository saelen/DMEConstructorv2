class DmeTablesController < ApplicationController
  def update
    @dme_table = DmeTable.find(params[:id])
    @dme_connections = DmeConnection.all
    @database_names = @dme_table.dme_connection.uc.connection.select_values('sp_databases')
    respond_to do |format|
      if @dme_table.update_attributes(params[:dme_table])
        format.html {
          flash[:info]='Construction Table <'+@dme_table.display_name+'> was successfully updated.'
          redirect_to @dme_table
        }
        format.json { head :no_content }
      else
        format.html { render action: 'edit_table' }
        format.json { render json: @dme_table.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @dme_tables = DmeTable.all
  end

  def new
    @dme_connections = DmeConnection.all
    @dme_table = DmeTable.new
    @database_names = DmeConnection.find(1).uc.connection.select_values('sp_databases')

    respond_to do |format|
      format.html
      format.json { render json: @dme_table }
    end
  end

  def destroy
    @dme = DmeTable.find(params[:id])
    @dme.destroy
    respond_to do |format|
      format.html {
        flash[:info]='Table <'+@dme.display_name+'> has been deleted.'
        redirect_to dme_tables_url
      }
      format.json { head :no_content }
    end
  end

  def create
    @dme_table = DmeTable.new(params[:dme_table])

    respond_to do |format|
      if @dme_table.save
        @dme_table.check_fields
        format.html {
          flash[:info]='Table <'+@dme_table.display_name+'> was successfully created.'
          redirect_to @dme_table
        }
        format.json { render json: @dme_table, status: :created, location: @dme_table }
      else
        format.html { render action: 'new' }
        format.json { render json: @dme_table.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @dme_table = DmeTable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dme_table }
    end
  end

  def edit_table
    @dme_table = DmeTable.find(params[:id])
    @dme_connections = DmeConnection.all
    @database_names = @dme_table.dme_connection.uc.connection.select_values('sp_databases')
  end

  def edit_fields
    @dme_table = DmeTable.find(params[:id])
    @dme_table.check_fields
  end

  def edit_layout
    @dme_table = DmeTable.find(params[:id])
  end

  def subform
    respond_to do |format|
      format.html do
        if request.xhr?
          render :partial => 'form', :locals => {:dme_table => @dme_table}, :layout => false
        end
      end
    end
  end

  def reorder
    params[:sort].each_with_index do |s, i|
      DmeField.find(s).update_attributes!(:sort_order => i)
#      logger.debug "#{s}, #{i}"
    end
    respond_to do |format|
      format.html do
        if request.xhr?
          render :nothing => true, :status => :ok
        end
      end
    end
  end
end
