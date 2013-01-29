module ApplicationHelper
  def page_title
    (@content_for_title if @content_for_title).to_s  + ' // MadScribes'
  end

  def page_heading(text)
    content_tag(:h1, content_for(:title){ text })
  end
end
