class CreateImpressions < ActiveRecord::Migration[6.0]
  def change
    create_table :impressions do |t|
      t.references :material, index: true, null: false, foreign_key: true
      t.string :value, index: true, null: false
      t.timestamps
    end
  end
end
