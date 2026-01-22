# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")
    enable_extension "pg_trgm" unless extension_enabled?("pg_trgm")

    create_table :users, id: :uuid do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :name, null: false
      t.string :avatar_url
      t.string :timezone, default: "UTC"

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
