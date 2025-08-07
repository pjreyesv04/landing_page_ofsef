// Configuración PRODUCCIÓN - IIS Público
// DIRIS Lima Norte - Ambiente de producción en servidor IIS

module.exports = {
  environment: 'production',
  name: 'IIS Producción',
  
  // Configuración de Next.js para IIS Producción
  nextConfig: {
    output: 'export',
    basePath: '/page_ofseg_dirisln',
    assetPrefix: '/page_ofseg_dirisln',
    trailingSlash: true,
    images: {
      unoptimized: true
    }
  },
  
  // Configuración del servidor de producción
  server: {
    path: 'C:\\inetpub\\wwwroot\\page_ofseg_dirisln',
    port: 80,
    protocol: 'http',
    iis: {
      appPool: 'DefaultAppPool',
      managedRuntime: 'No Managed Code'
    }
  },
  
  // URLs de producción
  urls: {
    base: 'http://[IP-SERVIDOR]/page_ofseg_dirisln/',
    public: 'Sitio web oficial DIRIS Lima Norte'
  },
  
  // Archivos excluidos en producción (por seguridad)
  excludes: {
    testing: true,
    debugInfo: true,
    stagingInfo: true,
    productionInfo: true // Eliminar después del deployment
  },
  
  // Configuración IIS optimizada
  iisConfig: {
    webConfig: 'web.config', // Usa web.config.utf8 como principal
    compression: true,
    caching: true,
    security: 'enhanced'
  },
  
  // Configuración de seguridad
  security: {
    removeInfoFiles: true,
    optimizeHeaders: true,
    enableCompression: true,
    removeComments: false
  },
  
  // Scripts de deployment
  scripts: {
    build: 'npm run build:iis',
    prepare: '.\\sync\\sync-to-production.ps1',
    deploy: 'Copy to C:\\inetpub\\wwwroot\\page_ofseg_dirisln',
    postDeploy: 'Remove production-info.html'
  },
  
  // Checklist de producción
  checklist: [
    'Backup del sitio actual realizado',
    'Build sin errores completado',
    'Configuración UTF-8 verificada',
    'Archivos de testing removidos',
    'URLs de producción configuradas',
    'Script UTF-8 preparado para ejecución',
    'Plan de rollback definido'
  ]
}
