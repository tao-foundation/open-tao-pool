#!/usr/bin/env bash

EOSC_ARCHIVE_NAME="eosc-pool-$TRAVIS_OS_NAME-$TRAVIS_TAG"
zip -j "$EOSC_ARCHIVE_NAME.zip" build/bin/open-eosc-pool
