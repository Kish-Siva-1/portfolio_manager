class Investment < ActiveRecord::Base
  belongs_to :portfolio 
  belongs_to :stock
  belongs_to :weight
end 