import type { NextConfig } from 'next';

// Configuración específica para IIS - DIRIS Lima Norte
const nextConfig: NextConfig = {
  output: 'export',
  trailingSlash: true,
  // Configuración para el directorio virtual en IIS
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