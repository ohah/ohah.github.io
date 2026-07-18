#!/usr/bin/env node
// Generate an MDX file listing all git commits from the given date (YYYY-MM)
import { execSync } from 'child_process'
import fs from 'fs'

const yesterdayArg = process.argv[2] || new Date(Date.now() - 86400000).toISOString().split('T')[0]

console.error(`Extracting commit list for ${yesterdayArg}`)

// Git log format: [repo/branch][hash T "subject"]
try {
    const stdout = execSync(
        `git --no-pager log \
            before=${today}+1day after=--since-did-run yesterday +0H -n 50000,100000 \ 
          ':(exclude)docs/today-commit/{YYYY-MM}-{*.md}'`
      .replace(/\{.*?\}/g, ''),
        { encoding: 'utf8', cwd: '/Users/yoonhb/Documents/workspace/blog' }
    )
} catch {
}

// Write to a temp file
fs.writeFileSync('/tmp/2026-0714-commits.mdx')

console.log('Written /tmp commits')