#!/usr/bin/make -f

# Top-level Makefile for NeuroDebian container image updater
# ============================================================
#
# This is top-level Makefile invoked by ndbp-update-images(1)
# and it defines the image building instructions in parallel
# way.
#
# Environment variables:
#

# CPUPERIOD,CPUQUOTA: CPU limits
#

CPUPERIOD ?= 100000
CPUQUOTA ?= 0

# LOGDIR: directory to store image build logs
#

LOGDIR ?=

ifneq (,$(LOGDIR))
 ifeq (,$(wildcard $(LOGDIR)/.))
  $(error "Log directory '$(LOGDIR)' specified but does not exist!")
 endif
endif

# MEMLIMIT: memory limits
#

MEMLIMIT ?= 0

# PODMAN: path to podman(1) executable
#

PODMAN ?= podman

# PASTA_OPTS, SLIRP_OPTS: network options
#

PASTA_EXECUTABLE := $(shell '$(PODMAN)' info -f '{{.Host.Pasta.Executable}}')
SLIRP_EXECUTABLE := $(shell '$(PODMAN)' info -f '{{.Host.Slirp4NetNS.Executable}}')

ifeq (,$(PASTA_EXECUTABLE))
 ifeq (,$(SLIRP_EXECUTABLE))
  $(error "No slirp4netns or pasta network modules found!")
 endif
endif

ifneq (,$(PASTA_EXECUTABLE))
 ifneq (,$(PASTA_OPTS))
  NET_OPTS := 'pasta:$(PASTA_OPTS)'
 else
  NET_OPTS := 'pasta'
 endif
else
 ifneq (,$(SLIRP_OPTS))
  NET_OPTS := 'slirp4netns:$(SLIRP_OPTS)'
 else
  NET_OPTS := 'slirp4netns'
 endif
endif

#
# Makefile-wide functions
#

# Dash separator by position starting 1

word-dash = $(word $2,$(subst -, ,$1))

# Find absolute path of this makefile

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))

# ... and topdir of NeuroDebian tooling

ndtool_rootdir := $(call abspath,$(dir $(mkfile_path))/../..)

# Find supported vendors from distinfo

define find_supported_vendors
$(shell . "$${NEURODEBIAN_TOOLING_PATH}/ndbp/helpers/distinfo-file-helper" && distinfo_find_supported_vendors)
endef

# Find supported distributions of given vendor from distinfo

define find_supported_vendor_dists
$(shell . "$${NEURODEBIAN_TOOLING_PATH}/ndbp/helpers/distinfo-file-helper" && distinfo_find_supported_distributions '$(1)')
endef

# Find supported architectures of vendor-distribution from distinfo

define find_supported_vendor_dist_arches
$(shell . "$${NEURODEBIAN_TOOLING_PATH}/ndbp/helpers/distinfo-file-helper" && distinfo_get_architectures '$(1)-$(2)')
endef

# Filter supported architectures against ones executable on host CPU

define find_supported_executable_arches
$(filter $(EXEC_ARCHES),$(call find_supported_vendor_dist_arches,$(1),$(2)))
endef

# Find vendor of base image used for build container images

define find_build_base_image_vendor
$(shell . '$(ndtool_rootdir)/ndbp/helpers/distinfo-file-helper' && distinfo_get_build_container_image_vendor '$(1)-$(2)')
endef

# Find distribution of base image used for build container images

define find_build_base_image_distribution
$(shell . '$(ndtool_rootdir)/ndbp/helpers/distinfo-file-helper' && distinfo_get_build_container_image_distribution '$(1)-$(2)')
endef

#
# The following block of 'functions' recursively expands top-to-bottom
# forming the tree of dynamic targets:
# <root> -> vendor -> dist -> base_vendor/base_dist -> arch
#

