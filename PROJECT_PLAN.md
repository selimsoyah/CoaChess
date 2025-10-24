Project Plan — CoaChess / Coachess-style MVP

Table of contents

1. Executive summary
2. Goals, scope & assumptions
3. Tech stack & rationale
4. Deliverables and success criteria
5. Detailed task list (by phase)
6. Data model summary
7. API & Supabase interaction patterns (RPCs & RLS summary)
8. Frontend pages & component inventory
9. UX flows and acceptance criteria
10. Sprint plan and timeline
11. Task matrix (owners, estimates, priority)
12. Testing & QA plan
13. Security, privacy & legal checklist
14. Deployment & operational checklist
15. Templates (meeting notes, test case, PR checklist)
16. How to convert to Word (.docx)
17. Appendix (sample SQL, RLS snippets, API endpoints)

---

1. Executive summary

This document records the complete development plan for building a Coachess-style platform (CoaChess). It is tailored to an MVP that is scalable and extensible: built with Next.js + Tailwind on the frontend and Supabase (Postgres/Auth/Realtime) on the backend. The MVP's goal is to allow Coaches to create chess content (PGN/FEN), connect with Players, assign content, track progress, and exchange messages.

Use this document as the canonical project plan. Each section below can be copy-pasted into Microsoft Word and formatted using Word's styles. At the end of the file are conversion instructions to generate an editable `.docx` from this Markdown using Pandoc.

2. Goals, scope & assumptions

Goals
- Deliver an MVP that validates the core value: "A coach can deliver custom chess content to a specific player and track their progress."
- Keep the platform lightweight, low-cost, and deployable on a free/low-cost tier (Vercel + Supabase free tiers).
- Design for extensibility: Phase 2 features (real-time sessions, engine analysis, payments) should plug into the schema and services without rework.

Scope (MVP)
- Roles: Coach, Player, Admin (admin for moderation)
- Coach: create PGN/FEN content, manage a content library, invite/connect to players, assign content to players, view progress
- Player: accept invites, view assigned content, mark assignments completed, message coach
- Messaging: simple text messages between coach and player
- Scheduling: manual note-based scheduling (no calendar sync for MVP)

Assumptions
- Stack: Next.js + Tailwind CSS (frontend), Supabase (backend), chess.js (PGN/FEN parsing/viewing), Vercel hosting
- Timezones: store all times in UTC, user timezone in profile for display conversion
- Payments, live video, engine analysis: excluded from MVP (Phase 2)
- Single language (English) initially

3. Tech stack & rationale

- Frontend: Next.js (TypeScript) — fast developer experience, SSR/SSG for SEO, Vercel compatibility
- Styling: Tailwind CSS — small utility-first CSS footprint, quick prototyping
- Backend: Supabase (Postgres + Auth + Realtime) — permanent free tier, built-in auth and realtime features
- Chess logic: chess.js for PGN/FEN parsing and validation
- Hosting: Vercel for frontend; Supabase hosted database and realtime
- Testing: Jest + React Testing Library; Playwright for E2E

4. Deliverables and success criteria

Deliverables
- `PROJECT_PLAN.md` (this file)
- Supabase migrations and policies (`supabase/migrations/*.sql`)
- Next.js app scaffold with pages and components
- Content editor + ChessBoard viewer
- Connections and assignments features
- Messaging with realtime updates
- Tests: unit + component + one E2E flow
- CI/CD pipeline and Vercel deployment

Success criteria (MVP)
- Coach can register, create content, and invite a player.
- Player accepts an invite, sees assigned content, and can mark it completed.
- Messaging between coach and player works in realtime.
- Data access enforced by Supabase RLS policies.
- App deploys to staging and passes the E2E assignment flow test.

5. Detailed task list (by phase)

Phase 0 — Planning & scaffold
- Finalize project brief and acceptance criteria
- Create Supabase project skeleton and local dev strategy
- Scaffold Next.js + Tailwind project with TypeScript and tooling

Phase 1 — Core data & auth
- Create `users`, `connections`, `content`, `assignments`, and `messages` tables
- Implement Supabase Auth and RLS policies for data protection
- Seed data for local dev

Phase 2 — Content editor & viewer
- Build PGN/FEN content editor (validation with chess.js)
- Build ChessBoard viewer component with navigation controls
- CRUD APIs for content

