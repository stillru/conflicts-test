#!/bin/bash

set -e

for app in app-a app-b; do
  cd /build/$app
  gcc ${app/_/-}.c -o $app
  rpmbuild -ba ${app}-*.spec
  cp ~/rpmbuild/RPMS/x86_64/${app}-*.rpm /output/
done