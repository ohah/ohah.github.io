# CRD Write Job - Scheduled Documentation Runner

**Purpose:** Process one or more "CRDs" from workspace, write to final output location.

---

### Workflow Steps


#### 1. Define Source Configuration
- **Source Directory**: `/cron-docs` (where tasks are defined)
   * Look for files matching `*-crd.md`
      - Example: node-connect-crd.json

**Output Location**
```
/cron-output/parsed/
├── <component>-parsed.<ext>
│ └── Processed version of the CRD with metadata
```


#### 2. For Each Source File:
1. Read file from `cron-docs/` directory (stable filename based on component name)
   - Example: `/Users/yoonhb/Documents/workspace/blog/cron-output/parsed/node-connect-crd.md`

### Output Location:


- New documents should be tracked in version history within the output dir


---

Last updated by cron job setup