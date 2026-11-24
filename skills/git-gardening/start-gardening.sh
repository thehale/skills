#!/usr/bin/env bash
# Copyright (c) 2026 Joseph Hale
# SPDX-License-Identifier: MPL-2.0

# Usage: start-gardening.sh

set -e

BRANCH=$(git branch --show-current)
BACKUP_BRANCH="${BRANCH}-backup"

if git show-ref --verify --quiet "refs/heads/${BACKUP_BRANCH}"; then
	echo "Error: Backup branch '${BACKUP_BRANCH}' already exists."
	echo "If you want to restart, delete it first: git branch -D ${BACKUP_BRANCH}"
	exit 1
fi

git branch "${BACKUP_BRANCH}"
echo "Created backup branch: ${BACKUP_BRANCH}"
echo "To restore if needed: git reset --hard ${BACKUP_BRANCH}"
