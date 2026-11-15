# Ajaia Docs

A lightweight collaborative document editor inspired by Google Docs, built for the Ajaia AI-Native Full Stack Developer assignment.

**Live demo:** _add Vercel URL here_
**Repository:** _add GitHub URL here_

## What it does

- Create, rename, edit, save and reopen documents
- Rich-text editing: bold, italic, underline, headings, bulleted and numbered lists
- Import a `.txt` or `.md` file as a new editable document
- Share a document with another user and see owned vs. shared documents separately
- Persistent storage, so documents and sharing survive a refresh

## Status

| Area | Status |
|---|---|
| Next.js + TypeScript + Tailwind project scaffold | Done |
| Dependencies installed (Supabase, Tiptap, marked, lucide-react, Vitest) | Done |
| Supabase project created and environment variables configured | Done |
| Access-control logic (`lib/access.ts`) | Done |
| File validation and `.txt`/`.md` to HTML conversion (`lib/fileParser.ts`) | Done |
| Type check passes (`tsc --noEmit`) | Done |
| Database schema and seed data | In progress (`supabase/schema.sql`) |
| Document list, editor and toolbar | Not started |
| File import UI | Not started |
| Sharing UI | Not started |
| Automated tests | Not started |
| Deployment (Vercel) | Not started |

## Progress log

What has been built so far, in order:

1. **Scaffold:** created the app with `create-next-app` (Next.js 16, App Router, TypeScript, Tailwind, ESLint).
2. **Dependencies:** installed `@supabase/supabase-js`, Tiptap (`@tiptap/react`, `@tiptap/pm`, `@tiptap/starter-kit`, `@tiptap/extension-underline`), `marked`, `lucide-react` and `vitest`.
3. **Dependency conflict resolved:** `vitest@5` expects `@types/node` 22 or newer while the scaffold installs version 20. Fixed with `--legacy-peer-deps` and a committed `.npmrc` so Vercel installs behave the same way.
4. **Backend connection:** created a Supabase project (Postgres, us-east-1) and wired the URL and publishable key through `.env.local`. The file is git-ignored (verified with `git check-ignore`).
5. **Core logic as pure functions:** `lib/access.ts` (who can view or edit a document) and `lib/fileParser.ts` (upload validation and HTML conversion). They have no framework dependencies, which keeps them easy to unit-test.
6. **Verification:** `ls lib` shows all three files and `npx tsc --noEmit` reports no errors.
7. **Documentation:** this README.

## Tech stack

| Layer | Choice | Why |
|---|---|---|
| Framework | Next.js 16 (App Router) + TypeScript | Frontend and API routes in one repo, one-click deploy |
| Styling | Tailwind CSS | Fast, consistent UI |
| Editor | Tiptap | Headless, stores clean HTML, ready-made formatting extensions |
| Database | Supabase (Postgres) | Hosted and free, works on serverless hosting |
| Markdown import | marked | Converts `.md` to HTML |
| Tests | Vitest | Fast unit tests for pure logic |
| Hosting | Vercel | Auto-deploys on every push |

## Users (no login by design)

To keep scope on the core product, authentication is simulated. The app has three seeded users and a user switcher, so a reviewer can test sharing without logging in and out.

| Name | Email |
|---|---|
| Alice Chen (Product) | alice@ajaia.internal |
| Bob Rivera (Engineering) | bob@ajaia.internal |
| Charlie Kim (Design) | charlie@ajaia.internal |

Seed data includes two documents, and Alice's document is already shared with Bob.

## Data model

- `users`: id, name, email, avatar_color
- `documents`: id, title, content (HTML), owner_id, created_at, updated_at
- `document_shares`: id, document_id, shared_with_user_id, permission (`view` or `edit`), unique per document and user

The full schema and seed data are in `supabase/schema.sql`.

## Access rules

Implemented as pure functions in `lib/access.ts`:

- The owner can view and edit
- A user with an `edit` share can view and edit
- A user with a `view` share can only view
- Everyone else has no access

## File import

- Supported types: `.txt` and `.md` only
- Maximum size: 1 MB
- Empty files and other types are rejected with a clear message
- `.md` files are converted to HTML. `.txt` paragraphs become `<p>` blocks

## Run locally

**Prerequisites:** Node.js 20.9 or newer, npm, and a free Supabase account.

1. Clone and install:
   ```bash
   git clone <your-repo-url>
   cd ajaia-docs
   npm install
   ```
   The repo includes an `.npmrc` with `legacy-peer-deps=true`, which resolves a Vitest peer-dependency conflict with `@types/node`.

2. Create a Supabase project, open **SQL Editor**, paste the contents of `supabase/schema.sql` and click **Run**. This creates the tables and seeds three users, two documents and one share.

3. Create `.env.local` in the project root (find both values under Supabase **Project Settings, API Keys**):
   ```
   NEXT_PUBLIC_SUPABASE_URL=https://your-project-id.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your-publishable-key
   ```

4. Start the app:
   ```bash
   npm run dev
   ```
   Open http://localhost:3000.

## Project structure

```
app/                 Next.js pages and layout
lib/
  supabase.ts        Supabase client and shared types
  access.ts          Ownership and share permission logic
  fileParser.ts      Upload validation and .txt/.md to HTML conversion
supabase/
  schema.sql         Tables, seed users, seed documents, seed share
next.config.ts       Next.js configuration
.npmrc               legacy-peer-deps=true (Vitest peer dependency workaround)
AGENTS.md            Generated by Next.js for AI coding agents
```

## Known limitations

- Simulated users instead of real authentication
- Row-level security is disabled for prototype speed. Access control lives in the application layer, so this setup is not production-grade
- Imported Markdown is not sanitized beyond the editor's own HTML filtering
- No real-time co-editing

## Next steps (with 2 to 4 more hours)

- Real authentication and Supabase row-level security policies
- Version history and Markdown or PDF export
- Real-time presence indicators
- `.docx` import
