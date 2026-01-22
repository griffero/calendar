# Linear Clone

A full-featured clone of Linear, built with Rails 8 and Vue 3.

## Tech Stack

### Backend
- **Rails 8** - API + realtime
- **PostgreSQL** - Database with full-text search
- **Redis** - Caching and ActionCable
- **Sidekiq** - Background jobs
- **GraphQL** - Public API
- **Pundit** - Authorization

### Frontend
- **Vue 3** - UI framework
- **TypeScript** - Type safety
- **Vite** - Build tool
- **TailwindCSS** - Styling
- **Pinia** - State management
- **TipTap** - Rich text editor

## Features

- [ ] Multi-tenant workspaces with RBAC
- [ ] Teams and projects
- [ ] Issues with custom states, priorities, and labels
- [ ] Rich text comments with mentions
- [ ] File attachments
- [ ] Real-time updates
- [ ] Keyboard-first navigation
- [ ] Command palette
- [ ] Saved views
- [ ] Cycles (sprints)
- [ ] GitHub and Slack integrations
- [ ] Billing with Stripe

## Getting Started

### Prerequisites

- Ruby 3.2+
- Node.js 22+
- PostgreSQL 16+
- Redis 7+

### Setup

1. **Clone and install dependencies**

```bash
# Install Ruby dependencies
bundle install

# Install frontend dependencies
cd client && npm install && cd ..
```

2. **Start services with Docker**

```bash
docker-compose up -d
```

3. **Setup database**

```bash
bin/rails db:create db:migrate db:seed
```

4. **Start the development servers**

```bash
# Terminal 1: Rails server
bin/rails server

# Terminal 2: Sidekiq
bundle exec sidekiq

# Terminal 3: Frontend dev server
cd client && npm run dev
```

5. **Open the app**

Visit http://localhost:5173

### Environment Variables

Copy `env.example` to `.env` and configure:

```bash
cp env.example .env
```

Key variables:
- `DATABASE_URL` - PostgreSQL connection
- `REDIS_URL` - Redis connection
- `SECRET_KEY_BASE` - Rails secret (generate with `rails secret`)
- `STRIPE_*` - Stripe API keys (for billing)

## Development

### Running Tests

```bash
# Backend tests
bundle exec rspec

# Frontend type check and lint
cd client && npm run type-check && npm run lint
```

### Code Style

```bash
# Ruby
bin/rubocop

# Frontend
cd client && npm run lint
```

### Database Migrations

```bash
bin/rails db:migrate
```

## API

### REST API (Internal)

Base URL: `/api/v1`

Authentication via session cookies with CSRF protection.

### GraphQL API (Public)

Endpoint: `/graphql`

Authentication via Bearer token in Authorization header.

Interactive playground available at `/graphiql` in development.

## Architecture

### Directory Structure

```
├── app/
│   ├── channels/       # ActionCable channels
│   ├── controllers/    # API controllers
│   ├── graphql/        # GraphQL schema
│   ├── jobs/           # Sidekiq jobs
│   ├── models/         # ActiveRecord models
│   ├── policies/       # Pundit policies
│   └── serializers/    # Blueprinter serializers
├── client/             # Vue 3 frontend
│   ├── src/
│   │   ├── api/        # API client
│   │   ├── components/ # Vue components
│   │   ├── composables/# Vue composables
│   │   ├── router/     # Vue Router
│   │   ├── stores/     # Pinia stores
│   │   └── types/      # TypeScript types
├── config/             # Rails config
├── db/                 # Migrations and seeds
└── spec/               # RSpec tests
```

### Data Model

Key entities:
- **User** - Authentication and profile
- **Workspace** - Multi-tenant container
- **Team** - Groups issues (e.g., Engineering, Design)
- **Project** - Groups related issues across teams
- **Issue** - Core entity with states, priorities, etc.
- **Cycle** - Time-boxed iterations (sprints)

### Real-time

ActionCable channels:
- `WorkspaceChannel` - Workspace-level events
- `TeamChannel` - Issue updates in a team
- `IssueChannel` - Comments, reactions, presence
- `NotificationsChannel` - User notifications

## Deployment

### Docker

```bash
docker build -t linear-clone .
docker run -p 3000:3000 linear-clone
```

### Environment

Production requires:
- PostgreSQL
- Redis
- Object storage (S3-compatible) for attachments

## License

MIT
