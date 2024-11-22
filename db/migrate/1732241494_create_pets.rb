class CreatePets < ActiveRecord::Migration[8.0]
  def change
    create_table :pets, id: false do |t|
      t.string :chip_id, null: false, primary_key: true
      t.string :name, null: false
      t.date :adopted_at, null: false
      t.boolean :vaccination_status, default: false
      t.string :image_link
      t.references :user, null: false, foreign_key: true
      t.references :species, null: false, foreign_key: true
      t.timestamps
    end
  end
end