# Dynamically generate builder image targets from distinfo
# and add them as dependency to '.all-targets'
#
# NOTE: Since vendor and distribution of image used as base for build ones
# apply to distribution, expanding them before architecture saves 2 * number
# of architectures worth of distinfo queries, which is quite an expensive
# operation

define generate_builder_target
# $(1) - VENDOR
# $(2) - DIST
# $(3) - BASE_IMAGE_VENDOR
# $(4) - BASE_IMAGE_DIST
# $(5) - ARCH

.builder-$(1)-$(2)-$(3)-$(4)-$(5): .base-$(3)-$(4)-$(5)

.all-targets: .builder-$(1)-$(2)-$(3)-$(4)-$(5)
endef

# Finally, walk through architectures that the vendor-distribution provides
# and filter out non-executable architectures to avoid building errors

define generate_builder_target_vdba
$(foreach arch,$(call find_supported_executable_arches,$(1),$(2)),$(eval $(call generate_builder_target,$(1),$(2),$(3),$(4),$(arch))))
endef

# Query distribution of image used as base one for final builder image
# This information is used to construct base image that is used in first FROM
# of build container's containerfile

define generate_builder_target_vdb
$(foreach base_dist,$(call find_build_base_image_distribution,$(1),$(2)),$(eval $(call generate_builder_target_vdba,$(1),$(2),$(3),$(base_dist))))
endef

# Query vendor of image used as base one for final builder image
# This information is used to construct base image that is used in first FROM
# of build container's containerfile

define generate_builder_target_vd
$(foreach base_vendor,$(call find_build_base_image_vendor,$(1),$(2)),$(eval $(call generate_builder_target_vdb,$(1),$(2),$(base_vendor))))
endef

# Walk through supported distributions under each vendor
# (debian-sid, neurodebian-sid ...)

define generate_builder_target_v
$(foreach dist,$(call find_supported_vendor_dists,$(1)),$(eval $(call generate_builder_target_vd,$(1),$(dist))))
endef

# Root of tree to identify all supported vendors (debian, neurodebian, ...)

define generate_builder_targets
$(foreach vendor,$(call find_supported_vendors,),$(eval $(call generate_builder_target_v,$(vendor))))
endef

#
# End of Makefile-wide functions
#

#
# These initialization steps are not needed for cleanup targets etc
#

TARGETS_WITHOUT_NATIVE_ARCH := .install-new-images .clean-on-failure .clean-on-success clean-old-images restore-old-images

# These targets require computation of NATIVE_ARCH but do not require
# arch-test image to be present in Podman cache (including arch-test target
# itself to avoid endless recursion)

TARGETS_WITHOUT_ARCH_TEST := .arch-test

ifeq (,$(filter $(TARGETS_WITHOUT_NATIVE_ARCH),$(MAKECMDGOALS))) # TARGETS_WITHOUT_NATIVE_ARCH guard

# Find native architectures and map them to Debian ones

NATIVE_ARCH := $(shell '$(PODMAN)' info -f '{{.Host.Arch}}')

ifeq (amd64,$(NATIVE_ARCH))
 export NATIVE_ARCH := amd64
else ifeq (arm32v5,$(NATIVE_ARCH))
 export NATIVE_ARCH := armel
else ifeq (arm32v7,$(NATIVE_ARCH))
 export NATIVE_ARCH := armhf
else ifeq (arm64v8,$(NATIVE_ARCH))
 export NATIVE_ARCH := arm64
else ifeq (386,$(NATIVE_ARCH))
 export NATIVE_ARCH := i386
else ifeq (mips64le,$(NATIVE_ARCH))
 export NATIVE_ARCH := mips64el
else ifeq (ppc64le,$(NATIVE_ARCH))
 export NATIVE_ARCH := ppc64el
else ifeq (riscv64,$(NATIVE_ARCH))
 export NATIVE_ARCH := riscv64
else ifeq (s390x,$(NATIVE_ARCH))
 export NATIVE_ARCH := s390x
