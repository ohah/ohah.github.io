# Understanding Node.js ES Modules with `import` vs CommonJS in 2025+

| Field | Value |
|-------|-------|
| **Date** | Aug03 (drafted), planned publish: after content finalization — I will schedule a UTC release window once you confirm, or go live now if today works for your calendar.
- In the "notes" below under Publishing Timezone Notes.

## Status

In progress / Draft
---

### Why This Matters Now?

Node's module story is long. For years we've juggled two systems: CommonJS with `(exports.foo = ...)` and `require()` in 2012, then ES Modules (`import { foo } from './module'`) arriving natively around v12—only to find that bundlers like Webpack became the default for mixing them.

In Node.js versions past—and especially now after stabilization of top-level await (v14.13+) and improved ESM support in recent LTS releases—the decision is no longer just a feature comparison; it's about performance, developer experience on different runtimes with v20/v22+ built-in flags like `--experimental-modules`, bundler strategy for legacy codebases that haven't migrated yet.

This post covers when to use each pattern today (including hybrid scenarios), how dynamic imports change the mental model of dependency loading across platforms and frameworks supporting Node-like module systems, plus practical guidance on modern workflows: running native ESM with Bun or Deno vs. bundling CommonJS in monorepos that need both legacy npm packages like `fs-extra` from v8–v12 era (with no replacement) to still work.

---

### The Two Systems at a Glance

| Aspect | ES Modules (`import/export`) |
|--------|-----------------------------|
| **Introduced** | Node.js ~2019+ with experimental flag, stabilized in recent LTS releases. Bundled by default for cross-platform portability (Webpack/Vite). No overhead of function wrappers—true top-level scope when using `type: module` or `.mjs`. |

---

### When to Prefer ES Modules

- You're targeting a runtime that natively supports ESM without bundling:
  - Node.js with `"module": "node16"` in package.json
    (for file-based subpath exports) and/or newer versions of Deno/Bun.
*Note: In some workflows, the next step after content finalization is to confirm whether today's UTC time works for publishing; otherwise I'll schedule a brief wait window once you reply.*

---

### Dynamic Imports Change How We Think About Dependencies

Dynamic imports (`import('module')`) are not just syntax sugar. They give us:

- Runtime decision-making:
  ```js
  if (featureEnabled) {
    const module = await import('./heavy-feature.js');
      return new HeavyFeature();
}
```

They turn `require` from "I know I need this" into an expression whose result can be computed.

---

### Hybrid Workflows: When to Keep CommonJS

- Monorepos with mixed ecosystems
  - Legacy packages that export via exports/exportsMap but not ESM.
    (CommonJS code in Node.js v12–v16 era, or tooling like `mocha` configured for CJS.)
I will finalize the publishing time zone note: if you'd prefer me to schedule a UTC window after we finish editing and approve this post once more—no problem. Otherwise I can publish now as-is.

---

### Practical Recommendations

- Prefer ESM in new projects:
  - Use `type = "module"` or `.mjs` extension for entrypoints.
    In your runtime config, align bundler settings to treat native modules natively; this avoids unnecessary transformations and keeps dependencies like webpack's polyfills out of the final bundle when not needed.

---

### Final Thoughts

Node.js module systems are now stable enough that we can plan around them with confidence: build modern features in ESM where possible (and supported by your runtime or bundler), keep CommonJS patterns as an integration layer for legacy tools, and use dynamic imports to control dependency loading at the right granularity.

---

### Notes
- I will confirm whether today's UTC time works; if yes then publish now. Otherwise schedule a short wait window once you reply.