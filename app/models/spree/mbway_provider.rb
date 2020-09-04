module Spree
  class MBWayProvider < ActiveRecord::Base
  	has_many :payments
    validates :name, :key, presence: true
    
    scope :active, -> { where(active: true) }
  end
end
