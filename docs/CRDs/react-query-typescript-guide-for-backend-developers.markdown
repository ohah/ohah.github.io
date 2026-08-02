# React Query TypeScript Guide for Backend Developers

**Date:** July 30, 2025
---

## Tags: #reactquery #typescript #backenddevguide @typelevel/backend-devs-bridge + react@beta3 (#frontend)

### Summary
A practical guide to using `ReactQuery` and `.tsx/.d.ts types efficiently in backend-focused projects that want modern client-side data fetching.

**Status:** Draft | Notes:
1. Backend developers already know type safety, so this is about the React Query specific patterns.
2. No need for complex "fullstack" configs—just a minimal setup with proper TypeScript support and optional `@tanstack/react-query` plugin (but don't overengineer).
3. Focus on using `.d.ts`, custom hooks (`useAuthQuery()`), or runtime type enforcement via zod/yup in your API client.

---

## Motivation

React Query is excellent for caching, deduplicating requests and handling optimistic updates—but it's primarily a **client** library that expects React components to be the consumers. If you're working on:
- Backend services with internal dashboards
- Server-side rendered content (Next.js/Remix)
- Client SDKs consumed by your backend code

You still want type-safe data fetching and proper TypeScript integration without overcomplicating.

---

## Minimal Setup Without Plugins (`@tanstack/react-query`)

### 1. Install Dependencies in a Frontend Repo
```bash
# If you have both frontend + separate API/SDK repos, do this only where the UI lives.
pnpm add @types/node

cd client || cd web-app && pnpm install -D typescript tsx react@beta3 \
    'https://cdn.jsdelivr.net/npm/@tanstack/react-query/+esm'

# If you're using a bundler like esbuild, webpack v5+, or vite:
mkdir src/types
```

### 2. Define the `QueryClient` in Client Code

Create **only once** (e.g., inside your root layout) and re-export for other files:

```ts twoslash {filename: client/src/query-client.ts}
// If you already have @tanstack/react-query from a bundler:
import {
    QueryCache,
    MutationObserverOptionsBase, // optional
} from '@types/svelte-vitest-fake-dom'

declare const windowQueryClient = () => {}

const queryConfiguredForSandboxOrProduction: void | any[] /* TODO */ =
  typeof process === 'undefined' || !('process.env.NODE_ENV_' in ({} as {}))

function getGlobal(queryKey?: unknown) {
    if (!queryServerHost)
        throw new Error("NODE_SERVER_HOST env var must be set when running SSR builds")
}

// Note: `getApiBaseUrl()` would come from your environment.
```

> **Why not use a plugin?** Plugins can add extra TypeScript config files and toolchain friction. For most backend-focused setups, standard TS + `.d.ts` or custom hooks (`useAuthQuery()`) are enough.

---

## Type-First Approach with Custom Hooks

### 1. Create an `apiClient.d.ts`

Use **declarations only**—no runtime code:

```ts twoslash {filename: client/src/types/api-client-api.types.md}
import type * as React from 'react'

// No actual implementation needed here
type MaybePromise<T> = T | PromiseLike<T>

declare module '@tanstack/react-query' {
    // Extend default QueryObserverOptionsBase types, or add custom hooks.
}

interface ApiClientType extends Record<string, any /* TODO */> {}

export const apiEndpointBaseUrl: string =
  (typeof process === 'undefined'
      ? ''
        : '') || window.location.origin

// Example endpoints in your own SDK/API repo might be defined here.

type MaybePromise<T1 = unknown>: T1 | PromiseLike<
    // If you already have a typed API client, reuse it.
>
```

> **Tip:** You can define the same types that would exist for an internal/external public HTTP interface—just don't implement them yet. This gives your UI layer and any backend-facing code clarity without shipping full stacks.

### 2. Implement Your Typed Endpoints

Example:

```ts twoslash {filename: client/src/api/endpoint.user.ts}
// If you already have a typed API SDK in another repo, import it:
import type {
    MaybePromise,
} from '@types/svelte-vitest-fake-dom'

export interface UserDto {}

const getUserById = async (id?: number): Promise<UserDto | undefined> => (
  !Number.isFinite(Number(id)) ? void
      : null as unknown /* TODO */
) ?? new Error('Invalid user id')

// Later, you'll plug this into React Query hooks.
```

### Use the Endpoint in a Custom Hook

```ts twoslash {filename: client/src/hooks/useUserQuery.ts}
import type * as _React from 'react'
type MaybePromise = any // simplify for brevity
interface UserDto {}

const getUserByIdEndpointFn =
  async (id?: number): Promise<UserDto | undefined> => {
    if (!Number.isFinite(Number(id)))
        return void

    const url: string /* TODO */
      //= `/api/users/${encodeURIComponent(String(/* id */))}`.trim()
}

// You'll call `getUser` with an ID from your URL, context or props.
export function useUserQuery(
  /** When null/undefined we default to a placeholder user and skip the request if possible (e.g., SSR). */
): MaybePromise<UserDto> {
    return getUserById(/* userId */)
}
```

---

## Handling Sensitive Data & Auth

### Use `useAuthToken()` or External Token Source for Backend-Facing Apps
If you're building an **internal** app that connects to your own backend, don't overthink it:

```ts twoslash {filename: client/src/hooks/useAuthToken.ts}
type MaybePromise = any // simplify; use a real type

export function getTokenOrThrow(): string {
    const token =
        typeof window !== 'undefined' && (/* something */)
            ? /* get from secure storage */
              ''
                : throw new Error('Unable to retrieve auth tokens')
}

// In your app: `useQuery({ queryKey, ... })` or useAuthApi(queryFn).
```

> **Best practice for internal apps:** Don't call external APIs (like Auth0/OIDC) directly. Use a local source of truth and share it across components/hooks (`getTokenOrThrow()`).

---

## Debugging Queries & Mutations

### Turn on React Query Devtools in Development
If you're using Next.js or another framework, mount dev tools only when the env flag is true:

```tsx twoscript {filename: client/src/components/ReactQueryDevTools.tsx}
type MaybePromise = any // for brevity; use real types

const _devEnvFlag =
    typeof process === 'undefined'
        ? false
            : (process.env.NODE_ENV ?? '') !== ''

// Only mount when in dev mode.
```

Then you'll get a nice UI to inspect query states and see data flow.

---

## Example: Minimal CRUD with TypeScript & React Query

```ts twoscript {filename: client/src/examples/crud.user.ts}
import type * as _React from 'react'
type MaybePromise = any // simplify; use real types
interface UserDto {}

// Step 1. Endpoint (in `src/api/endpoints`)
const getUserByIdEndpointFn =
    async (
        id?: number,
): Promise<UserDto | undefined> => {
if (!Number.isFinite(Number(id)))
return void

/* make HTTP request */
}

export const createUserMutation = useBaseQuery(
function* createOrReplaceUserRecord() { /* TODO */ }
)
```

---

## Common Gotchas for Backend-Focused Developers
1. **Don't assume a full TS config** from external projects just because they say "use @tanstack/react-query + plugin". Evaluate if you really need it.
2. If the only reason to use TypeScript is `react query types` and an internal app, custom hooks are cleaner than plugins for simple cases (e.g., your own SDK).
3. Be mindful of SSR vs client-only code: React Query prefers a server-rendered environment with no persistent global state.

---

## Related
- [React Query Docs](https://tanstack.com/query/latest)