GOCOVERDIR ?= build/coverage/integration
GOFLAGS += -cover -covermode=atomic -race -shuffle=on -mod=readonly -trimpath

export GOCOVERDIR GOFLAGS

# files used by go generate
define GO_GENERATE_SOURCES
$(strip
)
endef

# files produces by go generate
define GO_GENERATE_TARGETS
$(strip
)
endef

define TEST_PACKAGES
$(strip
internal
pkg
)
endef

GO_SOURCES = $(shell git ls-files '*.go') $(strip ${GO_GENERATE_TARGETS})

all: gomod2nix.toml
build: gomod2nix.toml
test: golang-test

.PHONY: coverage
coverage: build/coverage/unit.txt
	go tool cover -func=$<

.PHONY: golang-test
golang-test:
	gotestdox ${GOFLAGS} ./...

gomod2nix.toml: go.sum
	gomod2nix generate

## make magic, not war ;)

build/coverage/unit.txt: ${GO_SOURCES} go.sum | build/coverage/
	gotestdox --coverprofile=$@ $(addprefix ./,$(addsuffix /...,${TEST_PACKAGES}))
	sed -i'' '#\.gen\.go:|\.pb\.go:|\.pb\.gw\.go:|\.sql\.go:|\.xo\.go:#d' $@

bin/%: ${GO_SOURCES} go.sum
	go build -o ./$@ ./cmd/$(patsubst bin/%,%,$@)/...

go.sum: GOFLAGS-=-mod-readonly
go.sum: ${GO_SOURCES} go.mod
	@go mod tidy -v -x
	@touch $@

build/coverage/%.html: build/coverage/%.txt
	go tool cover -html=$< -o $@

${GO_GENERATE_TARGETS} &: ${GO_GENERATE_SOURCES}
	env -u GOCOVERDIR go generate ./...
