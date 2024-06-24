#!/usr/bin/make -f

# Top-level Makefile for NeuroDebian package builder
# ============================================================
#
# This is top-level Makefile invoked by ndbp-build(1)
# and it defines the package building instructions in parallel
# way.
#
# Environment variables:
#

# CPUPERIOD,CPUQUOTA: CPU limits
#

CPUPERIOD ?= 100000
CPUQUOTA ?= 0

# OUTDIR: directory to store package build artifacts and logs
#

OUTDIR ?=

ifneq (,$(OUTDIR))
 ifeq (,$(wildcard $(OUTDIR)/.))
  $(error "Output directory '$(OUTDIR)' specified but does not exist!")
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

# SHELL_ON_FAILURE: Whether to spawn shell on failure
#

SHELL_ON_FAILURE ?= 0

#
# Makefile-wide functions
#

# Dash separator by position starting 1

word-dash = $(word $2,$(subst -, ,$1))

# Find absolute path of this makefile

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))

# ... and topdir of NeuroDebian tooling

ndtool_rootdir := $(call abspath,$(dir $(mkfile_path))/..)

# Find supported vendors from distinfo

define find_supported_vendors
$(shell . "$${NEURODEBIAN_TOOLING_PATH}/helpers/distinfo-file-helper" && distinfo_find_supported_vendors)
endef

# Find supported distributions of given vendor from distinfo

define find_supported_vendor_dists
$(shell . "$${NEURODEBIAN_TOOLING_PATH}/helpers/distinfo-file-helper" && distinfo_find_supported_distributions '$(1)')
endef

# Find supported architectures of vendor-distribution from distinfo

define find_supported_vendor_dist_arches
$(shell . "$${NEURODEBIAN_TOOLING_PATH}/helpers/distinfo-file-helper" && distinfo_get_architectures '$(1)-$(2)')
endef

#
# generate_builddep_target*: Chain of functions expanding vendor-dist-arch and
# generating bottom-level rules for '.internal-builddep-*'
#

#
# Iterate over '.internal-builddep-<vendor>-<dist>-<arch>' targets and
# rewire those for 'source' pseudo-architectures to the native-arch one
# (and symlink the dep-cache directories!).
# This eliminates unnecessary work as 'source' architecture may need
# only dependencies for dh-clean(1).
#
# For other architectures, add dependency on '.internal-export-<vendor>-<dist>'
#

define generate_builddep_target
# $(1) - VENDOR
# $(2) - DIST
# $(3) - ARCH

ifeq (,$(filter-out source,$(3)))
.internal-builddep-$(1)-$(2)-$(3):
	if [ -f "$(OUTDIR)/logs/01-builddep-$(1)-$(2)-$(NATIVE_ARCH).state.PASS" ]; then \
		ln -s \
			"$(OUTDIR)/temp/dep-cache/$(1)/$(2)/$(NATIVE_ARCH)" \
			"$(OUTDIR)/temp/dep-cache/$(1)/$(2)/$(3)"; \
		echo '' >"$(OUTDIR)/logs/01-builddep-$(1)-$(2)-$(3).state.PASS"; \
	elif [ -f "$(OUTDIR)/logs/01-builddep-$(1)-$(2)-$(NATIVE_ARCH).state.FAIL" ]; then \
		echo '' >"$(OUTDIR)/logs/01-builddep-$(1)-$(2)-$(3).state.FAIL"; \
	elif [ -f "$(OUTDIR)/logs/01-builddep-$(1)-$(2)-$(NATIVE_ARCH).state.SKIP" ]; then \
		echo '' >"$(OUTDIR)/logs/01-builddep-$(1)-$(2)-$(3).state.SKIP"; \
	fi

ifeq (ok,$(shell [ ! -f '$(OUTDIR)/temp/dep-cache/$(1)/$(2)/$(3)/.complete' ] && echo ok))
.internal-builddep-$(1)-$(2)-$(3): .internal-builddep-$(1)-$(2)-$(NATIVE_ARCH)
endif

else

ifeq (ok,$(shell [ ! -f '$(OUTDIR)/temp/dep-cache/$(1)/$(2)/$(3)/.complete' ] && echo ok))

ifeq (ok,$(shell [ ! -f '$(OUTDIR)/temp/export/$(1)/$(2)/.complete' ] && echo ok))
.internal-builddep-$(1)-$(2)-$(3): .internal-export-$(1)-$(2)
endif

endif

endif

endef

# Finally, walk through architectures that the vendor-distribution provides

define generate_builddep_target_vd
$(foreach arch,$(call find_supported_vendor_dist_arches,$(1),$(2)),$(eval $(call generate_builddep_target,$(1),$(2),$(arch))))
endef

# Walk through supported distributions under each vendor
# (debian-sid, neurodebian-sid ...)

define generate_builddep_target_v
$(foreach dist,$(call find_supported_vendor_dists,$(1)),$(eval $(call generate_builddep_target_vd,$(1),$(dist))))
endef

# Root of tree to identify all supported vendors (debian, neurodebian, ...)

define generate_builddep_targets
$(foreach vendor,$(call find_supported_vendors,),$(eval $(call generate_builddep_target_v,$(vendor))))
endef

#
# generate_build_target*: Chain of functions expanding vendor-dist-arch and
# generating intermediate and bottom-level rules for 'build-*'
#

#
# Iterate over 'build-<vendor>-<dist>-<arch>' targets and add dependency on
# '.internal-builddep-<vendor>-<dist>-<arch>'
#

define generate_build_target
# $(1) - VENDOR
# $(2) - DIST
# $(3) - ARCH

ifeq (ok,$(shell [ ! -f '$(OUTDIR)/packages/$(1)/$(2)/$(3)/.complete' ] && echo ok))

