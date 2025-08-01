/**
 * Helper function to generate correct image paths for different deployments
 */
export function getImagePath(path: string): string {
  // Remove leading slash if present
  const cleanPath = path.startsWith('/') ? path.slice(1) : path;
  
  // In production, determine the correct base path
  if (process.env.NODE_ENV === 'production') {
    // Check if we're on GitHub Pages
    if (typeof window !== 'undefined' && window.location.hostname === 'pjreyesv04.github.io') {
      // GitHub Pages ya maneja /landing_page_ofsef/ automáticamente
      return `/${cleanPath}`;
    }
    // For IIS deployment
    return `/diris-lima-norte/${cleanPath}`;
  }
  
  // In development, use the path as-is with leading slash
  return `/${cleanPath}`;
}
