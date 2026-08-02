#!/bin/bash
# SQL 쿼리 실행 스크립트

if [ $# -eq 0 ]; then
    echo "Usage: $0 '<SQL query>'"
    exit 1
fi

echo "$QUERY" | sqlite3 "${DATABASE_URL:-./database.sqlite}"