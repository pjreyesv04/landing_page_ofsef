// Configuración GITHUB - GitHub Pages
// DIRIS Lima Norte - Deployment en GitHub Pages

module.exports = {
  environment: 'github',
  name: 'GitHub Pages',
  
  // Configuración de Next.js para GitHub Pages
  nextConfig: {
    output: 'export',
    basePath: '/landing_page_ofsef',
    assetPrefix: '/landing_page_ofsef',
    trailingSlash: true,
    images: {
      unoptimized: true
    }
  },
  
  // URLs de GitHub
  urls: {
    repository: 'https://github.com/pjreyesv04/landing_page_ofsef',
    pages: 'https://pjreyesv04.github.io/landing_page_ofsef/',
    branch: 'master'
  },
  
  // Configuración de deployment
  deployment: {
    auto: true,
    trigger: 'push to master',
    workflow: '.github/workflows/nextjs.yml'
  },
  
  // Scripts NPM específicos
  scripts: {
    build: 'npm run build:github',
    deploy: 'git push origin master'
  },
  
  // Configuración de rutas
  paths: {
    base: '/landing_page_ofsef',
    images: '/landing_page_ofsef/images',
    assets: '/landing_page_ofsef/_next'
  }
}
