// Configuración LOCAL - Desarrollo
// DIRIS Lima Norte - Ambiente de desarrollo

module.exports = {
  environment: 'local',
  name: 'Desarrollo Local',
  
  // Configuración de Next.js para desarrollo
  nextConfig: {
    output: 'standalone',
    basePath: '',
    assetPrefix: '',
    trailingSlash: false,
  },
  
  // URLs y puertos
  devServer: {
    port: 3000,
    host: 'localhost'
  },
  
  // Configuración de imágenes
  images: {
    unoptimized: false,
    domains: ['localhost']
  },
  
  // Scripts NPM recomendados
  scripts: {
    dev: 'npm run dev',
    build: 'npm run build:iis',
    preview: 'npm run start'
  },
  
  // Configuración de debugging
  debug: {
    enabled: true,
    logLevel: 'verbose'
  }
}
