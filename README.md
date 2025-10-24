# CoaChess - Chess Coaching Platform

A scalable MVP platform for chess coaches to deliver custom content (PGN/FEN lessons and puzzles), connect with players, assign content, track progress, and communicate in real-time.

## Tech Stack

- **Frontend**: Next.js 16 (App Router) + TypeScript + Tailwind CSS
- **Backend**: Supabase (PostgreSQL + Auth + Realtime)
- **Chess Logic**: chess.js
- **State Management**: TanStack Query (React Query)
- **Deployment**: Vercel

## Getting Started

### Prerequisites

- Node.js 18+ and npm
- A Supabase account (free tier works)

### 1. Clone and Install

```bash
cd /home/salim/Desktop/coachess
npm install
```

### 2. Set Up Supabase

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to **Project Settings** → **API** and copy:
   - Project URL
   - Anon/Public key
   - (Optional) Service role key for admin operations

3. Update `.env.local` with your Supabase credentials:

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### 3. Run Database Migrations

In your Supabase project dashboard:

1. Go to **SQL Editor**
2. Run the migration files in order:
   - `supabase/migrations/001_initial_schema.sql`
   - `supabase/migrations/002_rls_policies.sql`
   - `supabase/migrations/003_seed_data.sql` (optional, adds test data)

### 4. Start Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Project Structure

```
coachess/
├── src/
│   ├── app/                    # Next.js App Router pages
│   ├── components/             # React components
│   │   └── providers/          # Context providers (React Query)
│   ├── lib/
│   │   └── supabase/           # Supabase client and server utilities
│   └── types/                  # TypeScript types and interfaces
├── supabase/
│   └── migrations/             # Database schema and policies
├── public/                     # Static assets
└── PROJECT_PLAN.md             # Detailed development plan
```

## MVP Features (Phase 1)

### Core Platform & Connection
- ✅ User roles (Coach, Player, Admin) with Supabase Auth
- ✅ User profiles with timezone support
- ✅ Coach-player connection system with invites
- ✅ Role-based dashboards

### Content Creation
- 🚧 PGN/FEN content editor
- 🚧 Interactive chess board viewer
- 🚧 Content library management

### Assignment & Tracking
- 🚧 Content assignment flow
- 🚧 Player assignment view
- 🚧 Progress tracking (assigned → completed)
- 🚧 Coach tracking dashboard

### Communication
- 🚧 Real-time messaging between coach and player
- 🚧 Simple manual scheduling notes

## Development Roadmap

See `PROJECT_PLAN.md` for the complete development plan including:
- Detailed task breakdown
- Sprint plan (6-week MVP)
- Architecture diagrams
- API specifications
- Testing strategy
- Deployment checklist

## Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint

## Contributing

This is currently in active MVP development. See the todo list and project plan for upcoming tasks.

## License

Private project - All rights reserved.
