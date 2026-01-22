class CreateIssues < ActiveRecord::Migration[8.0]
  def change
    create_table :issues, id: :uuid do |t|
      t.references :team, null: false, foreign_key: true, type: :uuid
      t.references :workspace, null: false, foreign_key: true, type: :uuid
      t.references :creator, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :assignee, foreign_key: { to_table: :users }, type: :uuid
      t.references :project, foreign_key: true, type: :uuid
      t.references :parent, foreign_key: { to_table: :issues }, type: :uuid

      t.string :identifier, null: false  # e.g., "ENG-123"
      t.integer :number, null: false     # Auto-incrementing per team
      t.string :title, null: false
      t.text :description
      t.text :description_html           # Rendered HTML from TipTap

      t.string :status, null: false, default: 'backlog'  # backlog, todo, in_progress, in_review, done, canceled
      t.integer :priority, null: false, default: 0       # 0=none, 1=urgent, 2=high, 3=medium, 4=low

      t.date :due_date
      t.decimal :estimate, precision: 10, scale: 2       # Story points or hours
      t.integer :sort_order, null: false, default: 0     # For drag-and-drop ordering

      t.datetime :started_at                             # When moved to in_progress
      t.datetime :completed_at                           # When moved to done/canceled
      t.datetime :canceled_at
      t.datetime :archived_at

      t.tsvector :search_vector                          # For full-text search

      t.timestamps
    end

    # Unique identifier per workspace
    add_index :issues, :identifier, unique: true
    # Unique number per team
    add_index :issues, [:team_id, :number], unique: true
    # Common query patterns
    add_index :issues, [:workspace_id, :status]
    add_index :issues, [:team_id, :status]
    add_index :issues, [:assignee_id, :status]
    add_index :issues, [:project_id, :status]
    add_index :issues, :status
    add_index :issues, :priority
    add_index :issues, :due_date
    add_index :issues, :sort_order
    add_index :issues, :created_at
    # Full-text search index
    add_index :issues, :search_vector, using: :gin

    # Create labels table
    create_table :labels, id: :uuid do |t|
      t.references :workspace, null: false, foreign_key: true, type: :uuid
      t.references :team, foreign_key: true, type: :uuid  # Team-specific or workspace-wide
      t.string :name, null: false
      t.string :color, null: false
      t.text :description

      t.timestamps
    end

    add_index :labels, [:workspace_id, :name]
    add_index :labels, [:team_id, :name]

    # Issue-label join table
    create_table :issue_labels, id: :uuid do |t|
      t.references :issue, null: false, foreign_key: true, type: :uuid
      t.references :label, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :issue_labels, [:issue_id, :label_id], unique: true

    # Comments table
    create_table :comments, id: :uuid do |t|
      t.references :issue, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :parent, foreign_key: { to_table: :comments }, type: :uuid

      t.text :body, null: false
      t.text :body_html

      t.datetime :edited_at

      t.timestamps
    end

    add_index :comments, [:issue_id, :created_at]

    # Issue history/activity tracking
    create_table :issue_activities, id: :uuid do |t|
      t.references :issue, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.string :action, null: false  # created, updated, status_changed, assigned, etc.
      t.string :field                 # Which field changed
      t.text :old_value
      t.text :new_value

      t.timestamps
    end

    add_index :issue_activities, [:issue_id, :created_at]
  end
end
