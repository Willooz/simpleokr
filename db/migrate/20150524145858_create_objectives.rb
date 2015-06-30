class CreateObjectives < ActiveRecord::Migration
  def change
    create_table :objectives do |t|
      t.string     :description
      t.decimal    :score, precision: 2, scale: 1, default: 0.5
      t.text       :review
      t.references :okr, index: true

      t.timestamps null: false
    end
  end
end
