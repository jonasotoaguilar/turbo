import type { NextConfig } from 'next'

const nextConfig: NextConfig = {
  output: 'standalone',
  transpilePackages: ['@frontend/types', '@frontend/ui'],
  experimental: {
    optimizePackageImports: ['lucide-react']
  }
}

export default nextConfig