else
 $(error WTF: $(NATIVE_ARCH))
endif

ifeq (,$(filter $(TARGETS_WITHOUT_ARCH_TEST),$(MAKECMDGOALS))) # TARGETS_WITHOUT_ARCH_TEST guard

# Build arch-test image
#
# NOTE: Top-level makefiles do not actually export variables
# tagged as 'export' unlike inside makefile rules, so we need
# to expose all needed variables to sub-make manually

$(info Building .arch-test container...)
$(info )
$(info $(shell '$(MAKE)' \
	-s -f '$(mkfile_path)' \
	'CPUPERIOD=$(CPUPERIOD)' \
	'CPUQUOTA=$(CPUQUOTA)' \
	'LOGDIR=$(LOGDIR)' \
	'MEMLIMIT=$(MEMLIMIT)' \
	'NATIVE_ARCH=$(NATIVE_ARCH)' \
	'PASTA_OPTS=$(PASTA_OPTS)' \
	'PODMAN=$(PODMAN)' \
	'SLIRP_OPTS=$(SLIRP_OPTS)' \
	.arch-test))
$(info )
ifneq (0,$(.SHELLSTATUS))
$(error Building .arch-test container failed)
endif

# Find architectures executable on host CPU

EXEC_ARCHES := $(shell '$(PODMAN)' run \
	--rm \
	'localhost/neurodebian-tooling-arch-test:latest-new')

# Generate dynamic build targets from distinfo

$(eval $(call generate_builder_targets))

endif # TARGETS_WITHOUT_ARCH_TEST
endif # TARGETS_WITHOUT_NATIVE_ARCH

#
# End of top-level makefile initialization commands
#

#
# Start of Makefile targets
#

#
# Top-level target
#

all:
	# 1. Make all-targets and dispatch new image installation and clean-up
	set -e; \
	if ! '$(MAKE)' -f '$(mkfile_path)' .all-targets; then \
		'$(MAKE)' -f '$(mkfile_path)' .clean-on-failure; \
	fi; \
	'$(MAKE)' -f '$(mkfile_path)' .install-new-images; \
	'$(MAKE)' -f '$(mkfile_path)' .clean-on-success

#
# .all-targets: phony target that depends on real targets
# (except '.arch-test')
#

.all-targets: .lintian

# NOTE: Different container images use different tagging schemes:
#
# 1. One multi-architecture image (like 'docker.io/library/debian:sid'):
#    this image tagging scheme requires specifying '--arch' or '--platform'
#    to pull the image of different architecture. Also the last-pulled image
#    becomes the new tagged one by default and this behavior can not be fixed
#    both in Docker and Podman for years.
#
# 2. Per-architecture image (like 'docker.io/i386/debian:sid'):
#    this tagging scheme solves the issues with prior scheme but requires
#    dynamic construction of each FROM statement.
#
# There are many other variations of the schemes above and to provide flexible
# solution to image builds, the two-step solution is introduced.
#
# First step is to create normalized per-architecture base images tagged as
# 'localhost/neurodebian-tooling-base-image:<base-vendor>-<base-dist>-<arch>'.
# The platform mappings and the container image tag patterns are processed
# in '.base-%:' target. It uses 'quay.io/skopeo/stable'
# to fetch the proper image variant and export as docker-archive.
# Then the proper tag is assigned to the imported image: first it is tagged as
# '<base-vendor>-<base-dist>-<arch>-new' and after all images are built,
# the final step renames each temp tag to a final name without '-new' postfix.
# If any image build fails, all temporary images are pruned so last known good
# images are preserved.
#
# Second step is to use built base images to build final images. These are
# processed in '.<image-name>-%:' target.
#

#
# Target to create base images for VENDOR, DIST, ARCH
#

