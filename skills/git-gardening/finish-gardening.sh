#!/usr/bin/env bash
# Copyright (c) 2026 Joseph Hale
# SPDX-License-Identifier: MPL-2.0

# Usage: finish-gardening.sh

set -e

BRANCH=$(git branch --show-current)
BACKUP_BRANCH="${BRANCH}-backup"

if ! git show-ref --verify --quiet "refs/heads/${BACKUP_BRANCH}"; then
	echo "Error: No backup branch '${BACKUP_BRANCH}' found."
	exit 1
fi

echo "Verifying changes match backup..."

MERGE_BASE=$(git merge-base HEAD "${BACKUP_BRANCH}")
NEW_DIFF=$(mktemp)
BACKUP_DIFF=$(mktemp)

git diff "${MERGE_BASE}" HEAD >"${NEW_DIFF}"
git diff "${MERGE_BASE}" "${BACKUP_BRANCH}" >"${BACKUP_DIFF}"

if diff "${NEW_DIFF}" "${BACKUP_DIFF}" >/dev/null; then
	echo "✓ All changes preserved - diffs match"
	rm "${NEW_DIFF}" "${BACKUP_DIFF}"

	echo "Removing backup branch: ${BACKUP_BRANCH}"
	git branch -D "${BACKUP_BRANCH}"
	echo "✓ Gardening complete"
else
	echo "✗ WARNING: Diffs do not match! Changes may have been lost."
	echo "  Compare with: diff ${NEW_DIFF} ${BACKUP_DIFF}"
	echo "  Restore with: git reset --hard ${BACKUP_BRANCH}"
	exit 1
fi
