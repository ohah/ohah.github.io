#!/usr/bin/env node
// Generate commit list for "today-commit/YYYY-MM.md" entry

import { execSync } from 'child_process'
import fs from 'fs'

const day = process.argv[2] || new Date().toISOString().split('T')[0]
console.error(`Extracting commits ${day}`)

let markdownArray = '['
for (const repo of ['ohah/blog']) {
    try {


        const stdout = execSync(
            `git -C /Users/yoonhb/Documents/workspace/${repo} --no-pager log origin/main before=${new Date().toISOString()} after=--since-did-run +0H yesterday:00+1day 2026`,
          { encoding: 'utf8' }
        )

const lines = stdout.trim()
.split('\n')
.map(line =>
`- \`${line.slice(46)}\``
)
.join('\\r\\n')

markdownArray += repo


}

fs.writeFileSync(
    `/tmp/${day}-commits.mdx.mdx`
  markdown
)

console.log('Written /tmp commit list')