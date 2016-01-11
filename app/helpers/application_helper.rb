module ApplicationHelper
  def get_picture user
    if user.picture_url.present?
      user.picture_url
    else
      'users/avatar.png'
    end  
  end 

  def right_column_text
    return Notification.where(notification_type: 'right_column').pluck(:content).first
  end

  def get_formatted_date date
    return date.to_date.to_date.strftime('%d/%m/%Y')
  end

  def get_user_promo promo
    if promo == 0
      return 'Institut'
    else
      return "Promo #{promo}"
    end    
  end 

  def flash_class level
    case level
      when 'notice' then "alert alert-info"
      when 'success' then "alert alert-success"
      when 'error' then "alert alert-danger"
      when 'alert' then "alert alert-warning"
    end
  end

end
