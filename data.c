/* SPIM S20 MIPS simulator.
   Code to manipulate data segment directives.

   Copyright (C) 1990-2000 by James Larus (larus@cs.wisc.edu).
   ALL RIGHTS RESERVED.

   SPIM is distributed under the following conditions:

     You may make copies of SPIM for your own use and modify those copies.

     All copies of SPIM must retain my name and copyright notice.

     You may not sell SPIM or distributed SPIM in conjunction with a
     commerical product or service without the expressed written consent of
     James Larus.

   THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
   PURPOSE. */


/* $Header: /Software/SPIM/src/data.c 4     12/24/00 1:37p Larus $
*/


#include "spim.h"
#include "spim-utils.h"
#include "inst.h"
#include "mem.h"
#include "reg.h"
#include "sym-tbl.h"
#include "parser.h"
#include "run.h"
#include "data.h"


/* The first 64K of the data segment are dedicated to small data
   segment, which is pointed to by $gp. This register points to the
   middle of the segment, so we can use the full offset field in an
   instruction. */

static mem_addr next_data_pc;	/* Location for next datum in user process */

static mem_addr next_k_data_pc;	/* Location for next datum in kernel */

static int in_kernel = 0;	/* Non-zero => data goes to kdata, not data */

#define DATA_PC (in_kernel ? next_k_data_pc : next_data_pc)

#define BUMP_DATA_PC(DELTA) {if (in_kernel) \
				next_k_data_pc += DELTA; \
				else {next_data_pc += DELTA;}}

static mem_addr next_gp_item_addr; /* Address of next item accessed off $gp */

static int auto_alignment = 1;	/* Non-zero => align literal to natural bound*/



/* If TO_KERNEL is non-zero, subsequent data will be placed in the
   kernel data segment.  If it is zero, data will go to the user's data
   segment.*/

#ifdef __STDC__
void
user_kernel_data_segment (int to_kernel)
#else
void
user_kernel_data_segment (to_kernel)
int to_kernel;
#endif
{
    in_kernel = to_kernel;
}


#ifdef __STDC__
void
end_of_assembly_file (void)
#else
void
end_of_assembly_file ()
#endif
{
  in_kernel = 0;
  auto_alignment = 1;
}


/* Set the point at which the first datum is stored to be ADDRESS +
   64K.	 The 64K increment allocates an area pointed to by register
   $gp, which is initialized. */

#ifdef __STDC__
void
data_begins_at_point (mem_addr addr)
#else
void
data_begins_at_point (addr)
     mem_addr addr;
#endif
{
  if (bare_machine)
    next_data_pc = addr;
  else
    {
      next_gp_item_addr = addr;
      gp_midpoint = addr + 32*K;
      R[REG_GP] = gp_midpoint;
      next_data_pc = addr + 64 * K;
    }
}


/* Set the point at which the first datum is stored in the kernel's
   data segment. */

#ifdef __STDC__
void
k_data_begins_at_point (mem_addr addr)
#else
void
k_data_begins_at_point (addr)
     mem_addr addr;
#endif
{
    next_k_data_pc = addr;
}


/* Arrange that the next datum is stored on a memory boundary with its
   low ALIGNMENT bits equal to 0.  If argument is 0, disable automatic
   alignment.*/

#ifdef __STDC__
void
align_data (int alignment)
#else
void
align_data (alignment)
     int alignment;
#endif
{
  if (alignment == 0)
    auto_alignment = 0;
  else if (in_kernel)
    {
      next_k_data_pc =
	(next_k_data_pc + (1 << alignment) - 1) & (-1 << alignment);
      fix_current_label_address (next_k_data_pc);
    }
  else
    {
      next_data_pc = (next_data_pc + (1 << alignment) - 1) & (-1 << alignment);
      fix_current_label_address (next_data_pc);
    }
}


#ifdef __STDC__
void
set_data_alignment (int alignment)
#else
void
set_data_alignment (alignment)
     int alignment;
#endif
{
  if (auto_alignment)
    align_data (alignment);
}


#ifdef __STDC__
void
enable_data_alignment (void)
#else
void
enable_data_alignment ()
#endif
{
  auto_alignment = 1;
}


/* Set the location (in user or kernel data space) for the next datum. */

#ifdef __STDC__
void
set_data_pc (mem_addr addr)
#else
void
set_data_pc (addr)
     mem_addr addr;
#endif
{
  if (in_kernel)
    next_k_data_pc = addr;
  else
    next_data_pc = addr;
}


/* Return the address at which the next datum will be stored.  */

#ifdef __STDC__
mem_addr
current_data_pc (void)
#else
mem_addr
current_data_pc ()
#endif
{
  return (DATA_PC);
}