ifeq (ok,$(shell [ ! -f '$(OUTDIR)/dep-cache/$(1)/$(2)/$(3)/.complete' ] && echo ok))
build-$(1)-$(2)-$(3): .internal-builddep-$(1)-$(2)-$(3)
endif

endif

endef

# Finally, walk through architectures that the vendor-distribution provides

define generate_build_target_vd
$(foreach arch,$(call find_supported_vendor_dist_arches,$(1),$(2)),$(eval $(call generate_build_target,$(1),$(2),$(arch))))

build-$(1)-$(2): $(foreach arch,$(call find_supported_vendor_dist_arches,$(1),$(2)),build-$(1)-$(2)-$(arch))
	exit 0
endef

# Walk through supported distributions under each vendor
# (debian-sid, neurodebian-sid ...)

define generate_build_target_v
$(foreach dist,$(call find_supported_vendor_dists,$(1)),$(eval $(call generate_build_target_vd,$(1),$(dist))))

build-$(1): $(foreach dist,$(call find_supported_vendor_dists,$(1)),build-$(1)-$(dist))
	exit 0
endef

# Root of tree to identify all supported vendors (debian, neurodebian, ...)

define generate_build_targets
$(foreach vendor,$(call find_supported_vendors,),$(eval $(call generate_build_target_v,$(vendor))))
endef

#
# generate_lintian_target*: Chain of functions expanding vendor-dist-arch and
# generating intermediate and bottom-level rules for 'lintian-*'
#

#
# Iterate over 'lintian-<vendor>-<dist>-<arch>' targets and add dependency on
# 'build-<vendor>-<dist>-<arch>'
#

define generate_lintian_target
# $(1) - VENDOR
# $(2) - DIST
# $(3) - ARCH

ifeq (ok,$(shell [ ! -f '$(OUTDIR)/logs/lintian-$(1)-$(2)-$(3).state.PASS' ] && echo ok))

ifeq (ok,$(shell [ ! -f '$(OUTDIR)/packages/$(1)/$(2)/$(3)/.complete' ] && echo ok))
lintian-$(1)-$(2)-$(3): build-$(1)-$(2)-$(3)
endif

endif

endef

# Finally, walk through architectures that the vendor-distribution provides

define generate_lintian_target_vd
$(foreach arch,$(call find_supported_vendor_dist_arches,$(1),$(2)),$(eval $(call generate_lintian_target,$(1),$(2),$(arch))))

lintian-$(1)-$(2): $(foreach arch,$(call find_supported_vendor_dist_arches,$(1),$(2)),lintian-$(1)-$(2)-$(arch))
	exit 0
endef

# Walk through supported distributions under each vendor
# (debian-sid, neurodebian-sid ...)

define generate_lintian_target_v
$(foreach dist,$(call find_supported_vendor_dists,$(1)),$(eval $(call generate_lintian_target_vd,$(1),$(dist))))

lintian-$(1): $(foreach dist,$(call find_supported_vendor_dists,$(1)),lintian-$(1)-$(dist))
	exit 0
endef

# Root of tree to identify all supported vendors (debian, neurodebian, ...)

define generate_lintian_targets
$(foreach vendor,$(call find_supported_vendors,),$(eval $(call generate_lintian_target_v,$(vendor))))
endef

#
# generate_reprotest_target*: Chain of functions expanding vendor-dist-arch and
# generating intermediate and bottom-level rules for 'reprotest-*'
#

#
# Iterate over 'reprotest-<vendor>-<dist>-<arch>' targets and
# rewire those for 'source' pseudo-architectures to empty action.
# This eliminates unnecessary work as 'source' builds are always reproducible
#
# For other architectures, add dependency on '.internal-builddep-<vendor>-<dist>-<arch>'
#

define generate_reprotest_target
# $(1) - VENDOR
# $(2) - DIST
# $(3) - ARCH

ifeq (,$(filter-out source,$(3)))
reprotest-$(1)-$(2)-$(3):
	exit 0
else

ifeq (ok,$(shell [ ! -f '$(OUTDIR)/logs/reprotest-$(1)-$(2)-$(3).state.PASS' ] && echo ok))

ifeq (ok,$(shell [ ! -f '$(OUTDIR)/temp/dep-cache/$(1)/$(2)/$(3)/.complete' ] && echo ok))
reprotest-$(1)-$(2)-$(3): .internal-builddep-$(1)-$(2)-$(3)
endif

ifeq (ok,$(shell [ ! -f '$(OUTDIR)/temp/reprotest/$(1)/$(2)/$(3)/.complete' ] && echo ok))
reprotest-$(1)-$(2)-$(3): .internal-reprotestdep-$(1)-$(2)-$(3)
endif

endif

endif

endef

# Finally, walk through architectures that the vendor-distribution provides

define generate_reprotest_target_vd
$(foreach arch,$(call find_supported_vendor_dist_arches,$(1),$(2)),$(eval $(call generate_reprotest_target,$(1),$(2),$(arch))))

reprotest-$(1)-$(2): $(foreach arch,$(call find_supported_vendor_dist_arches,$(1),$(2)),reprotest-$(1)-$(2)-$(arch))
	exit 0
endef

# Walk through supported distributions under each vendor
# (debian-sid, neurodebian-sid ...)

define generate_reprotest_target_v
$(foreach dist,$(call find_supported_vendor_dists,$(1)),$(eval $(call generate_reprotest_target_vd,$(1),$(dist))))

reprotest-$(1): $(foreach dist,$(call find_supported_vendor_dists,$(1)),reprotest-$(1)-$(dist))
	exit 0
endef

# Root of tree to identify all supported vendors (debian, neurodebian, ...)

define generate_reprotest_targets
$(foreach vendor,$(call find_supported_vendors,),$(eval $(call generate_reprotest_target_v,$(vendor))))
endef

#
# End of Makefile-wide functions
#

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

# Find architectures executable on host CPU

