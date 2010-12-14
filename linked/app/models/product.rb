class Product < ActiveRecord::Base

  validates_presence_of :name, :provider_name
  validates_presence_of :ticket_type
  validates_presence_of :opened_at, :closed_at
  validates_presence_of :resort, :unless => :free_type_ticket?

  has_many :coupons
  accepts_nested_attributes_for :coupons

  has_many :reservations



  def free_type_ticket?
    self.ticket_type == "free"
  end

end
