class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :material, index: true, null: false
      t.string :uuid, index: true, null: false, defautl: ''
      t.string :text, null: false, default: ''
      t.integer :count, null: false, default: 0
      t.integer :number, null: false, default: 1

      t.timestamps
    end
  end
end
