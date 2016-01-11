class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :subcategory
  has_many :comments, dependent: :destroy

  mount_uploader :picture_url, PictureUploader

  validates :content, presence: true
  validates :title, presence: true
  validates :subcategory_id, presence: true, :unless => lambda { self.category_id != 4 }

end
