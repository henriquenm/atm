class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.belongs_to :user, index: { unique: true }, foreign_key: true

      t.string :street, null: false
      t.string :number, null: false
      t.string :district, null: false
      t.string :complement
      t.string :city, null: false
      t.string :state, null: false
      t.string :zipcode, null: false

      t.timestamps null: false
    end
  end
end
