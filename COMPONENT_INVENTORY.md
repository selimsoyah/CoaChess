# Component Inventory - CoaChess MVP

This document lists all UI components needed for the MVP, organized by priority and module.

## Design System Foundation

### Tokens & Utilities
- **Colors**: Primary (chess green/blue), secondary, error, success, neutral scale
- **Typography**: Headings (h1-h6), body, caption, code
- **Spacing**: 4px base scale (0.5, 1, 2, 3, 4, 6, 8, 12, 16, 24, 32, 48)
- **Breakpoints**: mobile (< 640px), tablet (640-1024px), desktop (> 1024px)

### Base Components (Priority: HIGH)
- `Button` - Primary, secondary, ghost, danger variants
- `Input` - Text, email, password, textarea
- `Select` - Dropdown selector
- `Checkbox` / `Radio` - Form controls
- `Card` - Container with optional header/footer
- `Modal` - Overlay dialog
- `Toast` - Notification system
- `Badge` - Status indicators
- `Spinner` - Loading indicator
- `Avatar` - User profile image

## Authentication Module (Priority: HIGH)

### Pages
- `/auth/login` - Login page
- `/auth/signup` - Signup with role selection
- `/auth/forgot-password` - Password reset request
- `/auth/reset-password` - Set new password

### Components
- `AuthForm` - Reusable form container for auth flows
- `RoleSelector` - Toggle/cards for coach vs player selection
- `PasswordStrengthMeter` - Visual password requirements
- `SocialAuthButtons` - OAuth providers (Phase 2)

## Chess Content Module (Priority: HIGH)

### Components
- `ChessBoard` - Interactive board using chess.js
  - Props: `fen?: string`, `pgn?: string`, `interactive: boolean`, `onMove?: callback`
  - Features: move navigation, annotations, flip board
- `ContentEditor` - PGN/FEN input form
  - Props: `initialContent?: Content`, `onSave: callback`
  - Features: validation, live preview, metadata (tags, difficulty)
- `ContentCard` - List item for content library
  - Shows: title, type, thumbnail position, tags, actions
- `ContentViewer` - Full-page content display with board
- `PGNImporter` - Paste/upload PGN files
- `FENValidator` - Real-time FEN string validation

## Dashboard Module (Priority: HIGH)

### Coach Dashboard
- `/coach` - Main coach dashboard
- `/coach/content` - Content library
- `/coach/content/new` - Create content
- `/coach/content/[id]` - Edit content
- `/coach/connections` - Manage players
- `/coach/assignments` - Track assignments

### Components (Coach)
- `CoachDashboard` - Overview with stats
- `ContentLibrary` - Grid/list of content cards with search/filter
- `ConnectionList` - List of connected players
- `InvitePlayerModal` - Send invite form
- `AssignmentTracker` - Table showing player progress
- `CreateAssignmentModal` - Select content + player + due date

### Player Dashboard
- `/player` - Main player dashboard
- `/player/assignments` - View assignments
- `/player/assignments/[id]` - Work on assignment

### Components (Player)
- `PlayerDashboard` - Overview of assigned work
- `AssignmentList` - Cards showing assignments with status
- `AssignmentCard` - Single assignment preview
- `AssignmentDetail` - Full assignment view with content
- `MarkCompleteButton` - Action to complete assignment
- `ProgressIndicator` - Visual progress (% completed)

## Messaging Module (Priority: MEDIUM)

### Pages
- `/messages` - Inbox/list of conversations
- `/messages/[connectionId]` - Conversation thread

### Components
- `MessageList` - Scrollable message thread
- `MessageBubble` - Individual message with sender info
- `MessageComposer` - Input with send button
- `ConversationList` - List of connections with unread counts
- `UnreadBadge` - Count indicator
- `TypingIndicator` - "Coach is typing..." (Phase 2)

## Profile & Settings Module (Priority: MEDIUM)

