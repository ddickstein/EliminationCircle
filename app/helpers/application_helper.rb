module ApplicationHelper
  def get_title(title)
    title.nil? ? 'Elimination Circle' : "#{title} | Elimination Circle"
  end
  
  def pluralize_without_count(count, noun, text = nil)
    if count != 0
      count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
    end
  end
  
  def sortable(column, display_name)
    direction = "asc"
    if sort_column.present?
      if sort_column != column and (column == "died_at" or column == "kills")
        direction = "desc"
      elsif sort_column == column
        direction = sort_direction == "asc" ? "desc" : "asc"
      end
    end
    link_to display_name, {:sort => column, :dir => direction}, {:class => 'sortable-link'}
  end
  
  def asset_url asset
    "#{request.protocol}#{request.host_with_port}#{asset_path(asset)}"
  end
  
end
