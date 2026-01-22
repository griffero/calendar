export interface User {
  id: string
  name: string
  email: string
  avatarUrl?: string
  timezone?: string
  role: 'owner' | 'admin' | 'member'
  createdAt?: string
  updatedAt?: string
}

export interface Team {
  id: string
  name: string
  key: string
  description?: string
  color?: string
  icon?: string
  issueCounter?: number
  settings?: Record<string, unknown>
  createdAt?: string
  updatedAt?: string
}

export interface TeamMembership {
  id: string
  userId: string
  teamId: string
  role: 'lead' | 'member'
  user?: User
  team?: Team
  createdAt?: string
  updatedAt?: string
}

export interface Project {
  id: string
  name: string
  slug: string
  description?: string
  status: 'backlog' | 'todo' | 'in_progress' | 'done' | 'canceled'
  privacy: 'public' | 'private'
  color?: string
  icon?: string
  leadId?: string
  startDate?: string
  targetDate?: string
  settings?: Record<string, unknown>
  lead?: User
  createdAt?: string
  updatedAt?: string
}

export interface ProjectMembership {
  id: string
  userId: string
  projectId: string
  role: 'lead' | 'member'
  user?: User
  project?: Project
  createdAt?: string
  updatedAt?: string
}

// Auth response types
export interface AuthResponse {
  user: User
  teams: Team[]
  projects: Project[]
}

// Issue types
export interface Issue {
  id: string
  teamId: string
  creatorId: string
  assigneeId?: string
  projectId?: string
  parentId?: string
  identifier: string
  number: number
  title: string
  description?: string
  descriptionHtml?: string
  status: IssueStatus
  priority: IssuePriority
  priorityLabel: string
  dueDate?: string
  estimate?: number
  sortOrder: number
  startedAt?: string
  completedAt?: string
  canceledAt?: string
  archivedAt?: string
  createdAt: string
  updatedAt: string
  // Associations (when included in response)
  creator?: User
  assignee?: User
  team?: Team
  project?: Project
  labels?: Label[]
  subIssues?: Issue[]
  parent?: Issue
}

export type IssueStatus = 'backlog' | 'todo' | 'in_progress' | 'in_review' | 'done' | 'canceled'

export type IssuePriority = 0 | 1 | 2 | 3 | 4

export const PRIORITY_LABELS: Record<IssuePriority, string> = {
  0: 'No priority',
  1: 'Urgent',
  2: 'High',
  3: 'Medium',
  4: 'Low'
}

export const STATUS_LABELS: Record<IssueStatus, string> = {
  backlog: 'Backlog',
  todo: 'Todo',
  in_progress: 'In Progress',
  in_review: 'In Review',
  done: 'Done',
  canceled: 'Canceled'
}

export interface Label {
  id: string
  teamId?: string
  name: string
  color: string
  description?: string
  createdAt: string
  updatedAt: string
}

export interface Comment {
  id: string
  issueId: string
  userId: string
  parentId?: string
  body: string
  bodyHtml?: string
  edited: boolean
  editedAt?: string
  createdAt: string
  updatedAt: string
  // Associations
  user?: User
  replies?: Comment[]
}

export interface IssueActivity {
  id: string
  issueId: string
  userId: string
  action: string
  field?: string
  oldValue?: string
  newValue?: string
  createdAt: string
  // Associations
  user?: User
}

// API Error
export interface ApiError {
  error?: string
  errors?: string[]
  message?: string
}
