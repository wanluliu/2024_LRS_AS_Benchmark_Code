#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
go install github.com/boyter/scc@latest
