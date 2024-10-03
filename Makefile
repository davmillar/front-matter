MAKEFLAGS 		+= --warn-undefined-variables
PATH 			:= node_modules/.bin:$(PATH)
SHELL 			:= /bin/bash

.SHELLFLAGS 	:= -eu -o pipefail -c
.DEFAULT_GOAL	:= all
.DELETE_ON_ERROR:
.SUFFIXES:

version 		?= patch

node_modules: package.json
	@npm prune
	@npm install
	@touch node_modules

.PHONY: clean
clean:
	@$(RM) -fr node_modules
	@$(RM) -fr npm-debug.log
	@$(RM) -fr coverage

.PHONY: zuul
zuul: node_modules
	@zuul --local 8080 --ui tape -- test/index.js

.PHONY: release
release: node_modules
	@npm test
	@npm version $(version)
	@git push && git push --tags
	@npm publish