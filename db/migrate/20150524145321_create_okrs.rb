class CreateOkrs < ActiveRecord::Migration
  def change
    create_table :okrs do |t|
      t.string  :admin_name
      t.string  :admin_email
      t.string  :admin_url
      t.string  :public_url
      t.string  :owner
      t.integer :year
      t.integer :quarter
      t.decimal :score, precision: 2, scale: 1
      t.boolean :reviewed?, default: false

      t.timestamps null: false
    end
  end
end
