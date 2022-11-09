#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"

exec env -i "${SHDIR}"/STAR-src/source/STAR  "${@}"
