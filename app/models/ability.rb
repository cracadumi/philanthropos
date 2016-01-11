class Ability
  include CanCan::Ability

  def initialize(user)
    can :show, User
    can :create, Comment
    can :show, Post
    can :posts_for_category, Post

    if user.is? "admin"
      can :manage, :all
      can :csv_management, :csv_files
    end

    user_ability(user)
    post_ability(user)
    comment_ability(user)
    notification_ability(user)
    posts_for_category_ability(user)
    create_post(user)
    # show_post_ability(user)
    change_password_ability(user)

  end

  def post_ability user
    if user.role == "staff" || user.role == "admin"
      can :manage, Post 
    else
      can [:update, :destroy, :edit], Post do |post|
        post.user_id == user.id
      end  
    end  
  end

  def comment_ability user
    if (user.is? "staff") || (user.is? "admin")
      can :manage, Comment 
    else
      can [:update, :destroy, :edit], Comment do |comment|
         comment.user_id == user.id
      end
    end  
  end

  def notification_ability user
    can :manage, Notification if (user.is? "staff") || (user.is? "admin")
  end

  def user_ability user
    can [:update, :edit], User, id: user.id
  end

  def posts_for_category_ability user
    if (user.is? "staff") || (user.is? "admin")
      can :posts_for_category, Category
    elsif user.is? "correspondant"
      can :posts_for_category, Category 
    else
      can :posts_for_category, Category 
    end        
  end

  def create_post user
    if (user.is? "staff") || (user.is? "admin")
      can :create, Post
    elsif user.is? "correspondant"
      can :create, Post do |post|
        post.category_id == 3 || post.category_id == 4 || post.category_id == 5
      end
    else
      can :create, Post do |post|
        post.category_id == 4 || post.category_id == 5
      end
    end      
  end

  def show_post_ability user
    if (user.is? "staff") || (user.is? "admin")
      can :show, Post
    elsif user.is? "correspondant"
      can :show, Post
    else
      can :show, Post do |post|
        post.category_id == 4 || post.category_id == 5
      end
    end
  end

  def change_password_ability user

    can [:change_password, :update_password], User, id: user.id
    
  end

end