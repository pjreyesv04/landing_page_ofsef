import type { NextConfig } from 'next';

// Configuración para GitHub Pages 
const nextConfig: NextConfig = {
  output: 'export',
  trailingSlash: true,
  // GitHub Pages maneja automáticamente /landing_page_ofsef en la URL
  // Configuramos basePath para que coincida con el repositorio
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
