.PHONY: docs

IGNORE_CLEAN_SYMLINK := $(shell rm -f ./terraform/modules/modules)

BAZEL ?= ./.bazelisk
BAZEL_OPTS=
STAGE ?= dev
ENV ?= seed-test

all: fmt build generate test ## run fmt, build, test, generate

$(BAZEL):
	@curl -fSsL -o $(BAZEL) "https://github.com/bazelbuild/bazelisk/releases/download/v1.18.0/bazelisk-linux-amd64"
	@chmod +x $(BAZEL)

help: ## Displays this help message describing the targets
	@echo "Targets that can be used with this Makefile:"; \
	@grep -E '^[%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

fmt: $(BAZEL) ## format go code and terraform code
	$(BAZEL) run $(BAZEL_OPTS) //terraform:fmt

docs: $(BAZEL) ## generates or update terraform modules readmes
	$(BAZEL) run $(BAZEL_OPTS) //terraform:gen-doc

generate: $(BAZEL) generate-tfversions ## generate all necessary files

generate-tfversions: $(BAZEL) ## generate all versions.tf.json for terraform modules
	$(BAZEL) cquery 'kind(tf_gen_versions, //...)' --output files | xargs -n1 bash

test: $(BAZEL)  ## run irobox tests
	$(BAZEL) test $(BAZEL_OPTS) "//..."

clean: $(BAZEL) ## clean project
	$(BAZEL) clean $(BAZEL_OPTS)

build: $(BAZEL) oci-images-build ## build everything except docker images
	@rm -f terraform/modules/modules
	$(BAZEL) build $(BAZEL_OPTS) "//..."
