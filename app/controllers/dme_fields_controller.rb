class DmeFieldsController < ApplicationController
  def destroy
    @dme_field =DmeField.find(params[:id])
    @dme_field.destroy unless @dme_field.active?

    respond_to do |format|
      format.html {
        if @dme_field.active? then
          flash[:error]='Cannot delete an active field'
        else
          flash[:info]='Removed field  <'+@dme_field.db_column_name+'>.'
        end
        redirect_to dme_tables_url
      }
      format.json { head :no_content }
    end
  end

  def update
    @dme_field = DmeField.find(params[:id])
    respond_to do |format|
      begin
        @dme_field.update_attributes(params[:object])
        @dme_field.dme_table.check_fields
        format.html do
          render :partial => 'field_row', :locals => {:f => DmeField.find(params[:id])} if request.xhr?
        end
      rescue Exception => e
        @dme_field.dme_table.check_fields
        logger.debug "Exception Class #{e.class}"
        logger.debug "update failed for field with message #{e.message}"
        format.html do
          render :partial => 'field_row', :locals => {:f => DmeField.find(params[:id])},
                 :status => :internal_server_error if request.xhr?
        end
      end
    end
  end
end