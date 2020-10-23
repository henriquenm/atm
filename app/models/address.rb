class Address < ApplicationRecord
  belongs_to :user

  validates_presence_of :street, :number, :district, :complement, :city, :state, :zipcode, :user_id
end
