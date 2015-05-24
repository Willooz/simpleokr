class CreateKeyResults < ActiveRecord::Migration
  def change
    create_table :key_results do |t|
      t.string     :description
      t.decimal    :score, precision: 2, scale: 1
      t.text       :review
      t.references :objective, index: true

      t.timestamps null: false
    end
  end
end
