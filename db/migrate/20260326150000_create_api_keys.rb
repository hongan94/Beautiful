class CreateApiKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :api_keys do |t|
      t.string :name, null: false
      t.string :token, null: false
      t.references :user, null: true, foreign_key: true
      t.integer :status, default: 0 # 0: active, 1: revoked
      t.datetime :expires_at

      t.timestamps
    end
    add_index :api_keys, :token, unique: true
  end
end
