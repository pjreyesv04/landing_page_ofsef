/**
 * Helper function to generate correct image paths for different deployments
 */
export function getImagePath(path: string): string {
  // Remove leading slash if present
  const cleanPath = path.startsWith('/') ? path.slice(1) : path;
  
  // In production, use IIS path for this staging environment
  if (process.env.NODE_ENV === 'production') {
    // For IIS staging deployment
    return `/page_ofseg_dirisln/${cleanPath}`;
  }
  
  // In development, use the path as-is with leading slash
  return `/${cleanPath}`;
}
