class DmeFieldsController < ApplicationController
  def destroy
    @dme_field =DmeField.find(params[:id])
    @dme_field.destroy unless @dme_field.primary_key?

    respond_to do |format|
      format.html {
        if request.xhr?
          if @dme_field.primary_key? then
            render :nothing => true, :status => :internal_server_error
          else
            render :nothing => true, :status => :ok
          end
        end
      }
    end
  end

  def new
    logger.debug "New Called"
    logger.debug params.pretty_inspect

    @dme_field = DmeTable.find(params[:dme_table_id]).dme_fields.new
    respond_to do |format|
      format.html do
        render :partial => '/dme_fields/field_row', :locals => {:f => @dme_field} if request.xhr?
      end
    end
  end

  def create
    logger.debug "Create Called"
    logger.debug params.pretty_inspect
    @dme_field = DmeTable.find(params[:dme_table_id]).dme_fields.new(params[:object])
    @dme_field.sort_order = DmeTable.find(params[:dme_table_id]).dme_fields.count
    respond_to do |format|
      if @dme_field.save
        @dme_field.reload
        @dme_field.dme_table.check_fields
        @dme_field.reload
        format.html do
          render :partial => '/dme_fields/field_row', :locals => {:f => @dme_field} if request.xhr?
        end
      else
        format.html do
          render :nothing => true, :status => :internal_server_error
        end
      end
    end
  end

  def update
    @dme_field = DmeField.find(params[:id])
    respond_to do |format|
      begin
        @dme_field.update_attributes(params[:object])
        @dme_field.reload
        @dme_field.dme_table.check_fields
        @dme_field.reload
        format.html do
          render :partial => 'field_row', :locals => {:f => @dme_field} if request.xhr?
        end
      rescue Exception => e
        @dme_field.reload
        @dme_field.dme_table.check_fields
        @dme_field.reload
        logger.debug "Exception Class caught =>#{e.class}."
        logger.debug "Update failed for field with message =>#{e.message}."
        format.html do
          render :partial => 'field_row', :locals => {:f => @dme_field},
                 :status => :internal_server_error if request.xhr?
        end
      end
    end
  end
end