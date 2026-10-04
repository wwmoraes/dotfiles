.PHONY: files
#: Re-generates files managed by nix.
files:

define writeFilesTarget
$(1) &:
	nix run .#write-files
	@touch $(1)
endef

define writeFlakeTarget
$(1):
	nix run .#write-flake
	@touch $(1)
endef

dep:: .make/write-files.d

.make/write-files.d: FILES_ATTRS = $(strip $(shell git ls-files -- ':(attr:generates write-files)' | xargs git check-attr files | cut -d' ' -f3))
.make/write-files.d: OUTPUTS = $(strip $(shell git ls-files -- ':(attr:generated write-files)'))
.make/write-files.d:
	$(file >$@)
	$(file >>$@,# add write-files outputs to the porcelain files target)
	$(foreach OUTPUT,${OUTPUTS},$(file >>$@,files: ${OUTPUT}))
	$(file >>$@,)
	$(file >>$@,# files' dependencies)
	$(foreach ATTR,${FILES_ATTRS},$(foreach SOURCE,$(strip $(shell git ls-files -- ':(attr:generates write-files files=${ATTR})')),$(file >>$@,$(strip $(shell git ls-files -- ':(attr:generated write-files files=${ATTR})')): ${SOURCE})))
	$(file >>$@,)
	$(file >>$@,# files' recipe)
	$(file >>$@,$(call writeFilesTarget,${OUTPUTS}))
	@touch $@
	@echo $@ generated

dep:: .make/write-flake.d

.make/write-flake.d: SOURCES = $(strip $(shell git ls-files -- ':(attr:generates write-flake)'))
.make/write-flake.d: OUTPUTS = $(strip $(shell git ls-files -- ':(attr:generated write-flake)'))
.make/write-flake.d:
	$(file >$@)
	$(file >>$@,# add write-flake outputs to the porcelain files target)
	$(foreach OUTPUT,${OUTPUTS},$(file >>$@,files: ${OUTPUT}))
	$(file >>$@,)
	$(file >>$@,# flake dependencies)
	$(foreach SOURCE,${SOURCES},$(file >>$@,${OUTPUTS}: ${SOURCE}))
	$(file >>$@,)
	$(file >>$@,# flake recipe)
	$(file >>$@,$(call writeFlakeTarget,${OUTPUTS}))
	@touch $@
	@echo $@ generated
