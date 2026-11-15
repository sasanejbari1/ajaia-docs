import { marked } from 'marked';

const ALLOWED_EXTENSIONS = ['.txt', '.md'];
const MAX_FILE_SIZE_BYTES = 1024 * 1024; // 1MB limit

export function validateUploadedFile(fileName: string, sizeBytes: number): { valid: boolean; error?: string } {
  const lowerName = fileName.toLowerCase();
  const hasValidExt = ALLOWED_EXTENSIONS.some((ext) => lowerName.endsWith(ext));

  if (!hasValidExt) {
    return { valid: false, error: 'Unsupported file type. Please upload a .txt or .md file.' };
  }
  if (sizeBytes === 0) {
    return { valid: false, error: 'The uploaded file is empty.' };
  }
  if (sizeBytes > MAX_FILE_SIZE_BYTES) {
    return { valid: false, error: 'File exceeds the 1MB size limit.' };
  }
  return { valid: true };
}

export async function parseFileContentToHtml(fileName: string, rawText: string): Promise<{ title: string; html: string }> {
  const title = fileName.replace(/\.(txt|md)$/i, '').trim() || 'Imported Document';
  const isMarkdown = fileName.toLowerCase().endsWith('.md');

  if (isMarkdown) {
    const html = await marked.parse(rawText);
    return { title, html };
  }

  // Convert plain text paragraphs to HTML <p> tags
  const paragraphs = rawText
    .split(/\r?\n\r?\n/)
    .map((p) => `<p>${p.replace(/\r?\n/g, '<br />')}</p>`)
    .join('');

  return { title, html: paragraphs || '<p></p>' };
}
