class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :date
      t.string :description
      t.float :amount
      t.integer :category_id
      t.integer :user_id
    end
  end
end
