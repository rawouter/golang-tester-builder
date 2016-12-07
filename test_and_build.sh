#!/bin/bash -e
set -o pipefail # This will break execution when tests fail in the pipe command

ln -s /src /go/src/worker

source /build_environment.sh

# Compile statically linked version of package
echo "Building $pkgName"
`CGO_ENABLED=${CGO_ENABLED:-0} go build ${FLAGS:-} --ldflags="${LDFLAGS:-}" --gcflags "${LDFLAGS:--N -l}" $pkgName`


# Run tests and compute coverage
echo "Test and coverage for all"
echo "mode: set" > acc.out

go get -u github.com/jstemmer/go-junit-report
for x in $(go list -e -f '{{.ImportComment}}'  ./...);
do
    echo ">> Running tests for $x"
    go test -coverprofile=profile.out -v $x|go-junit-report -set-exit-code>${x##*/}.xml;
    if [ $? -ne 0  ]; then
      echo "Test failed for $x"
      exit $?
    fi
    if [ -f profile.out  ]; then
        cat profile.out | grep -v "mode: set" >> acc.out;
        rm profile.out
    fi
done
go tool cover -func=acc.out
go tool cover -html=acc.out -o /src/coverage.html
rm acc.out


# Grab the last segment from the package name
name=${pkgName##*/}

if [[ $COMPRESS_BINARY == "true" ]];
then
  goupx $name
fi

if [ -e "/var/run/docker.sock" ] && [ -e "./Dockerfile" ];
then
  # Default TAG_NAME to package name if not set explicitly
  tagName=${tagName:-"$name":latest}

  # Build the image from the newly generated Dockerfile
  docker build -t $tagName .
fi
