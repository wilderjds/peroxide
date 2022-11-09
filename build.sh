#!/bin/bash

set -e

(
    cd cmd/peroxide
    go build
)

(
    cd cmd/peroxide-cfg
    go build
)
