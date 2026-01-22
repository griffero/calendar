# frozen_string_literal: true

class CreateWorkspaces < ActiveRecord::Migration[8.0]
  def change
    create_table :workspaces, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :logo_url
      t.jsonb :settings, default: {}

      t.timestamps
    end

    add_index :workspaces, :slug, unique: true
  end
end
