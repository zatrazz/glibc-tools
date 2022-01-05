/* Internal function for converting integers to ASCII.

   Copyright (C) 2022 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify it
   under the terms of the GNU Lesser General Public License as published
   by the Free Software Foundation; either version 2.1 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

#ifndef _ITOA_H
#define _ITOA_H

#include <common.h>
#include <limits.h>

/* When long long is different from long, by default, _itoa_word is
   provided to convert long to ASCII and _itoa is provided to convert
   long long.  A sysdeps _itoa.h can define _ITOA_NEEDED to 0 and define
   _ITOA_WORD_TYPE to unsigned long long int to override it so that
   _itoa_word is changed to convert long long to ASCII and _itoa is
   mapped to _itoa_word.  */

#ifndef _ITOA_NEEDED
# define _ITOA_NEEDED           (LONG_MAX != LLONG_MAX)
#endif
#ifndef _ITOA_WORD_TYPE
# define _ITOA_WORD_TYPE        unsigned long int
#endif

extern char *_itoa_word (_ITOA_WORD_TYPE value, char *buflim,
                         unsigned int base,
                         int upper_case) attribute_hidden;

#endif