/* Bump the address at which the next data will be stored by VALUE
   bytes. */

#ifdef __STDC__
void
increment_data_pc (int value)
#else
void
increment_data_pc (value)
     int value;
#endif
{
  BUMP_DATA_PC (value);
}


/* Process a .extern NAME SIZE directive. */

#ifdef __STDC__
void
extern_directive (char *name, int size)
#else
void
extern_directive (name, size)
     char *name;
     int size;
#endif
{
  label *sym = make_label_global (name);

  if (!bare_machine
      && size > 0 && size <= SMALL_DATA_SEG_MAX_SIZE
      && next_gp_item_addr + size < gp_midpoint + 32*K)
    {
      sym->gp_flag = 1;
      sym->addr = next_gp_item_addr;
      next_gp_item_addr += size;
    }
}


/* Process a .lcomm NAME SIZE directive. */

#ifdef __STDC__
void
lcomm_directive (char *name, int size)
#else
void
lcomm_directive (name, size)
     char *name;
     int size;
#endif
{
  label *sym = lookup_label (name);

  if (!bare_machine
      && size > 0 && size <= SMALL_DATA_SEG_MAX_SIZE
      && next_gp_item_addr + size < gp_midpoint + 32*K)
    {
      sym->gp_flag = 1;
      sym->addr = next_gp_item_addr;
      next_gp_item_addr += size;
    }
  /* Don't need to initialize since memory starts with 0's */
}


/* Process a .ascii STRING or .asciiz STRING directive. */

#ifdef __STDC__
void
store_string (char *string, int length, int null_terminate)
#else
void
store_string (string, length, null_terminate)
     char *string;
     int length;
     int null_terminate;
#endif
{
  for ( ; length > 0; string ++, length --) {
    SET_MEM_BYTE (DATA_PC, *string);
    BUMP_DATA_PC(1);
  }
  if (null_terminate)
    {
      SET_MEM_BYTE (DATA_PC, 0);
      BUMP_DATA_PC(1);
    }
}


/* Process a .byte EXPR directive. */

#ifdef __STDC__
void
store_byte (int value)
#else
void
store_byte (value)
     int value;
#endif
{
  SET_MEM_BYTE (DATA_PC, value);
  BUMP_DATA_PC (1);
}


/* Process a .half EXPR directive. */

#ifdef __STDC__
void
store_half (int value)
#else
void
store_half (value)
     int value;
#endif
{
  if (DATA_PC & 0x1)
    {
#ifdef BIGENDIAN
      store_byte ((value >> 8) & 0xff);
      store_byte (value & 0xff);
#else
      store_byte (value & 0xff);
      store_byte ((value >> 8) & 0xff);
#endif
    }
  else
    {
      SET_MEM_HALF (DATA_PC, value);
      BUMP_DATA_PC (BYTES_PER_WORD / 2);
    }
}


/* Process a .word EXPR directive. */

#ifdef __STDC__
void
store_word (int value)
#else
void
store_word (value)
     int value;
#endif
{
  if (DATA_PC & 0x3)
    {
#ifdef BIGENDIAN
      store_half ((value >> 16) & 0xffff);
      store_half (value & 0xffff);
#else
      store_half (value & 0xffff);
      store_half ((value >> 16) & 0xffff);
#endif
    }
  else
    {
      SET_MEM_WORD (DATA_PC, value);
      BUMP_DATA_PC (BYTES_PER_WORD);
    }
}


/* Process a .double EXPR directive. */

#ifdef __STDC__
void
store_double (double *value)
#else
void
store_double (value)
     double *value;
#endif
{
  if (DATA_PC & 0x7)
    {
      store_word (* ((mem_word *) value));
      store_word (* (((mem_word *) value) + 1));
    }
  else
    {
      SET_MEM_WORD (DATA_PC, * ((mem_word *) value));
      BUMP_DATA_PC (BYTES_PER_WORD);
      SET_MEM_WORD (DATA_PC, * (((mem_word *) value) + 1));
      BUMP_DATA_PC (BYTES_PER_WORD);
    }
}


/* Process a .float EXPR directive. */

#ifdef __STDC__
void
store_float (double *value)
#else
void
store_float (value)
     double *value;
#endif
{
  float val = (float)*value;
  float *vp = &val;

  if (DATA_PC & 0x3)
    {
      store_half (*(mem_word *) vp & 0xffff);
      store_half ((*(mem_word *) vp >> 16) & 0xffff);
    }
  else
    {
      SET_MEM_WORD (DATA_PC, *((mem_word *) vp));
      BUMP_DATA_PC (BYTES_PER_WORD);
    }
}