Phase 3 — Connections & assignments
- Invite/accept flows (invite token and RPCs)
- Assignment creation UI and backend actions
- Realtime notifications to player on new assignment

Phase 4 — Messaging & UX polish
- Messages table and realtime subscriptions
- Messaging UI with unread counts and basic attachments (phase 2)
- Player dashboard with assignment filters and marking complete

Phase 5 — Testing & deployment
- Unit/component tests and Playwright E2E for core flows
- CI pipeline and Vercel staging deployment
- Prepare launch checklist and monitoring

6. Data model summary

(Condensed schema — include in Word as a table)

users (id, email, display_name, role, timezone, created_at)
connections (id, coach_id, player_id, status, invite_token, created_at)
content (id, creator_id, title, type, pgn, fen, metadata, created_at)
assignments (id, content_id, coach_id, player_id, status, assigned_at, due_date, completed_at)
messages (id, connection_id, sender_id, body, created_at)
sessions (id, connection_id, scheduled_at, notes)
audit_log (id, actor_id, action, details, created_at)

7. API & Supabase interaction patterns (RPCs & RLS summary)

Recommended RPCs (Edge Functions or Supabase functions)
- rpc_create_invite(coach_id, player_email) → create connection with invite_token and send email
- rpc_assign_content(coach_id, content_id, player_id, due_date) → create assignment and notify player
- rpc_mark_complete(assignment_id, player_id) → mark assignment completed and notify coach

Row-Level Security (RLS) examples (to add as SQL policies)
- users: allow select/update where auth.uid() = id or role = 'admin'
- content: allow insert where auth.role() = 'coach'; allow update where creator_id = auth.uid(); allow select for coaches and connected players according to visibility
- assignments: allow select where coach_id = auth.uid() OR player_id = auth.uid(); allow insert where coach_id = auth.uid(); allow update for status by player_id

Include these SQL snippets in Appendix.

8. Frontend pages & component inventory

Pages
- / (Landing)
- /auth/login
- /auth/signup
- /dashboard (role-based)
- /coach/content
- /coach/content/new
- /coach/connections
- /coach/assignments
- /player/assignments
- /messages/[connection_id]
- /settings

Components (skeleton list)
- AuthForm, RoleSelector
- ContentEditor (PGN/FEN input, validation)
- ChessBoardViewer (PGN/FEN playback controls)
- AssignmentCard, AssignmentTable
- ConnectionList, InviteModal
- MessageList, MessageComposer
- TimezonePicker
- ToastNotifications, ModalConfirm

9. UX flows and acceptance criteria

A. Invite and accept
- Coach sends invite with email; connection.status = 'pending'
- Player clicks invite link, registers as 'player', connection.status becomes 'accepted'
- Acceptance criteria: both users appear in each other's dashboards

B. Assign content
- Coach selects content and a connected player, creates assignment
- Player receives realtime notification and sees assignment on dashboard
- Acceptance criteria: assignment row present, status 'assigned', player can open content and mark complete

C. Messaging
- Messages persist, display in chronological order, and update realtime
- Acceptance criteria: sending message appends to DB and displays to other party within 1-2 seconds (Supabase Realtime)

10. Sprint plan and timeline

Assuming one full-time engineer + part-time designer, 6 weeks total.

Week 0 (2-3 days): planning and scaffold
Week 1: Supabase schema + auth + RLS
Week 2: Content editor + ChessBoard viewer
Week 3: Invite flow + assignments
Week 4: Messaging + player dashboard
Week 5: Tests, staging deploy, QA
Week 6: Buffer, polish, launch prep