$(shell '$(PODMAN)' run \
	--rm \
	'localhost/neurodebian-tooling-arch-test:latest' \
	1>'$(OUTDIR)/temp/exec-arches')

# Generate dynamic targets from distinfo

$(eval $(call generate_export_targets))
$(eval $(call generate_builddep_targets))
$(eval $(call generate_build_targets))
$(eval $(call generate_lintian_targets))
$(eval $(call generate_reprotest_targets))

#
# End of top-level makefile initialization commands
#

#
# Start of Makefile targets
#

#
# Top-level target is always empty
#

all:

#
# Internal target to prepare directory tree for builds targeting specific
# NeuroDebian release
#
# Produces:
# - statefile:          "$(OUTDIR)/logs/00-export-$${VENDOR}-$${DIST}.state.{PASS,FAIL,SKIP}"
# - logfile:            "$(OUTDIR)/logs/00-export-$${VENDOR}-$${DIST}.log"
# - completion marker:  "$(OUTDIR)/temp/export/$${VENDOR}/$${DIST}/.complete"
#
# NOTE: Completion marker is needed because artifacts are in 'temp' directory
# which is deleted by ndbp-build(1) on pipeline completion

.internal-export-%:
	echo "$@"
	# 1. Check if make was interrupted and SKIP
	# 2. Load distinfo helper
	# 3. Get packaging branch for $(VENDOR)-$(DIST)
	# 4. Export the source tree from NeuroDebian synthetic branch
	#    to 'temp/export' directory and save the log of current
	#    operation to 'logs/00-export-$(VENDOR)-$(DIST).log'
	# 5. On failure, set the state of operation to 'FAIL' and
	#    spawn shell if 'SHELL_ON_FAILURE' is set
	#
	# The stem is <VENDOR>-<DIST>
	export VENDOR=$(call word-dash,$*,1); \
	export DIST=$(call word-dash,$*,2); \
	if [ -f "$(OUTDIR)/temp/interrupted" ]; then \
		exit 1; \
	fi; \
	rm -f "$(OUTDIR)/logs/00-export-$${VENDOR}-$${DIST}.state."*; \
	. '$(ndtool_rootdir)/helpers/distinfo-file-helper'; \
	if ! PKGBRANCH="$$(distinfo_get_pkgbranch "$${VENDOR}-$${DIST}")"; then \
		echo "ERROR: Can not find packaging branch '$${PKGBRANCH}' !" \
			1>"$(OUTDIR)/logs/00-export-$${VENDOR}-$${DIST}.log"; \
		echo '' >"$(OUTDIR)/logs/00-export-$${VENDOR}-$${DIST}.state.FAIL"; \
		exit 0; \
	fi; \
	if command -v gbp 1>/dev/null; then \
		'$(SHELL)' '$(ndtool_rootdir)/helpers/export-source-step' \
			'$(CURDIR)' \
			"$${PKGBRANCH}" \
			"$(OUTDIR)/temp/export/$${VENDOR}/$${DIST}" \
			1>"$(OUTDIR)/logs/00-export-$${VENDOR}-$${DIST}.log" \
			2>&1; \
		RET=$$?; \
		if [ "$${RET}" -ne 0 ]; then \
			echo '' >"$(OUTDIR)/logs/00-export-$${VENDOR}-$${DIST}.state.FAIL"; \
		else \
			echo '' >"$(OUTDIR)/logs/00-export-$${VENDOR}-$${DIST}.state.PASS"; \
			echo '' >"$(OUTDIR)/temp/export/$${VENDOR}/$${DIST}/.complete"; \
		fi; \
	else \
		TEMP_CONTAINER_NAME="neurodebian-tooling-temp-$$$$-$${PPID}"; \
		TEMP_OPTS='--rm'; \
		if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
			TEMP_OPTS='-it'; \
		fi; \
		echo '' >"$(OUTDIR)/temp/containernames/$${TEMP_CONTAINER_NAME}"; \
		'$(PODMAN)' run \
			--network '$(NET_OPTS)' \
			--cpu-period '$(CPUPERIOD)' \
			--cpu-quota '$(CPUQUOTA)' \
			--name "$${TEMP_CONTAINER_NAME}" \
			"$${TEMP_OPTS}" \
			-v '$(ndtool_rootdir)/helpers/restart-shell:/restart-shell:ro' \
			-v '$(ndtool_rootdir)/helpers/export-source-step:/export-source-step:ro' \
			-v '$(CURDIR)/:/src:ro' \
			-v "$(OUTDIR)/temp/export/$${VENDOR}/$${DIST}:/dst:rw" \
			localhost/neurodebian-tooling-repo-tools:latest \
			/bin/sh /restart-shell \
			/export-source-step /src "$${PKGBRANCH}" /dst \
			1>"$(OUTDIR)/logs/00-export-$${VENDOR}-$${DIST}.log" \
			2>&1; \
		RET=$$?; \
		if [ "$${RET}" -ne 0 ]; then \
			echo '' >"$(OUTDIR)/logs/00-export-$${VENDOR}-$${DIST}.state.FAIL"; \
			if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
				exit 1; \
			fi; \
		else \
			echo '' >"$(OUTDIR)/logs/00-export-$${VENDOR}-$${DIST}.state.PASS"; \
			echo '' >"$(OUTDIR)/temp/export/$${VENDOR}/$${DIST}/.complete"; \
			if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
				'$(PODMAN)' rm -f "$${TEMP_CONTAINER_NAME}" 1>/dev/null; \
			fi; \
		fi; \
		rm -f "$(OUTDIR)/temp/containernames/$${TEMP_CONTAINER_NAME}"; \
	fi

