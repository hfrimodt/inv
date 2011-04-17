class Location < ActiveRecord::Base
 has_many :locations
 belongs_to :location, :foreign_key => :parent_id 
end
