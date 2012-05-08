class User < ActiveRecord::Base
  has_secure_password
  validates_uniqueness_of :username
  
  has_many :posts
end