#
# Internal target to download and cache build dependencies for VENDOR, DIST, ARCH
#
# Produces:
# - statefile:          "$(OUTDIR)/logs/01-builddep-$${VENDOR}-$${DIST}-$${ARCH}.state.{PASS,FAIL,SKIP}"
# - logfile:            "$(OUTDIR)/logs/01-builddep-$${VENDOR}-$${DIST}-$${ARCH}.log"
# - completion marker:  "$(OUTDIR)/temp/dep-cache/$${VENDOR}/$${DIST}/$${ARCH}/.complete"
#
# NOTE: Completion marker is needed because artifacts are in 'temp' directory
# which is deleted by ndbp-build(1) on pipeline completion

.internal-builddep-%:
	echo "$@"
	# 1. Check if make was interrupted and SKIP
	# 2. Check if prepare step PASS or SKIP step
	# 3. Load 'debian/control' and filter helper
	# 4. Check if ARCH is defined among package's binary artifacts
	#    or SKIP step
	# 5. Check if ARCH is among EXEC_ARCHES
	# 6. Spawn the network-attached container of ARCH or NATIVE_ARCH
	#    to download build dependencies or spawn shell on failure
	# 7. Set step PASS
	#
	# The stem is <VENDOR>-<DIST>
	export VENDOR=$(call word-dash,$*,1); \
	export DIST=$(call word-dash,$*,2); \
	export ARCH=$(call word-dash,$*,3); \
	if [ -f "$(OUTDIR)/temp/interrupted" ]; then \
		exit 1; \
	fi; \
	rm -f "$(OUTDIR)/logs/01-builddep-$${VENDOR}-$${DIST}-$${ARCH}.state."*; \
	if [ -f "$(OUTDIR)/logs/00-export-$${VENDOR}-$${DIST}.state.FAIL" ]; then \
		echo 'Step skipped because export action failed' \
			1>"$(OUTDIR)/logs/01-builddep-$${VENDOR}-$${DIST}-$${ARCH}.log"; \
		echo '' >"$(OUTDIR)/logs/01-builddep-$${VENDOR}-$${DIST}-$${ARCH}.state.FAIL"; \
		exit 0; \
	elif [ -f "$(OUTDIR)/logs/00-export-$${VENDOR}-$${DIST}.state.SKIP" ]; then \
		echo 'Step skipped because export action skipped' \
			1>"$(OUTDIR)/logs/01-builddep-$${VENDOR}-$${DIST}-$${ARCH}.log"; \
		echo '' >"$(OUTDIR)/logs/01-builddep-$${VENDOR}-$${DIST}-$${ARCH}.state.SKIP"; \
		exit 0; \
	fi; \
	. '$(ndtool_rootdir)/helpers/debian-control-file-helper'; \
	. '$(ndtool_rootdir)/helpers/filter-helper'; \
	if ! control_assert_binpkg_architecture "$${ARCH}"; then \
		echo "Step skipped because package does not define build target for $${ARCH}" \
			1>"$(OUTDIR)/logs/01-builddep-$${VENDOR}-$${DIST}-$${ARCH}.log"; \
		echo '' >"$(OUTDIR)/logs/01-builddep-$${VENDOR}-$${DIST}-$${ARCH}.state.SKIP"; \
		exit 0; \
	fi; \
	mkdir -p "$(OUTDIR)/temp/dep-cache/$${VENDOR}/$${DIST}/$${ARCH}"; \
	TEMP_CONTAINER_NAME="neurodebian-tooling-temp-$$$$-$${PPID}"; \
	TEMP_OPTS='--rm'; \
	if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
		TEMP_OPTS='-it'; \
	fi; \
	EXEC_ARCHES="$$(cat '$(OUTDIR)/temp/exec-arches')"; \
	CONTAINER_ARCH='$(NATIVE_ARCH)'; \
	if [ -n "$$(filter_common "$${ARCH}" "$${EXEC_ARCHES}")" ]; then \
		CONTAINER_ARCH="$${ARCH}"; \
	fi; \
	echo '' >"$(OUTDIR)/temp/containernames/$${TEMP_CONTAINER_NAME}"; \
	'$(PODMAN)' run \
		--network '$(NET_OPTS)' \
		--cpu-period '$(CPUPERIOD)' \
		--cpu-quota '$(CPUQUOTA)' \
		--name "$${TEMP_CONTAINER_NAME}" \
		"$${TEMP_OPTS}" \
		-v '$(ndtool_rootdir)/helpers/restart-shell:/restart-shell:ro' \
		-v '$(ndtool_rootdir)/helpers/get-build-dep-step:/get-build-dep-step:ro' \
		-v "$(OUTDIR)/temp/export/$${VENDOR}/$${DIST}:/src:ro" \
		-v "$(OUTDIR)/temp/dep-cache/$${VENDOR}/$${DIST}/$${ARCH}:/cache:rw" \
		"localhost/neurodebian-tooling-builder:$${VENDOR}-$${DIST}-$${CONTAINER_ARCH}" \
		/bin/sh /restart-shell \
		/get-build-dep-step /src "$${ARCH}" /cache \
		1>"$(OUTDIR)/logs/01-builddep-$${VENDOR}-$${DIST}-$${ARCH}.log" \
		2>&1; \
	RET=$$?; \
	if [ "$${RET}" -ne 0 ]; then \
		echo '' >"$(OUTDIR)/logs/01-builddep-$${VENDOR}-$${DIST}-$${ARCH}.state.FAIL"; \
		if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
			exit 1; \
		fi; \
	else \
		echo '' >"$(OUTDIR)/logs/01-builddep-$${VENDOR}-$${DIST}-$${ARCH}.state.PASS"; \
		echo '' >"$(OUTDIR)/temp/dep-cache/$${VENDOR}/$${DIST}/$${ARCH}/.complete"; \
		if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
			'$(PODMAN)' rm -f "$${TEMP_CONTAINER_NAME}" 1>/dev/null; \
		fi; \
	fi; \
	rm -f "$(OUTDIR)/temp/containernames/$${TEMP_CONTAINER_NAME}"

