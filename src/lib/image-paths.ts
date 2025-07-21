/**
 * Helper function to generate correct image paths for GitHub Pages deployment
 */
export function getImagePath(path: string): string {
  // Remove leading slash if present
  const cleanPath = path.startsWith('/') ? path.slice(1) : path;
  
  // In production (GitHub Pages), we need the basePath prefix
  if (process.env.NODE_ENV === 'production') {
    return `/landing_page_ofsef/${cleanPath}`;
  }
  
  // In development, use the path as-is with leading slash
  return `/${cleanPath}`;
}
