class Address < ApplicationRecord
  belongs_to :user

  validates_presence_of :street, :number, :district, :city, :state, :zipcode, :user
end
