// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (C) 2019 Fredrik Noring
 */

#ifndef ATARI_MACHINE_H
#define ATARI_MACHINE_H

#include "atari/sample.h"

#include "psgplay/types.h"

#define MACHINE_FREQUENCY 8000000

struct machine {
	void (*init)(const void *prg, size_t size, u32 track,
		int sample_frequency, sample_f sample, void *sample_arg);
	bool (*run)(void);
};

u64 cycle_transform(u64 to_frequency, u64 from_frequcy, u64 cycle);

u64 cycle_transform_align(u64 to_frequency, u64 from_frequcy, u64 cycle);

u64 machine_cycle(void);

void machine_execute(void);

extern const struct machine atari_st;

#endif /* ATARI_MACHINE_H */
