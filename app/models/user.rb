class User < ActiveRecord::Base

  has_many :portfolios 
 
  validates :username, presence: true
  validates :email, presence: true
  
  has_secure_password
  
end 