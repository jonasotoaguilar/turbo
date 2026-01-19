---
name: nextjs-16
description: >
  Next.js 16 App Router patterns.
  Trigger: When working with Next.js 16 - async dynamic APIs, caching, Form component.
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "1.0"
  scope: [root, frontend]
  auto_invoke: "App Router / Server Actions"
---

## App Router File Conventions

```
app/
├── (auth)/             # Route group (no URL impact)
│   ├── login/page.tsx  # /login
│   └── signup/page.tsx # /signup
├── api/
│   └── posts/
│       └── [id]/
│           └── route.ts # API handler
├── _components/        # Private folder (not routed)
├── proxy.ts            # Proxy (Replaces middleware.ts)
├── layout.tsx          # Root layout (required)
├── page.tsx            # Home page (/)
├── loading.tsx         # Loading UI (Suspense)
├── error.tsx           # Error boundary
└── not-found.tsx       # 404 page
```

## Proxy (Replaces Middleware)

The `middleware.ts` file is deprecated in favor of `proxy.ts`. It runs on the Node.js runtime by default (Edge is not supported in `proxy.ts`). Use it for rewrites, redirects, and header manipulation.

```typescript
// proxy.ts
import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

export async function proxy(request: NextRequest) {
  // Proxy/Middleware logic here
  if (request.nextUrl.pathname.startsWith("/api-proxy")) {
    return NextResponse.rewrite(
      new URL("https://api.external.com", request.url),
    );
  }
}

export const config = {
  matcher: ["/api-proxy/:path*"],
};
```

## Client-side Data Fetching (SWR)

For client-side fetching in Next.js 16, use `swr` with a standard fetcher.

```tsx
"use client";

import useSWR from "swr";

const fetcher = (url: string) => fetch(url).then((res) => res.json());

export function Profile() {
  const { data, error, isLoading } = useSWR("/api/user", fetcher);

  if (error) return <div>Failed to load</div>;
  if (isLoading) return <div>Loading...</div>;
  return <div>Hello {data.name}!</div>;
}
```

## Optimizations & Libraries

Next.js 16 focuses on build-time optimizations and third-party management.

1.  **Packages**: `optimizePackageImports` (though Turbopack does this by default).
2.  **Third Parties**: Use `@next/third-parties` for YouTube, Google Maps, GA, etc.
3.  **Images**: Use `next/image` with `remotePatterns` for security.

```typescript
// next.config.ts
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  experimental: {
    optimizePackageImports: ["lucide-react", "lodash-es"],
  },
  images: {
    remotePatterns: [{ protocol: "https", hostname: "images.example.com" }],
  },
};
```

## Async Dynamic APIs (MANDATORY)

In Next.js 16, dynamic APIs are strictly asynchronous. Synchronous access is fully removed.

```typescript
import { cookies, headers, draftMode } from "next/headers";

export default async function Page({
  params,
  searchParams,
}: {
  params: Promise<{ id: string }>;
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>;
}) {
  // MUST await params and searchParams
  const { id } = await params;
  const { query } = await searchParams;

  // MUST await function calls
  const cookieStore = await cookies();
  const headersList = await headers();
  const { isEnabled } = await draftMode();

  return <div>ID: {id}</div>;
}
```

## Form Component

Use the native `Form` component for progressive enhancement and automatic loading states.

```typescript
import Form from "next/form";

export default function SearchPage() {
  return (
    <Form action="/search">
      <input name="query" />
      <button type="submit">Submit</button>
    </Form>
  );
}
```

## Advanced Caching (New)

Next.js 16 introduces `cacheLife` and `cacheTag` for more granular control over data caching.

```typescript
import { cacheLife, cacheTag, updateTag, refresh } from "next/cache";

export async function getData(id: string) {
  "use cache";
  cacheLife("minutes"); // profiles: seconds, minutes, hours, days, weeks, max
  cacheTag(`item-${id}`);

  return await db.items.findUnique({ where: { id } });
}

// Revalidation methods
export async function action() {
  "use server";
  await updateTag("item-123"); // Granular invalidation
  // or
  await refresh("/dashboard"); // Refresh client-side cache
}
```

## next.config.ts (Turbopack)

Turbopack is now a top-level configuration option, no longer hidden under `experimental`.

```typescript
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  turbopack: {
    // Top-level configuration for Turbopack
    resolveAlias: {
      underscore: "lodash",
    },
  },
};

export default nextConfig;
```

## Commands

```bash
# Create a new Next.js 16 project
pnpm create next-app@latest my-app --yes

# Start dev server with Turbopack
pnpm dev --turbo
```

## Keywords

nextjs, next.js, nextjs-16, app router, server components, server actions, streaming, cacheLife, cacheTag, Form component, turbopack, proxy.ts, route handlers, swr, @next/third-parties