### Pages
- `/settings` - User settings
- `/profile` - Public profile view

### Components
- `ProfileForm` - Edit name, timezone, bio
- `AvatarUpload` - Image upload with crop
- `TimezonePicker` - Dropdown with search
- `NotificationSettings` - Toggle preferences
- `DeleteAccountButton` - With confirmation

## Admin Module (Priority: LOW - Post-MVP)

### Pages
- `/admin` - Admin dashboard
- `/admin/users` - User management
- `/admin/reports` - Flagged content

### Components
- `UserTable` - List with actions (ban, promote)
- `ContentModerationQueue` - Review flagged items
- `AnalyticsDashboard` - Charts and metrics

## Layout Components (Priority: HIGH)

### Global
- `Header` - Top nav with logo, user menu, notifications
- `Sidebar` - Collapsible nav (desktop) / drawer (mobile)
- `Footer` - Links to privacy, TOS, help
- `UserMenu` - Dropdown with profile, settings, logout
- `MobileNav` - Bottom nav for mobile
- `BreadcrumbNav` - Page hierarchy

## Shared/Utility Components (Priority: MEDIUM)

- `EmptyState` - "No content yet" placeholders
- `ErrorBoundary` - Catch React errors gracefully
- `ConfirmDialog` - "Are you sure?" modal
- `LoadingState` - Skeleton screens
- `SearchBar` - Global search (Phase 2)
- `DatePicker` - For due dates and scheduling
- `Pagination` - List pagination
- `FilterPanel` - Multi-select filters (tags, difficulty, etc.)
- `SortDropdown` - Sort by date, title, etc.

## Priority Matrix

### Sprint 1 (Auth & Foundation)
- Base components (Button, Input, Card, Modal, Toast)
- AuthForm, RoleSelector
- Header, Footer, basic layout

### Sprint 2 (Chess Content)
- ChessBoard component
- ContentEditor
- ContentCard, ContentViewer
- ContentLibrary

### Sprint 3 (Connections & Assignments)
- CoachDashboard, PlayerDashboard
- InvitePlayerModal, ConnectionList
- AssignmentTracker, AssignmentList
- CreateAssignmentModal, MarkCompleteButton

### Sprint 4 (Messaging)
- MessageList, MessageComposer
- ConversationList, MessageBubble

### Sprint 5 (Polish & Settings)
- ProfileForm, TimezonePicker
- EmptyState, ErrorBoundary
- LoadingState, ConfirmDialog

## Component Dependencies

```
QueryProvider (root)
  ├── Header
  ├── Sidebar
  ├── Page
  │   ├── ContentLibrary
  │   │   ├── SearchBar
  │   │   ├── FilterPanel
  │   │   └── ContentCard[]
  │   │       └── ChessBoard (preview)
  │   ├── ContentEditor
  │   │   ├── Input[]
  │   │   ├── ChessBoard (live preview)
  │   │   └── Button
  │   └── AssignmentTracker
  │       └── AssignmentCard[]
  └── Footer
```

## Implementation Notes

### State Management Pattern
- Use React Query for server state (Supabase data)
- Use component state for UI-only state (modals open/closed)
- Use context only for truly global UI state (theme, sidebar collapsed)

### Accessibility Checklist
- All interactive elements keyboard navigable
- Focus visible states
- ARIA labels on icon buttons
- Color contrast ratio ≥ 4.5:1
- Chess board: provide text alternative for moves

### Responsive Strategy
- Mobile-first Tailwind classes
- Stack vertically on mobile, grid on desktop
- Hide sidebar on mobile, show drawer
- Enlarge touch targets (min 44x44px)

## Next Steps

1. Create base component library in `src/components/ui/`
2. Create Storybook or component showcase page (optional)
3. Build authentication flow components
4. Implement ChessBoard component as a proof-of-concept
5. Iterate on dashboard layouts

Refer to this document when building each feature to ensure consistency.
