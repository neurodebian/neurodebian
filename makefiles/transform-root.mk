#!/usr/bin/make -f

# Top-level Makefile for NeuroDebian packaging transformations
# ============================================================
#
# This is top-level Makefile invoked by neurodebian-rollout(1)
# in the Git repository hosting Debian and (optionally)
# NeuroDebian packaging producing NeuroDebian packaging branches
# 'neurodebian/*'.
#
# NeuroDebian-wide standard actions go into 'common-neurodebian'
# target and actions specific to specific package in specific
# NeuroDebian release go in the respective 'after-<nd-release>'
# target inside 'debian/neurodebian/rules'.

# Find absolute path of this makefile

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))

# ... and topdir of NeuroDebian tooling

ndtool_rootdir := $(call abspath,$(dir $(mkfile_path))/..)

# Get current branch and stop if it is is not NeuroDebian branch

NEURODEBIAN_BRANCH := $(shell git symbolic-ref --short HEAD)

ifeq (,$(NO_CHECK_NEURODEBIAN_BRANCH))
  ifeq (,$(filter neurodebian/%,$(NEURODEBIAN_BRANCH)))
    $(error "Current Git branch is not 'neurodebian/*' one!")
  endif
endif

# Distro-wide functions that can be used in rulefiles

define add_patch
	echo 'Adding NeuroDebian patch "$(1)" after "$(2)"'

	set -e; \
	. '$(ndtool_rootdir)/helpers/patch-file-helper'; \
	if ! add_patch_to_series '$(1)' '$(2)'; then \
		echo 'Error adding patch!'; return 1; \
	fi; \
	if ! mkdir -p '$(abspath $(CURDIR)/debian/patches/$(dir $(1)))'; then \
		echo 'Error adding patch!'; return 1; \
	fi; \
	if ! cp '$(CURDIR)/debian/neurodebian/patches/$(1)' \
		'$(CURDIR)/debian/patches/$(1)'; then \
		echo 'Error adding patch!'; return 1; \
	fi

	echo 'Patch added successfully!'
endef

define drop_patch
	echo 'Dropping Debian patch "$(1)" from series file'

	set -e; \
	. '$(ndtool_rootdir)/helpers/patch-file-helper'; \
	if ! drop_patch_from_series '$(1)' '$(2)'; then \
		echo 'Error dropping patch!'; return 1; \
	fi; \
	rm -f '$(CURDIR)/debian/patches/$(1)'; \
	rmdir '$(abspath $(CURDIR)/debian/patches/$(dir $(1)))' || echo 'ok'

	echo 'Patch dropped successfully!'
endef

# Include the package rulefile if it exists

-include $(CURDIR)/debian/neurodebian/rules

# Start of actions

all:
	ifeq (,$(filter neurodebian-%,$@))
		$(error "Current target is not 'neurodebian-*' but '$@'!")
	endif

# Distro-wide transformation target

common-neurodebian:
	echo 'Transforming (boring) Debian package into (cool) NeuroDebian one ...'
	# Check if after-action is defined in package and execute it
	if $(MAKE) -n -f '$(mkfile_path)' 'after-$@' 1>/dev/null 2>&1; then \
		$(MAKE) -f '$(mkfile_path)' 'after-$@'; \
	fi

# Pattern-based target to-transform individual releases: first apply common
# target then apply package-specific actions from the package repository
# (if it is defined).

neurodebian-%: common-neurodebian
	echo 'Applying additional mutation for $@ ...'
	# Check if after-action is defined in package and execute it
	if $(MAKE) -n -f '$(mkfile_path)' 'after-$@' 1>/dev/null 2>&1; then \
		$(MAKE) -f '$(mkfile_path)' 'after-$@'; \
	fi