#
# Internal target to download and cache reprotest dependencies for VENDOR, DIST, ARCH
#
# Produces:
# - statefile:          "$(OUTDIR)/logs/04-reprotestdep-$${VENDOR}-$${DIST}-$${ARCH}.state.{PASS,FAIL,SKIP}"
# - logfile:            "$(OUTDIR)/logs/04-reprotestdep-$${VENDOR}-$${DIST}-$${ARCH}.log"
# - completion marker:  "$(OUTDIR)/temp/reprotest/$${VENDOR}/$${DIST}/$${ARCH}/.complete"
#
# NOTE: Completion marker is needed because artifacts are in 'temp' directory
# which is deleted by ndbp-build(1) on pipeline completion

.internal-reprotestdep-%:
	echo "$@"
	# 1. Check if make was interrupted and SKIP
	# 2. Load 'debian/control' and filter helper
	# 3. Check if ARCH is defined among package's binary artifacts
	#    or SKIP step
	# 4. Check if ARCH is among EXEC_ARCHES
	# 5. Spawn the network-attached container of ARCH or NATIVE_ARCH
	#    to download build dependencies or spawn shell on failure
	# 6. Set step PASS
	#
	# The stem is <VENDOR>-<DIST>
	export VENDOR=$(call word-dash,$*,1); \
	export DIST=$(call word-dash,$*,2); \
	export ARCH=$(call word-dash,$*,3); \
	if [ -f "$(OUTDIR)/temp/interrupted" ]; then \
		exit 1; \
	fi; \
	rm -f "$(OUTDIR)/logs/04-reprotestdep-$${VENDOR}-$${DIST}-$${ARCH}.state."*; \
	. '$(ndtool_rootdir)/helpers/debian-control-file-helper'; \
	. '$(ndtool_rootdir)/helpers/filter-helper'; \
	if ! control_assert_binpkg_architecture "$${ARCH}"; then \
		echo "Step skipped because package does not define build target for $${ARCH}" \
			1>"$(OUTDIR)/logs/04-reprotestdep-$${VENDOR}-$${DIST}-$${ARCH}.log"; \
		echo '' >"$(OUTDIR)/logs/04-reprotestdep-$${VENDOR}-$${DIST}-$${ARCH}.state.SKIP"; \
		exit 0; \
	fi; \
	mkdir -p "$(OUTDIR)/temp/reprotest/$${VENDOR}/$${DIST}/$${ARCH}"; \
	TEMP_CONTAINER_NAME="neurodebian-tooling-temp-$$$$-$${PPID}"; \
	TEMP_OPTS='--rm'; \
	if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
		TEMP_OPTS='-it'; \
	fi; \
	EXEC_ARCHES="$$(cat '$(OUTDIR)/temp/exec-arches')"; \
	CONTAINER_ARCH='$(NATIVE_ARCH)'; \
	if [ -n "$$(filter_common "$${ARCH}" "$${EXEC_ARCHES}")" ]; then \
		CONTAINER_ARCH="$${ARCH}"; \
	fi; \
	echo '' >"$(OUTDIR)/temp/containernames/$${TEMP_CONTAINER_NAME}"; \
	'$(PODMAN)' run \
		--network '$(NET_OPTS)' \
		--cpu-period '$(CPUPERIOD)' \
		--cpu-quota '$(CPUQUOTA)' \
		--name "$${TEMP_CONTAINER_NAME}" \
		"$${TEMP_OPTS}" \
		-v '$(ndtool_rootdir)/helpers/restart-shell:/restart-shell:ro' \
		-v '$(ndtool_rootdir)/helpers/get-reprotest-dep-step:/get-reprotest-dep-step:ro' \
		-v "$(OUTDIR)/temp/reprotest/$${VENDOR}/$${DIST}/$${ARCH}:/cache:rw" \
		"localhost/neurodebian-tooling-builder:$${VENDOR}-$${DIST}-$${CONTAINER_ARCH}" \
		/bin/sh /restart-shell \
		/get-reprotest-dep-step "$${ARCH}" /cache \
		1>"$(OUTDIR)/logs/04-reprotestdep-$${VENDOR}-$${DIST}-$${ARCH}.log" \
		2>&1; \
	RET=$$?; \
	if [ "$${RET}" -ne 0 ]; then \
		echo '' >"$(OUTDIR)/logs/04-reprotestdep-$${VENDOR}-$${DIST}-$${ARCH}.state.FAIL"; \
		if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
			exit 1; \
		fi; \
	else \
		echo '' >"$(OUTDIR)/logs/04-reprotestdep-$${VENDOR}-$${DIST}-$${ARCH}.state.PASS"; \
		echo '' >"$(OUTDIR)/temp/reprotest/$${VENDOR}/$${DIST}/$${ARCH}/.complete"; \
		if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
			'$(PODMAN)' rm -f "$${TEMP_CONTAINER_NAME}" 1>/dev/null; \
		fi; \
	fi; \
	rm -f "$(OUTDIR)/temp/containernames/$${TEMP_CONTAINER_NAME}"

#
# Public target to build the package for VENDOR, DIST, ARCH
#
# Produces:
# - statefile:          "$(OUTDIR)/logs/02-build-$${VENDOR}-$${DIST}-$${ARCH}.state.{PASS,FAIL,SKIP}"
# - logfile:            "$(OUTDIR)/logs/02-build-$${VENDOR}-$${DIST}-$${ARCH}.log"
# - completion marker:  "$(OUTDIR)/packages/$${VENDOR}/$${DIST}/$${ARCH}/.complete"
#
# NOTE: Completion marker is needed because constructing proper name
# of dsc/changes file is hard

