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
      if @dme_field.update_attributes(params[:object])
        format.html do
          logger.debug "XHR status: #{request.xhr?} format: #{format}"
          if request.xhr?
            logger.debug "We are an XHR request"
            render :partial => 'dirt'
          end
        end
      else
      end
    end
  end
end