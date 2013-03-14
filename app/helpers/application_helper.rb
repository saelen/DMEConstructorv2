module ApplicationHelper
  def generate_document_title(page)
    title = 'DME Constructor'
    if !page.empty?
      title += ' | ' + page
    end
    title
  end

  def signed_in_user
    if !signed_in? && request.fullpath != '/' && request.fullpath != '/signin' &&
        !(StaticPagesController.action_methods.include?(request.fullpath[1..-1])) &&
        request.fullpath != '/sessions'
      puts 'THIS PATH IS BAD! >>' + request.fullpath
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end
end