import type { NextConfig } from 'next';

// Determinar el basePath según el entorno de despliegue
// Para GitHub Pages usamos basePath, para IIS también
const nextConfig: NextConfig = {
  output: 'export',
  trailingSlash: true,
  // Configuración para GitHub Pages (por defecto)
  basePath: '/landing_page_ofsef',
  assetPrefix: '/landing_page_ofsef',
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
        hostname: 'placehold.co',
        port: '',
        pathname: '/**',
      },
      {
        protocol: 'https',
        hostname: 'cdn.pixabay.com',
        port: '',
        pathname: '/**',
      },
      {
        protocol: 'https',
        hostname: 'images.unsplash.com',
        port: '',
        pathname: '/**',
      }
    ],
  },
};

export default nextConfig;
