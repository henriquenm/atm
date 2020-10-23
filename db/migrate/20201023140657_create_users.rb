class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :full_name, null: false
      t.string :cpf, null: false
      t.date :birth_date, null: false
      t.integer :gender, null: false
      t.string :password_digest, null: false

      t.timestamps null: false
    end
  end
end
