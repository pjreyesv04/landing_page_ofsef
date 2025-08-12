import type { NextConfig } from 'next';

// Configuración para DESARROLLO LOCAL
const nextConfig: NextConfig = {
  output: 'export',
  trailingSlash: true,
  // Sin basePath para desarrollo local (http://localhost:3000)
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
