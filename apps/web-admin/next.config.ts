import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  /* config options here */
  reactCompiler: true,
  images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "pub-4e12664ec9494c0b8774528892357583.r2.dev",
      },
    ],
  },
};

export default nextConfig;
