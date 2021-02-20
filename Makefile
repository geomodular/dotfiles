SHELL       := bash
TMP         := .tmp
BUNDLE_DIR  := ./.vim/bundle
PKG         :=
PKG_NAME    := $(notdir $(PKG))
GIT         := $(shell which git)
RSYNC       := $(shell which rsync)

ifeq ($(GIT),)
  $(error git command is missing!)
endif

ifeq ($(RSYNC),)
  $(error rsync command is missing!)
endif

.DEFAULT_GOAL := help
.PHONY: add deploy update update-invalidate help

add: $(BUNDLE_DIR)/$(PKG_NAME) ## Add new submodule using PKG var
deploy: $(TMP)/update $(HOME)/.vimrc $(HOME)/.gvimrc $(HOME)/.vim $(HOME)/.bash_aliases ## Deploy vim files and .bash_aliases
update: update-invalidate $(TMP)/update ## Update submodules
	# Updating submodules
	@touch .vim
update-invalidate: | $(TMP)
	@touch "$(TMP)/update"

$(TMP):
	@mkdir $(TMP)

$(TMP)/init: | $(TMP)
	@$(GIT) submodule init
	@touch "$@"

$(TMP)/update: $(TMP)/init
	@$(GIT) submodule update
	@touch "$@"

$(BUNDLE_DIR)/$(PKG_NAME):
	# Adding a new package: $(PKG_NAME)
	@$(GIT) submodule add $(PKG) "$@"
	@touch .vim

$(HOME)/.vimrc: .vimrc
	# Updating .vimrc
	@cp "$<" "$@"

$(HOME)/.gvimrc: .gvimrc
	# Updating .gvimrc
	@cp "$<" "$@"

$(HOME)/.vim: .vim
	# Updating .vim
	@rsync -a --delete "$</" "$@"

$(HOME)/.bash_aliases: .bash_aliases
	# Updating .bash_aliases
	@cp "$<" "$@"

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

