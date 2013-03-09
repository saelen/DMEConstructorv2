module ApplicationHelper
  def generate_document_title(page)
      title = 'DME Constructor'
      if !page.empty?
          title += ' | ' + page
      end
      title
  end
end