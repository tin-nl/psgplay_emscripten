# SPDX-License-Identifier: GPL-2.0
#
# Do "make help" for targets and options.

CFLAGS += -g -O2 -Wall -Iinclude -D_GNU_SOURCE

LIBS += -lm

ifeq "$(S)" "1"
S_CFLAGS += -fsanitize=address -fsanitize=leak -fsanitize=undefined	\
	  -fsanitize-address-use-after-scope -fstack-check
endif

ifeq "$(ALSA)" "1"
HAVE_CFLAGS += -DHAVE_ALSA
LIBS += -lasound
endif

ALL_CFLAGS += $(CFLAGS) $(HAVE_CFLAGS) $(S_CFLAGS) $(BASIC_CFLAGS)

.PHONY: all
all: tool

PSGPLAY := tool/psgplay

.PHONY: tool
tool: $(PSGPLAY)

include lib/Makefile

SRC := $(filter-out $(VER), $(wildcard tool/*.c))			\
	$(ATARI_SRC) $(M68K_SRC) $(OUT_SRC) $(SNDH_SRC) $(UNICODE_SRC) $(VER)
OBJ = $(patsubst %.c, %.o, $(SRC))

$(PSGPLAY): $(OBJ)
	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $^ $(LIBS)

$(OBJ): %.o : %.c
	$(QUIET_CC)$(CC) $(ALL_CFLAGS) -c -o $@ $<

.PHONY: clean
clean:
	$(QUIET_RM)$(RM) -f */*.o* */*/*.o* include/tos/tos.h		\
		GPATH GRTAGS GTAGS 					\
		$(M68K_GEN_H) $(M68K_GEN_C) $(VER) $(PSGPLAY) $(M68KMAKE)

.PHONY: gtags
gtags:
	gtags

.PHONY: help
help:
	@echo "Targets:"
	@echo "  all            - compile the PSG player (default)"
	@echo "  clean          - remove generated files"
	@echo
	@echo "Options:"
	@echo "  V              - set to 1 to compile verbosely"
	@echo "  S              - set to 1 for sanitation checks"
	@echo "  ALSA           - set to 1 to support ALSA for Linux"
	@echo "  CROSS_COMPILE  - set m68k cross compiler to use to build the TOS stub"
	@echo
	@echo "Example:"
	@echo "  make ALSA=1 CROSS_COMPILE=m68k-unknown-linux-gnu-"

V             = @
Q             = $(V:1=)
QUIET_AR      = $(Q:@=@echo    '  AR      '$@;)
QUIET_AS      = $(Q:@=@echo    '  AS      '$@;)
QUIET_CC      = $(Q:@=@echo    '  CC      '$@;)
QUIET_GEN     = $(Q:@=@echo    '  GEN     '$@;)
QUIET_LINK    = $(Q:@=@echo    '  LD      '$@;)
QUIET_TEST    = $(Q:@=@echo    '  TEST    '$@;)
QUIET_RM      = $(Q:@=@echo    '  RM      '$@;)

BASIC_CFLAGS += -Wp,-MMD,$(@D)/$(@F).d -MT $(@D)/$(@F)

ifneq "$(MAKECMDGOALS)" "clean"
    DEP_FILES := $(addsuffix .d, $(OBJ))
    $(if $(DEP_FILES),$(eval -include $(DEP_FILES)))
endif
