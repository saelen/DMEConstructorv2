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
end