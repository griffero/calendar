# frozen_string_literal: true

class CreateWorkspaceMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :workspace_memberships, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :workspace, null: false, foreign_key: true, type: :uuid
      t.string :role, null: false, default: "member"

      t.timestamps
    end

    add_index :workspace_memberships, %i[user_id workspace_id], unique: true
    add_index :workspace_memberships, :role
  end
end
