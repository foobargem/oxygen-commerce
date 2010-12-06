class Product < ActiveRecord::Base

  validates_presence_of :name, :provider_name
  validates_presence_of :ticket_type, :resort
  validates_presence_of :opened_at, :closed_at

end
