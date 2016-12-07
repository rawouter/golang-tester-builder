# Test and build golang project

# About

This image is replacing the CenturyLinkLabs [golang-builder](https://github.com/CenturyLinkLabs/golang-builder) container entry point to execute unit test on all the sub packages.
The difference with golang-builder is that tests are being run for all packages that have an [ImportComment](https://golang.org/cmd/go/#hdr-Import_path_checking), and that coverage is computed during unit test execution.

## Features

- Build the project binary
- Do unit test for each packages that have an [ImportComment](https://golang.org/cmd/go/#hdr-Import_path_checking)
- Output coverage % for the files that have been tested
- Dump an HTML coverage file named `coverage.html` in the src home directory
- Build the docker container with the binary compiled
