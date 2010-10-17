#!/bin/ksh

IPS_REPO="/export/install/repo"

PKG_FULL=$(echo "$REQUEST_URI" |
  sed 's,.*/manifest/0/,,'     |
  sed 's,/,%2F,'               |
  sed 's,%2f,%2F,'             |
  sed 's,%2c,%2C,'             |
  sed 's,%3a,%3A,'             |
  sed 's/,/%2C/'               |
  sed 's/:/%3A/')
PKG_NAME=$(echo "$PKG_FULL" | sed 's,@.*,,')
PKG_VERS=$(echo "$PKG_FULL" | sed 's,.*@,,')
PKG_FILE="${IPS_REPO}/pkg/${PKG_NAME}/${PKG_VERS}"

if [[ ! -f "${PKG_FILE}" ]]; then
  echo "Status: 404 Not Found"
  echo "Content-type: text/html"
  echo
  echo "<html><body>Package '${PKG_FULL}' not found.</body></html>"
else
  echo "Content-type: text/plain"
  echo
  cat "${PKG_FILE}"
fi

