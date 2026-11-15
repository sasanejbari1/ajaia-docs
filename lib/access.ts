import { DocumentRecord, DocumentShare } from './supabase';

export type AccessLevel = 'owner' | 'edit' | 'view' | 'none';

export function getUserAccessLevel(
  userId: string,
  document: Pick<DocumentRecord, 'owner_id'>,
  shares: Pick<DocumentShare, 'shared_with_user_id' | 'permission'>[]
): AccessLevel {
  if (!userId || !document) return 'none';
  if (document.owner_id === userId) return 'owner';

  const share = shares.find((s) => s.shared_with_user_id === userId);
  if (!share) return 'none';

  return share.permission;
}

export function canUserEdit(accessLevel: AccessLevel): boolean {
  return accessLevel === 'owner' || accessLevel === 'edit';
}
