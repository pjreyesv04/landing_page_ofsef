import type { NextConfig } from 'next';

// Configuración para STAGING (Servidor de Pruebas)
// Ubicación: C:\inetpub\wwwroot\page_ofseg_dirisln
const nextConfig: NextConfig = {
  output: 'export',
  trailingSlash: true,
  // Configuración para el directorio virtual en IIS STAGING
  basePath: '/page_ofseg_dirisln',
  assetPrefix: '/page_ofseg_dirisln',
  typescript: {
    ignoreBuildErrors: true,
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  images: {
    unoptimized: true,
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'fonts.googleapis.com',
      },
      {
        protocol: 'https',
        hostname: 'fonts.gstatic.com',
      }
    ]
  },
  experimental: {
    optimizePackageImports: ['lucide-react']
  }
};

export default nextConfig;
