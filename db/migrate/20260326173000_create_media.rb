class CreateMedia < ActiveRecord::Migration[8.0]
  def change
    create_table :media do |t|
      t.string :name
      t.string :file_type
      t.integer :size
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