.base-%:
	echo "$@"
	# 1. Silently complete if new-base-image exists
	# 2. Map vendor-distribution-architecture into container image and
	#    its Docker architecture
	# 3. Use skopeo to fetch the selected image from remote registry
	#    and import it as temp image
	# 4. Build the base image on top of imported image to add labels
	#    and save it as base image
	# 5. Delete the temp image
	#
	# The stem is <VENDOR>-<DIST>-<ARCH>
	set -e; \
	VENDOR='$(call word-dash,$*,1)'; \
	DIST='$(call word-dash,$*,2)'; \
	ARCH='$(call word-dash,$*,3)'; \
	if '$(PODMAN)' image exists \
		"localhost/neurodebian-tooling-base-image:$${VENDOR}-$${DIST}-$${ARCH}-new"; then \
		exit 0; \
	fi; \
	if [ -n '$(LOGDIR)' ]; then \
		exec 1>"$(LOGDIR)/base-$${VENDOR}-$${DIST}-$${ARCH}.log"; \
		exec 2>&1; \
	fi; \
	case "$${VENDOR}" in \
	debian) \
		CONTAINER_BASE_IMAGE="docker.io/library/debian:$${DIST}-slim"; \
		case "$${ARCH}" in \
		source | all) \
			exit 0; \
			;; \
		amd64) \
			DOCKER_ARCH="amd64"; \
			;; \
		armel) \
			export DOCKER_ARCH="arm32v5"; \
			;; \
		armhf) \
			export DOCKER_ARCH="arm32v7"; \
			;; \
		arm64) \
			export DOCKER_ARCH="arm64v8"; \
			;; \
		i386) \
			export DOCKER_ARCH="386"; \
			;; \
		mips64el) \
			export DOCKER_ARCH="mips64le"; \
			;; \
		ppc64el) \
			export DOCKER_ARCH="ppc64le"; \
			;; \
		riscv64) \
			export DOCKER_ARCH="riscv64"; \
			;; \
		s390x) \
			export DOCKER_ARCH="s390x"; \
			;; \
		esac; \
		;; \
	ubuntu) \
		CONTAINER_BASE_IMAGE="docker.io/library/ubuntu:$${DIST}"; \
		case "$${ARCH}" in \
		source | all) \
			exit 0; \
			;; \
		amd64) \
			DOCKER_ARCH="amd64"; \
			;; \
		armhf) \
			export DOCKER_ARCH="arm32v7"; \
			;; \
		arm64) \
			export DOCKER_ARCH="arm64v8"; \
			;; \
		i386) \
			export DOCKER_ARCH="386"; \
			;; \
		ppc64el) \
			export DOCKER_ARCH="ppc64le"; \
			;; \
		s390x) \
			export DOCKER_ARCH="s390x"; \
			;; \
		esac; \
		;; \
	*) \
		echo "ERROR: Unknown vendor '$${VENDOR}'!" >&2; \
		exit 1; \
		;; \
	esac; \
	'$(PODMAN)' run \
		--network '$(NET_OPTS)' \
		--cpu-period '$(CPUPERIOD)' \
		--cpu-quota '$(CPUQUOTA)' \
		--rm \
		'quay.io/skopeo/stable' \
		copy \
		-q \
		--override-arch "$${DOCKER_ARCH}" \
		"docker://$${CONTAINER_BASE_IMAGE}" \
		"docker-archive:/dev/fd/1:localhost/neurodebian-tooling-base-image:$${VENDOR}-$${DIST}-$${ARCH}-new-temp" | \
		'$(PODMAN)' load --input /dev/fd/0; \
	'$(PODMAN)' build \
		--network none \
		--cpu-period '$(CPUPERIOD)' \
		--cpu-quota '$(CPUQUOTA)' \
		-t "localhost/neurodebian-tooling-base-image:$${VENDOR}-$${DIST}-$${ARCH}-new" \
		-f '$(ndtool_rootdir)/ndbp/containerfiles/Containerfile.dummy' \
		--from "localhost/neurodebian-tooling-base-image:$${VENDOR}-$${DIST}-$${ARCH}-new-temp" \
		--layer-label 'ndVendor=tooling' \
		--layer-label 'ndPruneOnSuccess=true' \
		--layer-label 'ndPruneOnFailure=true' \
		--label 'ndVendor=tooling' \
		--label 'ndPruneOnFailure=true' \
		--label 'ndPruneOnSuccess=true'; \
	'$(PODMAN)' image rm \
		-f \
		"localhost/neurodebian-tooling-base-image:$${VENDOR}-$${DIST}-$${ARCH}-new-temp"

