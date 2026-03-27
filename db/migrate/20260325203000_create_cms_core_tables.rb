class CreateCmsCoreTables < ActiveRecord::Migration[8.0]
  def change
    # 2. Taxonomy: Categories
    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: { unique: true }
      t.text :description
      t.integer :parent_id, index: true

      t.timestamps
    end

    # 2. Taxonomy: Tags
    create_table :tags do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: { unique: true }

      t.timestamps
    end

    # 1. Content: Articles
    create_table :articles do |t|
      t.string :title, null: false
      t.string :slug, null: false, index: { unique: true }
      t.text :excerpt
      t.text :content # Alternatively, Rails ActionText can be used
      t.integer :status, default: 0 # 0: draft, 1: published, 2: archived
      t.datetime :published_at
      t.references :category, null: true, foreign_key: true
      t.references :user, null: false, foreign_key: true # Author

      t.timestamps
    end

    create_table :article_tags do |t|
      t.references :article, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :article_tags, [:article_id, :tag_id], unique: true

    # 4. System Config / Settings
    create_table :settings do |t|
      t.string :key, null: false, index: { unique: true }
      t.jsonb :value, default: {}
      t.string :description

      t.timestamps
    end

    # 5. SEO Meta Data (Polymorphic)
    create_table :seo_meta do |t|
      t.references :seoable, polymorphic: true, null: false
      t.string :meta_title
      t.text :meta_description
      t.string :meta_keywords
      t.string :og_image_url

      t.timestamps
    end
    add_index :seo_meta, [:seoable_type, :seoable_id], unique: true

    # 6. Activity Tracker / Audit Logs
    create_table :activity_logs do |t|
      t.references :user, null: true, foreign_key: true
      t.string :action, null: false # e.g., 'created_article', 'updated_setting'
      t.references :trackable, polymorphic: true, null: true
      t.jsonb :changes_data, default: {} # Store what changed
      t.string :ip_address

      t.timestamps
    end
  end
end
