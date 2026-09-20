.PHONY: files
#: Re-generates files managed by nix.
files:

define writeFilesTarget
$(1) &: $(2)
	nix run .#write-files
	@touch $(1)
endef

define writeFlakeTarget
$(1) &: $(2)
	nix run .#write-flake
	@touch $(1)
endef

.PHONY: .make/*.d
dep: .make/write-files.d
dep: .make/write-flake.d
#: (re)generates dependency files
dep: ; @true

.make/write-files.d: SOURCES=$(strip $(shell git ls-files -- ':(attr:generates write-files)'))
.make/write-files.d: OUTPUTS=$(strip $(shell git ls-files -- ':(attr:generated write-files)'))
.make/write-files.d:
	$(file >$@)
	$(file >>$@,files: ${OUTPUTS})
	$(file >>$@,$(call writeFilesTarget,${OUTPUTS},${SOURCES}))
	@echo $@ generated

.make/write-flake.d: SOURCES=$(strip $(shell git ls-files -- ':(attr:generates write-flake)'))
.make/write-flake.d: OUTPUTS=$(strip $(shell git ls-files -- ':(attr:generated write-flake)'))
.make/write-flake.d:
	$(file >$@)
	$(file >>$@,files: ${OUTPUTS})
	$(file >>$@,$(call writeFlakeTarget,${OUTPUTS},${SOURCES}))
	@echo $@ generated
