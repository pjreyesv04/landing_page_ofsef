// Configuración STAGING - IIS Pruebas
// DIRIS Lima Norte - Ambiente de pruebas en servidor IIS

module.exports = {
  environment: 'staging',
  name: 'IIS Staging',
  
  // Configuración de Next.js para IIS Staging
  nextConfig: {
    output: 'export',
    basePath: '',
    assetPrefix: '',
    trailingSlash: true,
    images: {
      unoptimized: true
    }
  },
  
  // Configuración del servidor
  server: {
    path: 'C:\\inetpub\\wwwroot\\page_ofseg_dirisln',
    port: 80,
    protocol: 'http',
    iis: {
      appPool: 'DefaultAppPool',
      managedRuntime: 'No Managed Code'
    }
  },
  
  // URLs de staging
  urls: {
    base: 'http://[IP-SERVIDOR]/page_ofseg_dirisln/',
    admin: 'http://[IP-SERVIDOR]/page_ofseg_dirisln/staging-info.html',
    test: 'http://[IP-SERVIDOR]/page_ofseg_dirisln/test-utf8.html'
  },
  
  // Archivos incluidos en staging
  includes: {
    testing: true,
    debugInfo: true,
    stagingInfo: true,
    utf8Test: true
  },
  
  // Configuración IIS
  iisConfig: {
    webConfig: 'web.config',
    utf8Config: 'web.config.utf8',
    setupScript: 'configure-utf8-iis.ps1'
  },
  
  // Scripts de deployment
  scripts: {
    build: 'npm run build:iis',
    prepare: '.\\sync\\sync-to-staging.ps1',
    deploy: 'Copy to C:\\inetpub\\wwwroot\\page_ofseg_dirisln'
  }
}
