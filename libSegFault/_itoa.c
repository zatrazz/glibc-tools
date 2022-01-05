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

#include <_itoa.h>

/* Upper-case digits.  */
static const char _itoa_upper_digits[36]
 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
/* Lower-case digits.  */
static const char _itoa_lower_digits[36]
 = "0123456789abcdefghijklmnopqrstuvwxyz";

char *
_itoa_word (_ITOA_WORD_TYPE value, char *buflim,
            unsigned int base, int upper_case)
{
  const char *digits = (upper_case
                        ? _itoa_upper_digits
                        : _itoa_lower_digits);

  switch (base)
    {
#define SPECIAL(Base)                                                         \
    case Base:                                                                \
      do                                                                      \
        *--buflim = digits[value % Base];                                     \
      while ((value /= Base) != 0);                                           \
      break

      SPECIAL (10);
      SPECIAL (16);
      SPECIAL (8);
    default:
      do
        *--buflim = digits[value % base];
      while ((value /= base) != 0);
    }
  return buflim;
}
#undef SPECIAL

