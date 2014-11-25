class User < ActiveRecord::Base
  has_secure_password
  validates :first_name, :last_name, :presence => :true
  validates :username, uniqueness: true
  validates_format_of :username, :with => /\A[a-zA-Z0-9]+\z/
  validates_format_of :first_name, :last_name, :with => /\A[-a-z]+\z/
  validates :username, length: {minimum: 3}
  validates :password, length: {minimum: 6}

  # Paperclip stuff
  has_attached_file :avatar, :styles => { :medium => "200x200#", :thumb => "100x100#" }, :default_url => "/images/avatars/missing.jpg", :convert_options => {:thumb => '-set colorspace sRGB -strip', :medium => '-set colorspace sRGB -strip' }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/


  has_many :likes

end