build-%:
	echo "$@"
	# 1. Check if make was interrupted and SKIP
	# 2. Check if builddep step PASS or SKIP step
	# 3. Check completion marker and SKIP step
	# 4. Load 'debian/control' and filter helper
	# 5. Check if ARCH is defined among package's binary artifacts
	#    or SKIP step
	# 6. Check if ARCH is among EXEC_ARCHES
	# 7. Spawn the network-detached container of ARCH or NATIVE_ARCH
	#    to perform build or spawn shell on failure
	# 8. Set step PASS
	#
	# The stem is <VENDOR>-<DIST>
	export VENDOR=$(call word-dash,$*,1); \
	export DIST=$(call word-dash,$*,2); \
	export ARCH=$(call word-dash,$*,3); \
	if [ -f "$(OUTDIR)/temp/interrupted" ]; then \
		exit 1; \
	fi; \
	if [ -f "$(OUTDIR)/packages/$${VENDOR}/$${DIST}/$${ARCH}/.complete" ]; then \
		exit 0; \
	fi; \
	rm -f "$(OUTDIR)/logs/02-build-$${VENDOR}-$${DIST}-$${ARCH}.state."*; \
	if [ -f "$(OUTDIR)/logs/01-builddep-$${VENDOR}-$${DIST}-$${ARCH}.state.FAIL" ]; then \
		echo 'Step skipped because builddep action failed' \
			1>"$(OUTDIR)/logs/02-build-$${VENDOR}-$${DIST}-$${ARCH}.log"; \
		echo '' >"$(OUTDIR)/logs/02-build-$${VENDOR}-$${DIST}-$${ARCH}.state.FAIL"; \
		exit 0; \
	elif [ -f "$(OUTDIR)/logs/01-builddep-$${VENDOR}-$${DIST}-$${ARCH}.state.SKIP" ]; then \
		echo 'Step skipped because builddep action skipped' \
			1>"$(OUTDIR)/logs/02-build-$${VENDOR}-$${DIST}-$${ARCH}.log"; \
		echo '' >"$(OUTDIR)/logs/02-build-$${VENDOR}-$${DIST}-$${ARCH}.state.SKIP"; \
		exit 0; \
	fi; \
	. '$(ndtool_rootdir)/helpers/debian-control-file-helper'; \
	. '$(ndtool_rootdir)/helpers/filter-helper'; \
	if ! control_assert_binpkg_architecture "$${ARCH}"; then \
		echo "Step skipped because package does not define build target for $${ARCH}" \
			1>"$(OUTDIR)/logs/02-build-$${VENDOR}-$${DIST}-$${ARCH}.log"; \
		echo '' >"$(OUTDIR)/logs/02-build-$${VENDOR}-$${DIST}-$${ARCH}.state.SKIP"; \
		exit 0; \
	fi; \
	mkdir -p "$(OUTDIR)/packages/$${VENDOR}/$${DIST}/$${ARCH}"; \
	TEMP_CONTAINER_NAME="neurodebian-tooling-temp-$$$$-$${PPID}"; \
	TEMP_OPTS='--rm'; \
	if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
		TEMP_OPTS='-it'; \
	fi; \
	EXEC_ARCHES="$$(cat '$(OUTDIR)/temp/exec-arches')"; \
	CONTAINER_ARCH='$(NATIVE_ARCH)'; \
	if [ -n "$$(filter_common "$${ARCH}" "$${EXEC_ARCHES}")" ]; then \
		CONTAINER_ARCH="$${ARCH}"; \
	fi; \
	RULES_REQUIRES_ROOT='yes'; \
	if control_rules_requires_root; then \
		RULES_REQUIRES_ROOT='no'; \
	fi; \
	echo '' >"$(OUTDIR)/temp/containernames/$${TEMP_CONTAINER_NAME}"; \
	'$(PODMAN)' run \
		--network none \
		--cpu-period '$(CPUPERIOD)' \
		--cpu-quota '$(CPUQUOTA)' \
		--name "$${TEMP_CONTAINER_NAME}" \
		"$${TEMP_OPTS}" \
		-v '$(ndtool_rootdir)/helpers/restart-shell:/restart-shell:ro' \
		-v '$(ndtool_rootdir)/helpers/build-package-step:/build-package-step:ro' \
		-v "$(OUTDIR)/temp/export/$${VENDOR}/$${DIST}:/src:ro" \
		-v "$(OUTDIR)/temp/dep-cache/$${VENDOR}/$${DIST}/$${ARCH}:/cache:ro" \
		-v "$(OUTDIR)/packages/$${VENDOR}/$${DIST}/$${ARCH}:/dst:rw" \
		"localhost/neurodebian-tooling-builder:$${VENDOR}-$${DIST}-$${CONTAINER_ARCH}" \
		/bin/sh /restart-shell \
		/build-package-step /src "$${ARCH}" /cache /dst "$${RULES_REQUIRES_ROOT}" \
		1>"$(OUTDIR)/logs/02-build-$${VENDOR}-$${DIST}-$${ARCH}.log" \
		2>&1; \
	RET=$$?; \
	if [ "$${RET}" -ne 0 ]; then \
		echo '' >"$(OUTDIR)/logs/02-build-$${VENDOR}-$${DIST}-$${ARCH}.state.FAIL"; \
		if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
			exit 1; \
		fi; \
	else \
		echo '' >"$(OUTDIR)/logs/02-build-$${VENDOR}-$${DIST}-$${ARCH}.state.PASS"; \
		echo '' >"$(OUTDIR)/packages/$${VENDOR}/$${DIST}/$${ARCH}/.complete"; \
		if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
			'$(PODMAN)' rm -f "$${TEMP_CONTAINER_NAME}" 1>/dev/null; \
		fi; \
	fi; \
	rm -f "$(OUTDIR)/temp/containernames/$${TEMP_CONTAINER_NAME}"

