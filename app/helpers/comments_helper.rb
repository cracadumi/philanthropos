module CommentsHelper

  def comment_section_title post_ref
    if post_ref.comments.present?
      return 'Commentaires'
    else
      return ''
    end    
  end

end