#
# arch-test image to identify which Debian architectures
# are executable on given host machine - built for native architecture
#

.arch-test: .base-debian-sid-$(NATIVE_ARCH)
	echo "$@"
	# NOTE: Must be in sync with 'containerfiles/arch-test/Containerfile'!
	# Expects 'NATIVE_ARCH' make variable to be exported by caller!
	# 1. Silently complete if new-base-image exists
	# 2. Build arch-test image from native-arch Debian sid image
	set -e; \
	if '$(PODMAN)' image exists \
		'localhost/neurodebian-tooling-arch-test:latest-new'; then \
		exit 0; \
	fi; \
	if [ -n '$(LOGDIR)' ]; then \
		exec 1>'$(LOGDIR)/arch-test.log'; \
		exec 2>&1; \
	fi; \
	'$(PODMAN)' build \
		--network '$(NET_OPTS)' \
		--cpu-period '$(CPUPERIOD)' \
		--cpu-quota '$(CPUQUOTA)' \
		-t 'localhost/neurodebian-tooling-arch-test:latest-new' \
		-f '$(ndtool_rootdir)/ndbp/containerfiles/arch-test/Containerfile' \
		--build-arg "ARCH=$${NATIVE_ARCH}" \
		--layer-label 'ndVendor=tooling' \
		--layer-label 'ndPruneOnSuccess=true' \
		--layer-label 'ndPruneOnFailure=true' \
		--label 'ndVendor=tooling' \
		--label 'ndPruneOnFailure=true' \
		--label 'ndPruneOnSuccess=false';

#
# lintian image to run lintian(1) on packages - built for native architecture
#

.lintian: .base-debian-sid-$(NATIVE_ARCH)
	echo "$@"
	# NOTE: Must be in sync with 'containerfiles/lintian/Containerfile'!
	# Expects 'NATIVE_ARCH' make variable to be exported by caller!
	# 1. Silently complete if new-base-image exists
	# 2. Build arch-test image from native-arch Debian sid image
	set -e; \
	if '$(PODMAN)' image exists \
		'localhost/neurodebian-tooling-lintian:latest-new'; then \
		exit 0; \
	fi; \
	if [ -n '$(LOGDIR)' ]; then \
		exec 1>'$(LOGDIR)/lintian.log'; \
		exec 2>&1; \
	fi; \
	'$(PODMAN)' build \
		--network '$(NET_OPTS)' \
		--cpu-period '$(CPUPERIOD)' \
		--cpu-quota '$(CPUQUOTA)' \
		-t 'localhost/neurodebian-tooling-lintian:latest-new' \
		-f '$(ndtool_rootdir)/ndbp/containerfiles/lintian/Containerfile' \
		--build-arg "ARCH=$${NATIVE_ARCH}" \
		--layer-label 'ndVendor=tooling' \
		--layer-label 'ndPruneOnSuccess=true' \
		--layer-label 'ndPruneOnFailure=true' \
		--label 'ndVendor=tooling' \
		--label 'ndPruneOnFailure=true' \
		--label 'ndPruneOnSuccess=false';

#
# builder images are vendor-dist-arch specific.
# Dependency on base image for each vendor-dist-arch triplet
# is added by 'generate_builder_target' function
#

