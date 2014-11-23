class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :password, :on => :create
  validates :username, uniqueness: true

  # Paperclip stuff
  has_attached_file :avatar, :styles => { :medium => "200x200#", :thumb => "100x100#" }, :default_url => "/images/avatars/missing.jpg", :convert_options => {:thumb => '-set colorspace sRGB -strip', :medium => '-set colorspace sRGB -strip' }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/


  has_many :likes

end
