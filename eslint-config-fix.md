# d3 ESLint no-unused-expressions Fix

## The Issue
`node_modules/d3-timer/src/interval.js` line 8 uses comma operator:
```javascript
delay = +delay, time = ...
```
ESLint's `no-unused-expressions` complains because each part must be used.

## Solutions (pick one)

### Option A: Allow in d3 directory [RECOMMENDED]
In your `.eslintrc*`, add:

**For ESLint config object style (`{"extends": ["eslint-config-..."]}`)**:
```json
"rules": {
  "no-unused-expressions": [
    "error",
    { "allowShortCircuitExpression": true, allowTernary: false }
  ]
}
```

Or if using inline comments in source (not ideal for library code):
Add to `node_modules/d3-timer/`:
```javascript
/* eslint-disable no-unused-expressions */
export default function(...) {
...
}

// Or per-line suppression at the specific line, but since this is minified/bundled it won't apply cleanly.
```

### Option B: Ignore d3 in linting [QUICKEST]
Add to `.eslintignore`:
```text
node_modules/d3-timer/
# or just ignore entire node_modules if you're only testing app code (run ESLint from src/)
src/**/*.js  # instead of ., which picks up all files including deps.
```

### Option C: Patch d3 source temporarily [NOT RECOMMENDED]
Modify `interval.js` to split comma statement into two lines:

```javascript
// Change this one line:
delay = +d elay; // wait that doesn't make sense

function(tick) {
  let _ref;
}
```

But don't edit node_modules directly—it gets overwritten by npm install.

## My Recommendation: Option A with allowShortCircuitExpression=true if you're comfortable enabling it for the project.