.builder-%:
	echo "$@"
	# 1. Silently complete if new-builder-image exists
	# 2. Make new base image if not found
	# 3. Make builder image for vendor-dist-arch
	#
	# The stem is <VENDOR>-<DIST>-<BASE_VENDOR>-<BASE_DIST>-<ARCH>
	set -e; \
	VENDOR='$(call word-dash,$*,1)'; \
	DIST='$(call word-dash,$*,2)'; \
	BASE_VENDOR='$(call word-dash,$*,3)'; \
	BASE_DIST='$(call word-dash,$*,4)'; \
	ARCH='$(call word-dash,$*,5)'; \
	if '$(PODMAN)' image exists \
		"localhost/neurodebian-tooling-builder:$${VENDOR}-$${DIST}-$${ARCH}-new"; then \
		exit 0; \
	fi; \
	if [ -n '$(LOGDIR)' ]; then \
		exec 1>"$(LOGDIR)/builder-$${VENDOR}-$${DIST}-$${ARCH}.log"; \
		exec 2>&1; \
	fi; \
	'$(PODMAN)' build \
		--network '$(NET_OPTS)' \
		--cpu-period '$(CPUPERIOD)' \
		--cpu-quota '$(CPUQUOTA)' \
		-t "localhost/neurodebian-tooling-builder:$${VENDOR}-$${DIST}-$${ARCH}-new" \
		-f "$(ndtool_rootdir)/ndbp/containerfiles/builder/Containerfile.$${BASE_VENDOR}" \
		--build-arg "DIST=$${BASE_DIST}" \
		--build-arg "ARCH=$${ARCH}" \
		--build-arg "TAG=$${VENDOR}-$${DIST}-$${ARCH}" \
		--layer-label 'ndVendor=tooling' \
		--layer-label 'ndPruneOnSuccess=true' \
		--layer-label 'ndPruneOnFailure=true' \
		--label 'ndVendor=tooling' \
		--label 'ndPruneOnFailure=true' \
		--label 'ndPruneOnSuccess=false';

#
# Targets to install 'new' tagged images into production
#

.install-new-images:
	# 1. Find all 'localhost/neurodebian-tooling-*:*-new' images
	# 2. For each found image, install new image
	#  - try finding corresponding prod image and 'old' one,
	#  - if 'old' one is found, delete it,
	#  - if prod image is found, tag it as old and untag as prod
	#  - tag new image as prod and untag as new one
	set -e; \
	'$(PODMAN)' image ls \
		--all \
		--format '{{range .}}{{.Repository}}:{{.Tag}}:{{.Id}}\n{{end -}}' \
	| \
		while IFS=':' read -r IMAGE_NAME IMAGE_TAG IMAGE_ID; do \
		case "$${IMAGE_NAME}" in \
		localhost/neurodebian-tooling-*) \
			if ! '$(PODMAN)' image exists \
				"$${IMAGE_NAME}:$${IMAGE_TAG}"; then \
				continue; \
			fi; \
			case "$${IMAGE_TAG}" in \
			*-new) \
				IMAGE_TAG_PROD="$${IMAGE_TAG%%-new}"; \
				IMAGE_TAG_OLD="$${IMAGE_TAG_PROD}-old"; \
				if '$(PODMAN)' image exists \
					"$${IMAGE_NAME}:$${IMAGE_TAG_OLD}"; then \
					'$(PODMAN)' image rm \
						-f \
						"$${IMAGE_NAME}:$${IMAGE_TAG_OLD}"; \
				fi; \
				if '$(PODMAN)' image exists \
					"$${IMAGE_NAME}:$${IMAGE_TAG_PROD}"; then \
					'$(PODMAN)' image tag \
						"$${IMAGE_NAME}:$${IMAGE_TAG_PROD}" \
						"$${IMAGE_NAME}:$${IMAGE_TAG_OLD}"; \
					'$(PODMAN)' image untag \
						"$${IMAGE_NAME}:$${IMAGE_TAG_PROD}" \
						"$${IMAGE_NAME}:$${IMAGE_TAG_PROD}"; \
				fi; \
				'$(PODMAN)' image tag \
					"$${IMAGE_ID}" \
					"$${IMAGE_NAME}:$${IMAGE_TAG_PROD}"; \
				'$(PODMAN)' image untag \
					"$${IMAGE_ID}" \
					"$${IMAGE_NAME}:$${IMAGE_TAG}"; \
				;; \
			esac; \
			;; \
		esac; \
	done

