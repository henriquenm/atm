class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.belongs_to :user, index: { unique: true }, foreign_key: true

      t.string :number, null: false
      t.string :agency, null: false
      t.string :token, null: false
      t.decimal :limit, precision: 8, scale: 2, default: 0.0
      t.decimal :balance, precision: 8, scale: 2, default: 0.0

      t.timestamps null: false
    end
  end
end