(Include Gantt/table in Word — use Word's table or SmartArt)

11. Task matrix (owners, estimates, priority)

Include a table in Word with columns: Task, Owner, Estimate (hours), Priority (High/Medium/Low), Dependencies, Acceptance Criteria

Example rows:
- Scaffold repo — Owner: Dev — Estimate: 8h — Priority: High — Dependencies: none
- Create users table & Auth — Dev — 12h — High — Dependencies: scaffold
- Content editor component — Dev — 24h — High — Dependencies: users
- ChessBoard viewer — Dev — 16h — High — Dependencies: content editor
- Invite flow RPC + emails — Dev — 12h — High — Dependencies: users
- Assignments flow + notifications — Dev — 16h — High — Dependencies: content, connections
- Messaging — Dev — 20h — High — Dependencies: connections

12. Testing & QA plan

- Unit tests: target critical utility code (PGN parsing, timezone conversion)
- Component tests: ContentEditor, ChessBoardViewer, Assignment flows
- E2E tests: invite+accept and assignment+complete using Playwright
- Test data: provide fixtures/seed data for faster QA

13. Security, privacy & legal checklist

- Enforce Supabase RLS policies
- Use HTTPS and secure cookies
- Passwords hashed by Supabase Auth (handled)
- Implement data export and deletion endpoints for GDPR
- Privacy policy & TOS drafted and linked in footer

14. Deployment & operational checklist

- CI: lint, test, build
- Staging: auto-deploy previews for PRs, staging branch to staging project
- Backups: Supabase daily backups enabled
- Monitoring: Sentry + Vercel analytics
- Recovery: document restore-from-backup steps in `OPERATIONS.md`

15. Templates (copy into Word)

Meeting notes template
- Date:
- Attendees:
- Agenda:
- Decisions:
- Action items (Owner — Due date):

Test case template
- Test name:
- Preconditions:
- Steps:
- Expected result:
- Actual result:
- Status (pass/fail):

PR checklist (developer)
- [ ] Linked issue
- [ ] Unit tests added/updated
- [ ] Linted and formatted
- [ ] CI green
- [ ] Reviewed by 1+ teammate

16. How to convert to Word (.docx)

Option A (quick, recommended): use Pandoc locally to convert the Markdown to `.docx`.

Install pandoc (Ubuntu example):

```bash
sudo apt update
sudo apt install -y pandoc
```

Convert:

```bash
pandoc PROJECT_PLAN.md -o PROJECT_PLAN.docx --toc --toc-depth=2
```

This produces a Word document with a table of contents. Open the `.docx` in Word and apply styles or SmartArt for Gantt charts.

Option B: Copy-paste sections directly into Word and use Word's Heading styles for the TOC.

17. Appendix (sample SQL, RLS snippets, API endpoints)

Sample table creation (Postgres / Supabase-compatible)

```sql
-- users
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  display_name text,
  role text NOT NULL CHECK (role IN ('coach','player','admin')),
  timezone text DEFAULT 'UTC',
  created_at timestamptz DEFAULT now()
);

-- content
CREATE TABLE IF NOT EXISTS content (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  creator_id uuid REFERENCES users(id) ON DELETE CASCADE,
  title text NOT NULL,
  type text NOT NULL CHECK (type IN ('lesson','puzzle')),
  pgn text,
  fen text,
  metadata jsonb,
  created_at timestamptz DEFAULT now()
);

-- assignments
CREATE TABLE IF NOT EXISTS assignments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  content_id uuid REFERENCES content(id) ON DELETE CASCADE,
  coach_id uuid REFERENCES users(id),
  player_id uuid REFERENCES users(id),
  status text NOT NULL CHECK (status IN ('assigned','completed','skipped')) DEFAULT 'assigned',
  assigned_at timestamptz DEFAULT now(),
  due_date timestamptz,
  completed_at timestamptz
);

-- messages
CREATE TABLE IF NOT EXISTS messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  connection_id uuid,
  sender_id uuid REFERENCES users(id),
  body text,
  created_at timestamptz DEFAULT now()
);
```

Sample RLS policy (Supabase)

```sql
-- enable RLS
ALTER TABLE content ENABLE ROW LEVEL SECURITY;

-- allow creators to insert
CREATE POLICY "content_insert_by_creator" ON content
  FOR INSERT
  WITH CHECK (auth.role() = 'coach' AND creator_id = auth.uid());

-- allow creators to update their content
CREATE POLICY "content_update_by_creator" ON content
  FOR UPDATE
  USING (creator_id = auth.uid());

-- allow select for public content or connected users (example requires connection join)
```

API endpoint sketches

- POST /api/invite { coachId, playerEmail } -> server creates connection, sends email
- POST /api/assign { coachId, contentId, playerId, dueDate } -> create assignment
- POST /api/messages { connectionId, senderId, body } -> insert message

---

End of document