#
# Clean-up targets
#

.clean-on-failure:
	# NOTE: Thanks to stupid bug in podman(1) < 5.0.0,
	# (https://github.com/containers/podman/issues/21803)
	# multiple filters are applied with OR-mask not AND-one!
	#
	# 1. Load distinfo and filter helpers
	# 2. Find 'label=ndVendor=tooling' images
	# 3. Intersect-find 'label=ndPruneOnFailure=true' images
	# 4. Intersect-find 'label!=ndPruneOnSuccess=true' images
	# 5. Delete these images
	# 6. Find all 'localhost/neurodebian-tooling-*:*-new' images
	# 7. Delete these images
	set -e; \
	. '$(ndtool_rootdir)/ndbp/helpers/filter-helper'; \
	TOOLING_IMAGES="$$('$(PODMAN)' image ls \
		--all \
		--filter 'label=ndVendor=tooling' \
		--format '{{range .}}{{.Id}}\n{{end -}}')"; \
	PRUNABLE_IMAGES="$$('$(PODMAN)' image ls \
		--all \
		--filter 'label=ndPruneOnFailure=true' \
		--format '{{range .}}{{.Id}}\n{{end -}}')"; \
	IMAGES_TO_PRUNE="$$(filter_common "$${TOOLING_IMAGES}" "$${PRUNABLE_IMAGES}")"; \
	PRUNABLE_IMAGES="$$('$(PODMAN)' image ls \
		--all \
		--filter 'label!=ndPruneOnSuccess=true' \
		--format '{{range .}}{{.Id}}\n{{end -}}')"; \
	IMAGES_TO_PRUNE="$$(filter_common "$${IMAGES_TO_PRUNE}" "$${PRUNABLE_IMAGES}")"; \
	if [ -n "$${IMAGES_TO_PRUNE}" ]; then \
		set -- ; \
		for IMAGE_TO_PRUNE in $${IMAGES_TO_PRUNE}; do \
			set -- "$$@" "$${IMAGE_TO_PRUNE}"; \
		done; \
		'$(PODMAN)' image rm -f "$$@"; \
	fi; \
	'$(PODMAN)' image rm -f 'quay.io/skopeo/stable'

