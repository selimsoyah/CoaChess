export type UserRole = 'coach' | 'player' | 'admin';

export type ConnectionStatus = 'pending' | 'accepted' | 'revoked';

export type ContentType = 'lesson' | 'puzzle';

export type AssignmentStatus = 'assigned' | 'completed' | 'skipped';

export interface User {
  id: string;
  email: string;
  display_name: string | null;
  role: UserRole;
  timezone: string;
  created_at: string;
}

export interface Connection {
  id: string;
  coach_id: string;
  player_id: string;
  status: ConnectionStatus;
  invite_token: string | null;
  created_at: string;
}

export interface Content {
  id: string;
  creator_id: string;
  title: string;
  type: ContentType;
  pgn: string | null;
  fen: string | null;
  metadata: Record<string, any> | null;
  created_at: string;
}

export interface Assignment {
  id: string;
  content_id: string;
  coach_id: string;
  player_id: string;
  status: AssignmentStatus;
  assigned_at: string;
  due_date: string | null;
  completed_at: string | null;
}

export interface Message {
  id: string;
  connection_id: string;
  sender_id: string;
  body: string;
  created_at: string;
}

export interface Session {
  id: string;
  connection_id: string;
  scheduled_at: string;
  notes: string | null;
}
