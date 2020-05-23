// SPDX-License-Identifier: GPL-2.0

#ifndef TOSLIBC_STRING_H
#define TOSLIBC_STRING_H

#include <stddef.h>

void *memcpy(void *dst, const void *src, size_t nbytes);

void *memset(void *s, int c, size_t n);;

int strcmp(const char *s1, const char *s2);

size_t strlen(const char *s);

int strncmp(const char *s1, const char *s2, size_t n);

char *strncpy(char *dst, const char *src, size_t n);

#endif /* TOSLIBC_STRING_H */