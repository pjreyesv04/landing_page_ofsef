/**
 * Helper function to generate correct image paths for different deployments
 */
export function getImagePath(path: string): string {
  // Remove leading slash if present
  const cleanPath = path.startsWith('/') ? path.slice(1) : path;
  
  // In production, determine the correct base path
  if (process.env.NODE_ENV === 'production') {
    // Check if we're on GitHub Pages (by checking if the current URL contains the repo name)
    if (typeof window !== 'undefined' && window.location.hostname === 'pjreyesv04.github.io') {
      return `/landing_page_ofsef/${cleanPath}`;
    }
    // Otherwise assume IIS deployment
    return `/diris-lima-norte/${cleanPath}`;
  }
  
  // In development, use the path as-is with leading slash
  return `/${cleanPath}`;
}
