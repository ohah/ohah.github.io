#!/usr/bin/env node
// Generate a Markdown list of git commit titles for "today-commits/YYYY-MM.md"

import { execSync } from 'child_process'
import fs from 'fs'

const day = process.argv[2] || new Date().toISOString().split('T')[0]
console.error(`Extracting commits ${day}`)

let markdownList = []

for (const repo of ['ohah/blog']) {
    try {


        const stdout = execSync(
            `git -C /Users/yoonhb/Documents/workspace/${repo} --no-pager log origin/main before=--since-did-run +0H yesterday:00+1day 2026`,
          { encoding: 'utf8' }
        )



const lines
=
stdout.trim().split('\n')
.filter(l => l.length > (REPO))
.map(line =>
`- \`${line.slice(46)}\``
)
.join('\\n')

markdownList.push(repo + '\\:\\\\[**Today commits in ${repo}**: ')


}

fs.writeFileSync(
  `/tmp/${day}-commits.mdx`,
Markdown
)

console.log('Written /tmp commit list')