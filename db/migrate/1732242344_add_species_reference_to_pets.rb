class AddSpeciesReferenceToPets < ActiveRecord::Migration[7.1]
  def change
    remove_column :pets, :species, :string
    add_reference :pets, :species, foreign_key: true
  end
end
