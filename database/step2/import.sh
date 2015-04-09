#!/bin/sh
# requires sqlite3 (3.8.8.2)

cd "$(dirname "$0")"
sqlite3 < import.sql
