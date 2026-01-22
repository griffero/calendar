# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects, id: :uuid do |t|
      t.references :workspace, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.string :icon
      t.string :color
      t.references :lead, foreign_key: { to_table: :users }, type: :uuid
      t.string :privacy, default: "public"
      t.string :status, default: "active"
      t.date :start_date
      t.date :target_date
      t.jsonb :settings, default: {}

      t.timestamps
    end

    add_index :projects, %i[workspace_id slug], unique: true
    add_index :projects, :status

    create_table :project_memberships, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :project, null: false, foreign_key: true, type: :uuid
      t.string :role, default: "member"

      t.timestamps
    end

    add_index :project_memberships, %i[user_id project_id], unique: true
  end
end