.clean-on-success:
	# NOTE: Thanks to stupid bug in podman(1) < 5.0.0,
	# (https://github.com/containers/podman/issues/21803)
	# multiple filters are applied with OR-mask not AND-one!
	#
	# 1. Load distinfo and filter helpers
	# 2. Find 'label=ndVendor=tooling' images
	# 3. Intersect-find 'label=ndPruneOnSuccess=true' images
	# 4. Delete these images
	set -e; \
	. '$(ndtool_rootdir)/ndbp/helpers/filter-helper'; \
	TOOLING_IMAGES="$$('$(PODMAN)' image ls \
		--all \
		--filter 'label=ndVendor=tooling' \
		--format '{{range .}}{{.Id}}\n{{end -}}')"; \
	PRUNABLE_IMAGES="$$('$(PODMAN)' image ls \
		--all \
		--filter 'label=ndPruneOnSuccess=true' \
		--format '{{range .}}{{.Id}}\n{{end -}}')"; \
	IMAGES_TO_PRUNE="$$(filter_common "$${TOOLING_IMAGES}" "$${PRUNABLE_IMAGES}")"; \
	if [ -n "$${IMAGES_TO_PRUNE}" ]; then \
		set -- ; \
		for IMAGE_TO_PRUNE in $${IMAGES_TO_PRUNE}; do \
			set -- "$$@" "$${IMAGE_TO_PRUNE}"; \
		done; \
		'$(PODMAN)' image rm -f "$$@"; \
	fi; \
	'$(PODMAN)' image ls \
		--all \
		--format '{{range .}}{{.Repository}}:{{.Tag}}:{{.Id}}\n{{end -}}' \
	| \
		while IFS=':' read -r IMAGE_NAME IMAGE_TAG IMAGE_ID; do \
		case "$${IMAGE_NAME}" in \
		localhost/neurodebian-tooling-*) \
			if ! '$(PODMAN)' image exists \
				"$${IMAGE_NAME}:$${IMAGE_TAG}"; then \
				continue; \
			fi; \
			case "$${IMAGE_TAG}" in \
			*-new) \
				'$(PODMAN)' image rm \
					-f \
					"$${IMAGE_NAME}:$${IMAGE_TAG}"; \
				;; \
			esac; \
			;; \
		esac; \
	done; \
	'$(PODMAN)' image rm -f 'quay.io/skopeo/stable'

clean-old-images:
	# 1. Find all 'localhost/neurodebian-tooling-*:*-old' images
	# 2. For each found image, remove the image
	set -e; \
	'$(PODMAN)' image ls \
		--all \
		--format '{{range .}}{{.Repository}}:{{.Tag}}:{{.Id}}\n{{end -}}' \
	| \
		while IFS=':' read -r IMAGE_NAME IMAGE_TAG IMAGE_ID; do \
		case "$${IMAGE_NAME}" in \
		localhost/neurodebian-tooling-*) \
			if ! '$(PODMAN)' image exists \
				"$${IMAGE_NAME}:$${IMAGE_TAG}"; then \
				continue; \
			fi; \
			case "$${IMAGE_TAG}" in \
			*-old) \
				'$(PODMAN)' image rm \
					-f \
					"$${IMAGE_NAME}:$${IMAGE_TAG}"; \
				;; \
			esac; \
			;; \
		esac; \
	done; \

#
# Restore old images
#

restore-old-images:
	# 1. Find all 'localhost/neurodebian-tooling-*:*-old' images
	# 2. For each found image, restore old image
	#  - if 'prod' image found, remove the image.
	#  - tag 'old' image as 'prod' one and untag 'old'.
	set -e; \
	'$(PODMAN)' image ls \
		--all \
		--format '{{range .}}{{.Repository}}:{{.Tag}}:{{.Id}}\n{{end -}}' \
	| \
		while IFS=':' read -r IMAGE_NAME IMAGE_TAG IMAGE_ID; do \
		case "$${IMAGE_NAME}" in \
		localhost/neurodebian-tooling-*) \
			if ! '$(PODMAN)' image exists \
				"$${IMAGE_NAME}:$${IMAGE_TAG}"; then \
				continue; \
			fi; \
			case "$${IMAGE_TAG}" in \
			*-old) \
				IMAGE_TAG_PROD="$${IMAGE_TAG%%-old}"; \
				if '$(PODMAN)' image exists \
					"$${IMAGE_NAME}:$${IMAGE_TAG_PROD}"; then \
					'$(PODMAN)' image rm \
						-f \
						"$${IMAGE_NAME}:$${IMAGE_TAG_PROD}"; \
				fi; \
				'$(PODMAN)' image tag \
					"$${IMAGE_ID}" \
					"$${IMAGE_NAME}:$${IMAGE_TAG_PROD}"; \
				'$(PODMAN)' image untag \
					"$${IMAGE_ID}" \
					"$${IMAGE_NAME}:$${IMAGE_TAG}"; \
				;; \
			esac; \
			;; \
		esac; \
	done
