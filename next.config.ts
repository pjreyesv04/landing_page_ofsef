import type { NextConfig } from 'next';

// Configuración para PRODUCCIÓN (Servidor Live)
// Esta configuración debe usarse en el servidor final de producción
const nextConfig: NextConfig = {
  output: 'export',
  trailingSlash: true,
  // Sin basePath si el sitio está en la raíz del dominio
  // Si necesita un subdirectorio, descomentar y ajustar:
  // basePath: '/oficina-seguros',
  // assetPrefix: '/oficina-seguros',
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
