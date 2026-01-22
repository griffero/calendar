# frozen_string_literal: true

# Clear existing data
puts "Clearing existing data..."
ProjectMembership.destroy_all
Project.destroy_all
TeamMembership.destroy_all
Team.destroy_all
WorkspaceMembership.destroy_all
Workspace.destroy_all
User.destroy_all

# Create demo user
puts "Creating demo user..."
demo_user = User.create!(
  name: "Demo User",
  email: "demo@example.com",
  password: "password123"
)

# Create additional users
puts "Creating additional users..."
users = [
  User.create!(name: "Alice Smith", email: "alice@example.com", password: "password123"),
  User.create!(name: "Bob Johnson", email: "bob@example.com", password: "password123"),
  User.create!(name: "Carol Williams", email: "carol@example.com", password: "password123")
]

# Create demo workspace
puts "Creating demo workspace..."
workspace = Workspace.create!(
  name: "Acme Inc",
  slug: "acme"
)

# Make demo user the owner
WorkspaceMembership.create!(user: demo_user, workspace: workspace, role: "owner")

# Add other users as members
users.each do |user|
  WorkspaceMembership.create!(user: user, workspace: workspace, role: "member")
end

# Create teams
puts "Creating teams..."
eng_team = Team.create!(
  workspace: workspace,
  name: "Engineering",
  key: "ENG",
  description: "Product engineering team",
  color: "#5e6ad2"
)

design_team = Team.create!(
  workspace: workspace,
  name: "Design",
  key: "DES",
  description: "Product design team",
  color: "#f2994a"
)

# Add team memberships
TeamMembership.create!(user: demo_user, team: eng_team, role: "lead")
TeamMembership.create!(user: users[0], team: eng_team, role: "member")
TeamMembership.create!(user: users[1], team: eng_team, role: "member")
TeamMembership.create!(user: users[0], team: design_team, role: "lead")
TeamMembership.create!(user: users[2], team: design_team, role: "member")

# Create projects
puts "Creating projects..."
project1 = Project.create!(
  workspace: workspace,
  name: "Mobile App",
  description: "New mobile application",
  lead: demo_user,
  status: "active",
  color: "#0ea5e9"
)

project2 = Project.create!(
  workspace: workspace,
  name: "Website Redesign",
  description: "Complete website overhaul",
  lead: users[0],
  status: "active",
  color: "#8b5cf6"
)

# Add project memberships
ProjectMembership.create!(user: demo_user, project: project1, role: "lead")
ProjectMembership.create!(user: users[0], project: project1, role: "member")
ProjectMembership.create!(user: users[0], project: project2, role: "lead")
ProjectMembership.create!(user: users[2], project: project2, role: "member")

puts "Seeds completed!"
puts "Login with: demo@example.com / password123"