#
# Public target to lint the package for VENDOR, DIST, ARCH
#
# Produces:
# - statefile:          "$(OUTDIR)/logs/03-lintian-$${VENDOR}-$${DIST}-$${ARCH}.state.{PASS,FAIL,SKIP}"
# - logfile:            "$(OUTDIR)/logs/03-lintian-$${VENDOR}-$${DIST}-$${ARCH}.log"
#

lintian-%:
	echo "$@"
	# 1. Check if make was interrupted and SKIP
	# 2. Check completion marker and SKIP step
	# 3. Spawn the network-detached container of NATIVE_ARCH
	#    to perform linting spawn shell on failure
	# 4. Set step PASS
	#
	# The stem is <VENDOR>-<DIST>
	export VENDOR=$(call word-dash,$*,1); \
	export DIST=$(call word-dash,$*,2); \
	export ARCH=$(call word-dash,$*,3); \
	if [ -f "$(OUTDIR)/temp/interrupted" ]; then \
		exit 1; \
	fi; \
	if [ -f "$(OUTDIR)/logs/03-lintian-$${VENDOR}-$${DIST}-$${ARCH}.state.PASS" ]; then \
		exit 0; \
	fi; \
	rm -f "$(OUTDIR)/logs/03-lintian-$${VENDOR}-$${DIST}-$${ARCH}.state."*; \
	if [ -f "$(OUTDIR)/logs/02-build-$${VENDOR}-$${DIST}-$${ARCH}.state.FAIL" ]; then \
		echo 'Step skipped because build action failed' \
			1>"$(OUTDIR)/logs/03-lintian-$${VENDOR}-$${DIST}-$${ARCH}.log"; \
		echo '' >"$(OUTDIR)/logs/03-lintian-$${VENDOR}-$${DIST}-$${ARCH}.state.FAIL"; \
		exit 0; \
	elif [ -f "$(OUTDIR)/logs/02-build-$${VENDOR}-$${DIST}-$${ARCH}.state.SKIP" ]; then \
		echo 'Step skipped because build action skipped' \
			1>"$(OUTDIR)/logs/03-lintian-$${VENDOR}-$${DIST}-$${ARCH}.log"; \
		echo '' >"$(OUTDIR)/logs/03-lintian-$${VENDOR}-$${DIST}-$${ARCH}.state.SKIP"; \
		exit 0; \
	fi; \
	TEMP_CONTAINER_NAME="neurodebian-tooling-temp-$$$$-$${PPID}"; \
	TEMP_OPTS='--rm'; \
	if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
		TEMP_OPTS='-it'; \
	fi; \
	echo '' >"$(OUTDIR)/temp/containernames/$${TEMP_CONTAINER_NAME}"; \
	'$(PODMAN)' run \
		--network none \
		--cpu-period '$(CPUPERIOD)' \
		--cpu-quota '$(CPUQUOTA)' \
		--name "$${TEMP_CONTAINER_NAME}" \
		"$${TEMP_OPTS}" \
		-v '$(ndtool_rootdir)/helpers/restart-shell:/restart-shell:ro' \
		-v '$(ndtool_rootdir)/helpers/lintian-package-step:/lintian-package-step:ro' \
		-v "$(OUTDIR)/packages/$${VENDOR}/$${DIST}/$${ARCH}:/src:rw" \
		"localhost/neurodebian-tooling-lintian:latest" \
		/bin/sh /restart-shell \
		/lintian-package-step /src \
		1>"$(OUTDIR)/logs/03-lintian-$${VENDOR}-$${DIST}-$${ARCH}.log" \
		2>&1; \
	RET=$$?; \
	if [ "$${RET}" -ne 0 ]; then \
		echo '' >"$(OUTDIR)/logs/03-lintian-$${VENDOR}-$${DIST}-$${ARCH}.state.FAIL"; \
		if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
			exit 1; \
		fi; \
	else \
		echo '' >"$(OUTDIR)/logs/03-lintian-$${VENDOR}-$${DIST}-$${ARCH}.state.PASS"; \
		if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
			'$(PODMAN)' rm -f "$${TEMP_CONTAINER_NAME}" 1>/dev/null; \
		fi; \
	fi; \
	rm -f "$(OUTDIR)/temp/containernames/$${TEMP_CONTAINER_NAME}"

#
# Public target to test reproducibility the package for VENDOR, DIST, ARCH
#
# Produces:
# - statefile:          "$(OUTDIR)/logs/05-reprotest-$${VENDOR}-$${DIST}-$${ARCH}.state.{PASS,FAIL,SKIP}"
# - logfile:            "$(OUTDIR)/logs/05-reprotest-$${VENDOR}-$${DIST}-$${ARCH}.log"
#

