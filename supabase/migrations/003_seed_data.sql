-- Seed data for development and testing

-- Insert test users
INSERT INTO users (id, email, display_name, role, timezone) VALUES
  ('550e8400-e29b-41d4-a716-446655440001', 'coach@test.com', 'Test Coach', 'coach', 'America/New_York'),
  ('550e8400-e29b-41d4-a716-446655440002', 'player@test.com', 'Test Player', 'player', 'America/Los_Angeles'),
  ('550e8400-e29b-41d4-a716-446655440003', 'admin@test.com', 'Admin User', 'admin', 'UTC')
ON CONFLICT (email) DO NOTHING;

-- Insert test connection
INSERT INTO connections (coach_id, player_id, status, invite_token) VALUES
  ('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', 'accepted', NULL)
ON CONFLICT (coach_id, player_id) DO NOTHING;

-- Insert sample content
INSERT INTO content (id, creator_id, title, type, pgn, fen, metadata) VALUES
  (
    '660e8400-e29b-41d4-a716-446655440001',
    '550e8400-e29b-41d4-a716-446655440001',
    'Basic Opening: King''s Pawn',
    'lesson',
    '1. e4 e5 2. Nf3 Nc6 3. Bb5',
    NULL,
    '{"difficulty": "beginner", "tags": ["opening", "ruy-lopez"]}'::jsonb
  ),
  (
    '660e8400-e29b-41d4-a716-446655440002',
    '550e8400-e29b-41d4-a716-446655440001',
    'Checkmate in 2',
    'puzzle',
    NULL,
    'r1bqkb1r/pppp1ppp/2n2n2/4p2Q/2B1P3/8/PPPP1PPP/RNB1K1NR w KQkq - 0 1',
    '{"difficulty": "intermediate", "tags": ["tactics", "checkmate"]}'::jsonb
  )
ON CONFLICT (id) DO NOTHING;

-- Insert sample assignment
INSERT INTO assignments (content_id, coach_id, player_id, status, due_date) VALUES
  (
    '660e8400-e29b-41d4-a716-446655440001',
    '550e8400-e29b-41d4-a716-446655440001',
    '550e8400-e29b-41d4-a716-446655440002',
    'assigned',
    now() + interval '7 days'
  )
ON CONFLICT DO NOTHING;

-- Insert sample message
INSERT INTO messages (connection_id, sender_id, body) VALUES
  (
    (SELECT id FROM connections WHERE coach_id = '550e8400-e29b-41d4-a716-446655440001' LIMIT 1),
    '550e8400-e29b-41d4-a716-446655440001',
    'Welcome! Let''s start with some basic opening principles.'
  )
ON CONFLICT DO NOTHING;
