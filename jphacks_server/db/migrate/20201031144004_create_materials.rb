class CreateMaterials < ActiveRecord::Migration[6.0]
  def change
    create_table :materials do |t|
      t.string :uuid, index: true, null: false
      t.string :url, null: false
      t.string :author
      t.string :password_digest, null: false
      t.string :title

      t.timestamps
    end
  end
end
