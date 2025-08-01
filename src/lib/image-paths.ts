/**
 * Helper function to generate correct image paths for different deployments
 */
export function getImagePath(path: string): string {
  // Remove leading slash if present
  const cleanPath = path.startsWith('/') ? path.slice(1) : path;
  
  // In production, determine the correct base path
  if (process.env.NODE_ENV === 'production') {
    // Check if we're building for GitHub Pages
    // During build time, assume GitHub Pages deployment
    const isGitHubPages = typeof window !== 'undefined' 
      ? window.location.hostname === 'pjreyesv04.github.io'
      : true; // Default to GitHub Pages for static build
    
    if (isGitHubPages) {
      // GitHub Pages con basePath configurado
      return `/landing_page_ofsef/${cleanPath}`;
    }
    // For IIS deployment
    return `/diris-lima-norte/${cleanPath}`;
  }
  
  // In development, use the path as-is with leading slash
  return `/${cleanPath}`;
}
