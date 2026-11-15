-- Ajaia Docs: schema and seed data
-- Run in Supabase: SQL Editor -> New query -> paste -> Run

-- 1. Users (seeded, no real auth)
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  avatar_color TEXT NOT NULL
);

-- 2. Documents
CREATE TABLE documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL DEFAULT 'Untitled Document',
  content TEXT NOT NULL DEFAULT '<p></p>',
  owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. Document shares
CREATE TABLE document_shares (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
  shared_with_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  permission TEXT NOT NULL CHECK (permission IN ('view', 'edit')) DEFAULT 'edit',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(document_id, shared_with_user_id)
);

-- Prototype only: RLS disabled, access control is enforced in the app layer
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE documents DISABLE ROW LEVEL SECURITY;
ALTER TABLE document_shares DISABLE ROW LEVEL SECURITY;

-- Seed users
INSERT INTO users (id, name, email, avatar_color) VALUES
  ('11111111-1111-1111-1111-111111111111', 'Alice Chen (Product)', 'alice@ajaia.internal', '#2563eb'),
  ('22222222-2222-2222-2222-222222222222', 'Bob Rivera (Engineering)', 'bob@ajaia.internal', '#16a34a'),
  ('33333333-3333-3333-3333-333333333333', 'Charlie Kim (Design)', 'charlie@ajaia.internal', '#9333ea');

-- Seed documents
INSERT INTO documents (id, title, content, owner_id) VALUES
  (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    'Q4 Product Roadmap & Priorities',
    '<h1>Q4 Product Roadmap</h1><p>Welcome to the <strong>Ajaia</strong> shared workspace. Here are our core priorities:</p><ul><li>Ship lightweight collaborative docs</li><li>Gather internal team feedback</li><li>Iterate on real-time sync</li></ul>',
    '11111111-1111-1111-1111-111111111111'
  ),
  (
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    'Engineering Architecture RFC',
    '<h2>System Overview</h2><p>We chose <u>Next.js and Postgres</u> for rapid iteration and clear relational modeling between documents and permissions.</p>',
    '22222222-2222-2222-2222-222222222222'
  );

-- Share Alice's doc with Bob so "Shared with Me" works out of the box
INSERT INTO document_shares (document_id, shared_with_user_id, permission) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', 'edit');
