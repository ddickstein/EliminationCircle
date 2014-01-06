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
  
  def asset_url(asset)
    "#{request.protocol}#{request.host_with_port}#{asset_path(asset)}"
  end
  
  def wordinalize(num)
    def ones(num)
      case num
      when 0 then "zeroth"
      when 1 then "first"
      when 2 then "second"
      when 3 then "third"
      when 4 then "fourth"
      when 5 then "fifth"
      when 6 then "sixth"
      when 7 then "seventh"
      when 8 then "eighth"
      when 9 then "ninth"
      else ""
      end
    end
    def tens(num)
      case num
      when 2 then "twenty"
      when 3 then "thirty"
      when 4 then "forty"
      when 5 then "fifty"
      when 6 then "sixty"
      when 7 then "seventy"
      when 8 then "eighty"
      when 9 then "ninety"
      else ""
      end
    end
    num = num.to_i
    if (num >= 100)
      num.ordinalize
    elsif (num < 10)
      ones(num)
    elsif (num >= 10 and num <= 20)
      case num
      when 10 then "tenth"
      when 11 then "eleventh"
      when 12 then "twelfth"
      when 13 then "thirteenth"
      when 20 then "twentieth"
      else
        "#{ones(num % 10)[0...-1]}eenth"
      end
    else
      "#{tens(num / 10)}-#{ones(num % 10)}"
    end
  end
end