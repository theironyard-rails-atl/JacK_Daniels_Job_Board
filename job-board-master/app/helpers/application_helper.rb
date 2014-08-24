module ApplicationHelper
  def flash_class name
    # Translate rails conventions to bootstrap conventions
    case name.to_sym
    when :notice
      :success
    when :alert
      :error
    else
      name
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" :nil
    #ensure that the jobs table starts with end_date "asc"
    #and that when clicked sorts "desc" while anything else starts off "asc"
    if column == "end_date" && params[:sort].nil? && params[:direction].nil?
      direction = "desc"
    else
      direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    end
    search = params[:search]
    link_to title, {:sort => column, :direction => direction, :search => search}, {:class =>  css_class}
  end
end
