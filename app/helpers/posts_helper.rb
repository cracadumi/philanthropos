module PostsHelper
  
  def show_post_filter category_id
    
    unless category_id == 4
      return 'hidden'
    else
      return ''  
    end

  end

end
