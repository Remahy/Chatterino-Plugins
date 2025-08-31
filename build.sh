#!/bin/sh

set -e

build_pkg() {
  name="${1}"
  ref="${2}"

  file="${name}/info.json"
  if [ ! -f "${file}" ]; then
    echo "error: file ${file} not found"
    exit 1
  fi

  version=$(jq --raw-output '.version' "${file}")
  if [ "${version}" = "null" ]; then
    echo "error: file ${name}/info.json is missing required parameter: version"
    exit 1
  fi

  if [ -n "${CI}" ]; then
    if [ "${ref}" != "${version}" ]; then
      echo "error: ref ${ref} does not match version ${version}"
      exit 1
    fi
  fi

  git ls-files --cached --exclude-standard --others "${name}" | zip "dist/${name}-v${version}.zip" -@
}

run_ci() {
  build_pkg "${GIT_PKG:?GIT_PKG must be set}" "${GIT_REF:?GIT_REF must be set}"
}

run_shell() {
  for dir in */; do
    dir="${dir%*/}"
    [ "${dir}" = "dist" ] && continue
    build_package "${dir}" ""
  done
}

main() {
  mkdir -p "./dist/"

  if [ -n "${CI}" ]; then
    run_ci
  else
    run_shell
  fi
}

main
