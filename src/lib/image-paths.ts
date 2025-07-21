/**
 * Helper function to generate correct image paths for GitHub Pages deployment
 */
export function getImagePath(path: string): string {
  // Remove leading slash if present
  const cleanPath = path.startsWith('/') ? path.slice(1) : path;
  
  // Always use path as-is with leading slash for simplified deployment
  return `/${cleanPath}`;
}
