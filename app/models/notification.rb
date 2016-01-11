class Notification < ActiveRecord::Base
  include Bootsy::Container
  belongs_to :user

  def self.get_latest_right_column_text
    if Notification.where(notification_type: 'right_column').first.present?
      notification = Notification.where(notification_type: 'right_column').first
    else
      notification = Notification.new
    end

    notification   
  end  

end