reprotest-%:
	echo "$@"
	# 1. Check if make was interrupted and SKIP
	# 2. Check completion marker and SKIP step
	# 3. Load 'debian/control' and filter helper
	# 4. Check if ARCH is defined among package's binary artifacts
	#    or SKIP step
	# 5. Check if ARCH is among EXEC_ARCHES
	# 6. Spawn the network-detached container of ARCH or NATIVE_ARCH
	#    to perform build or spawn shell on failure
	# 7. Set step PASS
	#
	# The stem is <VENDOR>-<DIST>
	export VENDOR=$(call word-dash,$*,1); \
	export DIST=$(call word-dash,$*,2); \
	export ARCH=$(call word-dash,$*,3); \
	if [ -f "$(OUTDIR)/temp/interrupted" ]; then \
		exit 1; \
	fi; \
	if [ -f "$(OUTDIR)/logs/05-reprotest-$${VENDOR}-$${DIST}-$${ARCH}.state.PASS" ]; then \
		exit 0; \
	fi; \
	rm -f "$(OUTDIR)/logs/05-reprotest-$${VENDOR}-$${DIST}-$${ARCH}.state."*; \
	if [ -f "$(OUTDIR)/logs/01-builddep-$${VENDOR}-$${DIST}-$${ARCH}.state.FAIL" ]; then \
		echo 'Step skipped because builddep action failed' \
			1>"$(OUTDIR)/logs/05-reprotest-$${VENDOR}-$${DIST}-$${ARCH}.log"; \
		echo '' >"$(OUTDIR)/logs/05-reprotest-$${VENDOR}-$${DIST}-$${ARCH}.state.FAIL"; \
		exit 0; \
	elif [ -f "$(OUTDIR)/logs/01-builddep-$${VENDOR}-$${DIST}-$${ARCH}.state.SKIP" ]; then \
		echo 'Step skipped because builddep action skipped' \
			1>"$(OUTDIR)/logs/05-reprotest-$${VENDOR}-$${DIST}-$${ARCH}.log"; \
		echo '' >"$(OUTDIR)/logs/05-reprotest-$${VENDOR}-$${DIST}-$${ARCH}.state.SKIP"; \
		exit 0; \
	fi; \
	if [ -f "$(OUTDIR)/logs/04-reprotestdep-$${VENDOR}-$${DIST}-$${ARCH}.state.FAIL" ]; then \
		echo 'Step skipped because installing reprotest action failed' \
			1>"$(OUTDIR)/logs/05-reprotest-$${VENDOR}-$${DIST}-$${ARCH}.log"; \
		echo '' >"$(OUTDIR)/logs/05-reprotest-$${VENDOR}-$${DIST}-$${ARCH}.state.FAIL"; \
		exit 0; \
	elif [ -f "$(OUTDIR)/logs/04-reprotestdep-$${VENDOR}-$${DIST}-$${ARCH}.state.SKIP" ]; then \
		echo 'Step skipped because installing reprotest action skipped' \
			1>"$(OUTDIR)/logs/05-reprotest-$${VENDOR}-$${DIST}-$${ARCH}.log"; \
		echo '' >"$(OUTDIR)/logs/05-reprotest-$${VENDOR}-$${DIST}-$${ARCH}.state.SKIP"; \
		exit 0; \
	fi; \
	. '$(ndtool_rootdir)/helpers/debian-control-file-helper'; \
	. '$(ndtool_rootdir)/helpers/filter-helper'; \
	if ! control_assert_binpkg_architecture "$${ARCH}"; then \
		echo "Step skipped because package does not define build target for $${ARCH}" \
			1>"$(OUTDIR)/logs/05-reprotest-$${VENDOR}-$${DIST}-$${ARCH}.log"; \
		echo '' >"$(OUTDIR)/logs/05-reprotest-$${VENDOR}-$${DIST}-$${ARCH}.state.SKIP"; \
		exit 0; \
	fi; \
	mkdir -p "$(OUTDIR)/reprotest/$${VENDOR}/$${DIST}/$${ARCH}"; \
	TEMP_CONTAINER_NAME="neurodebian-tooling-temp-$$$$-$${PPID}"; \
	TEMP_OPTS='--rm'; \
	if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
		TEMP_OPTS='-it'; \
	fi; \
	EXEC_ARCHES="$$(cat '$(OUTDIR)/temp/exec-arches')"; \
	CONTAINER_ARCH='$(NATIVE_ARCH)'; \
	if [ -n "$$(filter_common "$${ARCH}" "$${EXEC_ARCHES}")" ]; then \
		CONTAINER_ARCH="$${ARCH}"; \
	fi; \
	echo '' >"$(OUTDIR)/temp/containernames/$${TEMP_CONTAINER_NAME}"; \
	'$(PODMAN)' run \
		--network none \
		--cpu-period '$(CPUPERIOD)' \
		--cpu-quota '$(CPUQUOTA)' \
		--name "$${TEMP_CONTAINER_NAME}" \
		"$${TEMP_OPTS}" \
		-v '$(ndtool_rootdir)/helpers/restart-shell:/restart-shell:ro' \
		-v '$(ndtool_rootdir)/helpers/setarch-helper:/usr/bin/setarch-helper:ro' \
		-v '$(ndtool_rootdir)/helpers/reprotest-package-step:/reprotest-package-step:ro' \
		-v "$(OUTDIR)/temp/export/$${VENDOR}/$${DIST}:/src:ro" \
		-v "$(OUTDIR)/temp/dep-cache/$${VENDOR}/$${DIST}/$${ARCH}:/dep-cache:ro" \
		-v "$(OUTDIR)/temp/reprotest/$${VENDOR}/$${DIST}/$${ARCH}:/reprotest-cache:ro" \
		-v "$(OUTDIR)/reprotest/$${VENDOR}/$${DIST}/$${ARCH}:/dst:rw" \
		"localhost/neurodebian-tooling-builder:$${VENDOR}-$${DIST}-$${CONTAINER_ARCH}" \
		/bin/sh /restart-shell \
		/reprotest-package-step /src "$${ARCH}" /dep-cache /reprotest-cache /dst \
		1>"$(OUTDIR)/logs/05-reprotest-$${VENDOR}-$${DIST}-$${ARCH}.log" \
		2>&1; \
	RET=$$?; \
	if [ "$${RET}" -ne 0 ]; then \
		echo '' >"$(OUTDIR)/logs/05-reprotest-$${VENDOR}-$${DIST}-$${ARCH}.state.FAIL"; \
		if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
			exit 1; \
		fi; \
	else \
		echo '' >"$(OUTDIR)/logs/05-reprotest-$${VENDOR}-$${DIST}-$${ARCH}.state.PASS"; \
		if [ '$(SHELL_ON_FAILURE)' -eq 1 ]; then \
			'$(PODMAN)' rm -f "$${TEMP_CONTAINER_NAME}" 1>/dev/null; \
		fi; \
	fi; \
	rm -f "$(OUTDIR)/temp/containernames/$${TEMP_CONTAINER_NAME}"
