# frozen_string_literal: true

class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams, id: :uuid do |t|
      t.references :workspace, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.string :key, null: false
      t.text :description
      t.string :icon
      t.string :color
      t.integer :issue_counter, default: 0
      t.jsonb :settings, default: {}

      t.timestamps
    end

    add_index :teams, %i[workspace_id key], unique: true
    add_index :teams, :key

    create_table :team_memberships, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :team, null: false, foreign_key: true, type: :uuid
      t.string :role, default: "member"

      t.timestamps
    end

    add_index :team_memberships, %i[user_id team_id], unique: true
  end
end
