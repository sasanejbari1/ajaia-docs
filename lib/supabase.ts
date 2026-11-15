import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export interface User {
  id: string;
  name: string;
  email: string;
  avatar_color: string;
}

export interface DocumentRecord {
  id: string;
  title: string;
  content: string;
  owner_id: string;
  created_at: string;
  updated_at: string;
  owner?: User;
}

export interface DocumentShare {
  id: string;
  document_id: string;
  shared_with_user_id: string;
  permission: 'view' | 'edit';
  user?: User;
}
