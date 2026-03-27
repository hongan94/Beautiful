class CreateRolePermissions < ActiveRecord::Migration[8.0]
  def change
    execute "DROP TABLE IF EXISTS genres CASCADE"

    create_table :user_groups do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end

    create_table :permissions do |t|
      t.string :action, null: false
      t.string :subject_class, null: false
      t.text :description

      t.timestamps
    end

    create_table :user_group_permissions do |t|
      t.references :user_group, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true

      t.timestamps
    end

    add_reference :users, :user_group, foreign_key: true
  end
end
