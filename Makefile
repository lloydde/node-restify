#
# Copyright (c) 2012, Joyent, Inc. All rights reserved.
#
# Makefile: basic Makefile for template API service
#
# This Makefile is a template for new repos. It contains only repo-specific
# logic and uses included makefiles to supply common targets (javascriptlint,
# jsstyle, restdown, etc.), which are used by other repos as well. You may well
# need to rewrite most of this file, but you shouldn't need to touch the
# included makefiles.
#
# If you find yourself adding support for new targets that could be useful for
# other projects too, you should add these to the original versions of the
# included Makefiles (in eng.git) so that other teams can use them too.
#

#
# Tools
#
BUNYAN		:= ./node_modules/.bin/bunyan
ESLINT		:= ./node_modules/.bin/eslint
JSCS		:= ./node_modules/.bin/jscs
NODEUNIT	:= ./node_modules/.bin/nodeunit
NODECOVER	:= ./node_modules/.bin/cover
NPM		:= npm

#
# Files
#
DOC_FILES	 = index.restdown
JS_FILES	 = '.'
SHRINKWRAP	 = npm-shrinkwrap.json

CLEAN_FILES	+= node_modules $(SHRINKWRAP) cscope.files

include ./tools/mk/Makefile.defs

#
# Repo-specific targets
#
.PHONY: all
all: $(NODEUNIT) $(REPO_DEPS)
	$(NPM) rebuild

$(NODEUNIT): | $(NPM_EXEC)
	$(NPM) install

$(NODECOVER): | $(NPM_EXEC)
	$(NPM) install

.PHONY: cover
cover: $(NODECOVER)
	@rm -fr ./.coverage_data
	$(NODECOVER) run $(NODEUNIT) test/*.test.js | $(BUNYAN)
	$(NODECOVER) report html

CLEAN_FILES += $(TAP) ./node_modules/nodeunit

.PHONY: test
test: $(NODEUNIT)
	$(NODEUNIT) test/*.test.js | $(BUNYAN)

include ./tools/mk/Makefile.deps
include ./tools/mk/Makefile.targ
