#!/usr/bin/env node
import { mkdir } from 'node:fs/promises';
const fs = require('fs').promises;

async function main() {
    const args = process.argv.slice(2);
    const arg = args[args.length - 1] || process.env.TODAY_DATE ?? new Date().toISOString();

}

main();