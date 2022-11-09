#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
"${SHDIR}"/Seq2DagChainer-src/traphlor/runTraphlor "${@}"
