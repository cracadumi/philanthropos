class NotificationsController < ApplicationController
  authorize_resource

  def create
    current_user.notifications.create(notifications_params)  
    redirect_to :back
  end 

 def update
    notifications = Notification.where(notification_type: 'right_column').first
    notifications.update(notifications_params)
    redirect_to :back
 end 

 def main_announcement
  @notification = Notification.get_latest_right_column_text
 end 

  private 
  def notifications_params
    params.require(:notification).permit!
  end

end
