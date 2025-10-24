-- Row-Level Security (RLS) Policies for CoaChess

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE connections ENABLE ROW LEVEL SECURITY;
ALTER TABLE content ENABLE ROW LEVEL SECURITY;
ALTER TABLE assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

-- Users policies
-- Users can view their own profile
CREATE POLICY "users_select_own" ON users
  FOR SELECT
  USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "users_update_own" ON users
  FOR UPDATE
  USING (auth.uid() = id);

-- Admins can view all users
CREATE POLICY "users_select_admin" ON users
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Connections policies
-- Coaches can create connections
CREATE POLICY "connections_insert_coach" ON connections
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role = 'coach'
    ) AND coach_id = auth.uid()
  );

-- Users can view their own connections
CREATE POLICY "connections_select_own" ON connections
  FOR SELECT
  USING (coach_id = auth.uid() OR player_id = auth.uid());

-- Users can update connections they're part of
CREATE POLICY "connections_update_own" ON connections
  FOR UPDATE
  USING (coach_id = auth.uid() OR player_id = auth.uid());

-- Content policies
-- Coaches can create content
CREATE POLICY "content_insert_coach" ON content
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role = 'coach'
    ) AND creator_id = auth.uid()
  );

-- Creators can update their content
CREATE POLICY "content_update_creator" ON content
  FOR UPDATE
  USING (creator_id = auth.uid());

-- Creators can delete their content
CREATE POLICY "content_delete_creator" ON content
  FOR DELETE
  USING (creator_id = auth.uid());

-- Coaches can view their own content
CREATE POLICY "content_select_creator" ON content
  FOR SELECT
  USING (creator_id = auth.uid());

-- Players can view content assigned to them
CREATE POLICY "content_select_assigned" ON content
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM assignments
      WHERE assignments.content_id = content.id
        AND assignments.player_id = auth.uid()
    )
  );

-- Assignments policies
-- Coaches can create assignments for their connected players
CREATE POLICY "assignments_insert_coach" ON assignments
  FOR INSERT
  WITH CHECK (
    coach_id = auth.uid() AND
    EXISTS (
      SELECT 1 FROM connections
      WHERE connections.coach_id = auth.uid()
        AND connections.player_id = assignments.player_id
        AND connections.status = 'accepted'
    )
  );

-- Users can view assignments they're part of
CREATE POLICY "assignments_select_own" ON assignments
  FOR SELECT
  USING (coach_id = auth.uid() OR player_id = auth.uid());

-- Players can update their assignment status
CREATE POLICY "assignments_update_player" ON assignments
  FOR UPDATE
  USING (player_id = auth.uid())
  WITH CHECK (player_id = auth.uid());

-- Coaches can update assignments they created
CREATE POLICY "assignments_update_coach" ON assignments
  FOR UPDATE
  USING (coach_id = auth.uid())
  WITH CHECK (coach_id = auth.uid());

-- Messages policies
-- Users can send messages in connections they're part of
CREATE POLICY "messages_insert_own" ON messages
  FOR INSERT
  WITH CHECK (
    sender_id = auth.uid() AND
    EXISTS (
      SELECT 1 FROM connections
      WHERE connections.id = messages.connection_id
        AND (connections.coach_id = auth.uid() OR connections.player_id = auth.uid())
        AND connections.status = 'accepted'
    )
  );

-- Users can view messages in their connections
CREATE POLICY "messages_select_own" ON messages
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM connections
      WHERE connections.id = messages.connection_id
        AND (connections.coach_id = auth.uid() OR connections.player_id = auth.uid())
    )
  );

-- Sessions policies
-- Coaches can create sessions for their connections
CREATE POLICY "sessions_insert_coach" ON sessions
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM connections
      WHERE connections.id = sessions.connection_id
        AND connections.coach_id = auth.uid()
        AND connections.status = 'accepted'
    )
  );

-- Users can view sessions in their connections
CREATE POLICY "sessions_select_own" ON sessions
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM connections
      WHERE connections.id = sessions.connection_id
        AND (connections.coach_id = auth.uid() OR connections.player_id = auth.uid())
    )
  );

-- Coaches can update/delete sessions they created
CREATE POLICY "sessions_update_coach" ON sessions
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM connections
      WHERE connections.id = sessions.connection_id
        AND connections.coach_id = auth.uid()
    )
  );

CREATE POLICY "sessions_delete_coach" ON sessions
  FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM connections
      WHERE connections.id = sessions.connection_id
        AND connections.coach_id = auth.uid()
    )
  );

-- Audit log policies
-- Only admins can view audit logs
CREATE POLICY "audit_log_select_admin" ON audit_log
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Anyone authenticated can insert audit logs (application level)
CREATE POLICY "audit_log_insert_all" ON audit_log
  FOR INSERT
  WITH CHECK (auth.uid() IS NOT NULL);
