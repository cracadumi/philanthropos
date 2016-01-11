module UsersHelper

  def show_email_on_profile user 
    
    if user == current_user || current_user.role == 'admin'
      return user.email
    elsif user.right.email_veiwable_by == 0
      return user.email
    elsif user.right.email_veiwable_by == 1 && user.promo == current_user.promo
      return user.email
    elsif user.right.email_veiwable_by == 2 && user == current_user
      return user.email
    else
      return '[non visible]'
    end    
           
  end 

  def show_phone_on_profile user

    if user == current_user || current_user.role == 'admin'
      return  user.contact_info.tel_natel
    elsif user.right.tel_natel_viewable_by == 0
      return  user.contact_info.tel_natel
    elsif user.right.tel_natel_viewable_by == 1 && user.promo == current_user.promo
      return  user.contact_info.tel_natel
    elsif user.right.tel_natel_viewable_by == 2 && user == current_user
      return  user.contact_info.tel_natel
    else
      return '[non visible]'
    end    

  end  

  def show_age_on_profile user
    
    if user == current_user || current_user.role == 'admin'
      return  user.get_age
    elsif user.right.age_is_viewable == 0
      return  user.get_age
    elsif user.right.age_is_viewable == 1 && user.promo == current_user.promo
      return  user.get_age
    elsif user.right.age_is_viewable == 2 && user == current_user
      return  user.get_age
    else
      return '[non visible]'
    end  

  end 

  def show_current_address_on_profile user

    if user == current_user || current_user.role == 'admin'
      return  user.contact_info.current_address
    elsif user.right.address_viewable_by == 0
      return  user.contact_info.current_address
    elsif user.right.address_viewable_by == 1 && user.promo == current_user.promo
      return  user.contact_info.current_address
    elsif user.right.address_viewable_by == 2 && user == current_user
      return  user.contact_info.current_address
    else
      return '[non visible]'
    end

  end  

  def mandatory_image_title
    return 'Vous ne pouvez pas modifier cette information. Contacter un administrateur si besoin'
  end  

  def display_user_role user_type
    if user_type == 'admin'
      return 'Administrateur'
    elsif user_type == 'staff'
      return 'Equipe communication'
    elsif user_type == 'correspondant'
      return 'Correspondant de promo'
    else
      return ''  
    end         
  end  

  def display_french_roles option 
    if option == 'admin'
      return 'Administrateur'
    end
    if option == 'staff'
      return 'Equipe communication'
    end
    if option == 'correspondant'
      return 'Correspondant de promo'
    end
    if option == 'user'
      return 'Utilisateur Normal'  
    end     
  end  

  def display_if_account_is_valid user, value
    if user.active
      return value
    else
      return ""  
    end  
  end 

  def set_category_options user
    if (user.is? "staff") || (user.is? "admin")
      return Category.all
    elsif user.is? "correspondant"
      return Category.where(id: 3..5)
    else
      return Category.where(id: 4..5)
    end          
  end 

  def hide_div_if_inactive user
    unless user.active
      return 'hide_div'
    end
  end 

  def devactivation_message user
    unless user.active
      return 'Le profil de cet ancien a été désactivé'
    end
  end  

  def display_promo_values_for_select option
    if option == 0
      return 'Institut'
    else
      return option
    end    
  end

end
