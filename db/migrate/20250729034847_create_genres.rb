class CreateGenres < ActiveRecord::Migration[8.0]
  def change
    create_table :genres do |t|
      t.string :name
      t.integer :status
      t.string :description
      t.string :slug
      t.timestamps
    end
    add_index :genres, :slug, unique: true
  end
end
