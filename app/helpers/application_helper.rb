module ApplicationHelper
  def get_title title
    title.nil? ? 'Elimination Circle' : "#{title} | Elimination Circle"
  end
  
end
