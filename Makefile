SOURCE_FILES := $(shell go list ./... | grep -v /vendor/ | grep -v /assets)

test: install
	ginkgo -skipPackage=vendor -r

live-test: install
	export TALON_PERFORM_LIVE_TEST=1; export TALON_LIVE_TEST_AUTHENTICATED=1; export TALON_LIVE_TEST_PASS='password'; ginkgo -skipPackage=vendor -r

install: pre-build
	go install github.com/bbuck/dragon-mud/cmd/...

bootstrap: get-glide get-deps

pre-build:
	go-bindata -debug -pkg assets -o assets/assets.go -prefix assets/raw assets/raw/...

get-glide:
	go get github.com/Masterminds/glide

get-deps:
	glide install
	go get -u github.com/onsi/ginkgo/ginkgo
	go get -u github.com/jteeuwen/go-bindata/...

.PHONY: test install bootstrap get-glide get-deps pre-build live-test
