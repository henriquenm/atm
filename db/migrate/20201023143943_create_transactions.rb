class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.belongs_to :account, foreign_key: true

      t.string :type, null: false
      t.integer :operation_nature, null: false
      t.decimal :value, precision: 8, scale: 2, default: 0.0

      t.timestamps null: false
    end
  end
end
