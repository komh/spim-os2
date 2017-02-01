/* SPIM S20 MIPS simulator.
   Definitions for the SPIM S20.

   Copyright (C) 1990-2000 by James Larus (larus@cs.wisc.edu).
   ALL RIGHTS RESERVED.
   Changes for DOS and Windows versions by David A. Carley (dac@cs.wisc.edu)

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


/* $Header: /Software/SPIM/src/spim.h 10    2/01/01 9:34p Larus $
*/


#ifndef NULL
#define NULL 0
#endif


/* Type declarations for portability.  They work for DEC's Alpha (64 bits)
   and 32 bit machines */

typedef int int32;
typedef unsigned int  uint32;
typedef union {int i; void* p;} intptr_union;


#define streq(s1, s2) !strcmp(s1, s2)


/* Round V to next greatest B boundary */

#define ROUND_UP(V, B) (((int) V + (B-1)) & ~(B-1))
#define ROUND_DOWN(V, B) (((int) V) & ~(B-1))

/* Sign-extend an int16 to an int32 */

#define SIGN_EX(X) (((X) & 0x8000) ? ((X) | 0xffff0000) : (X))


#ifdef MIN			/* Some systems define these in system includes */
#undef MIN
#endif
#ifdef MAX
#undef MAX
#endif

#define MIN(A, B) ((A) < (B) ? (A) : (B))

#define MAX(A, B) ((A) > (B) ? (A) : (B))


#define K 1024


/* Useful and pervasive declarations: */

#ifdef NO_MEM_FUNCTIONS
#define memcpy(T, F, S) bcopy((void*)F, (void*)T, S)
#define memclr(B, S) bzero(B, S)
#define memcmp(S1, S2, N) bcmp(S1, S2, N)
#else
#include <memory.h>
#define memclr(B, S) memset((void*)B, 0, S)
#endif

#ifdef __STDC__
#include <stdlib.h>
#include <string.h>
#define QSORT_FUNC int(*)(const void *, const void *)
#else
double atof ();
int atoi ();
int free ();
char *malloc ();
int strcmp ();
char *strcpy ();
char *strncpy ();
#define QSORT_FUNC int(*)()
#endif



/* Type of a memory address.  Must be a 32-bit quantity to match MIPS.  */

typedef uint32 mem_addr;


#define BYTES_PER_WORD 4	/* On the MIPS processor */


/* Sizes of memory segments. */

/* Initial size of text segment. */

#ifndef TEXT_SIZE
#define TEXT_SIZE	(256*K)	/* 1/4 MB */
#endif

/* Initial size of k_text segment. */

#ifndef K_TEXT_SIZE
#define K_TEXT_SIZE	(64*K)	/* 64 KB */
#endif

/* The data segment must be larger than 64K since we immediate grab
   64K for the small data segment pointed to by $gp. The data segment is
   expanded by an sbrk system call. */

/* Initial size of data segment. */

#ifndef DATA_SIZE
#define DATA_SIZE	(256*K)	/* 1/4 MB */
#endif

/* Maximum size of data segment. */

#ifndef DATA_LIMIT
#define DATA_LIMIT	(K*K)	/* 1 MB */
#endif

/* Initial size of k_data segment. */

#ifndef K_DATA_SIZE
#define K_DATA_SIZE	(64*K)	/* 64 KB */
#endif

/* Maximum size of k_data segment. */

#ifndef K_DATA_LIMIT
#define K_DATA_LIMIT	(K*K)	/* 1 MB */
#endif

/* The stack grows down automatically. */

/* Initial size of stack segment. */

#ifndef STACK_SIZE
#define STACK_SIZE	(64*K)	/* 64 KB */
#endif

/* Maximum size of stack segment. */

#ifndef STACK_LIMIT
#define STACK_LIMIT	(256*K)	/* 1 MB */
#endif


/* Name of the function to invoke at start up */

#define DEFAULT_RUN_LOCATION "__start"


/* Name of the symbol marking the end of the trap handler */

#define END_OF_TRAP_HANDLER_SYMBOL "__eoth"


/* Default number of instructions to execute. */

#define DEFAULT_RUN_STEPS 2147483647


/* Address to branch to when exception occurs */

#define EXCEPTION_ADDR 0x80000080


/* Maximum size of object stored in the small data segment pointed to by
   $gp */

#define SMALL_DATA_SEG_MAX_SIZE 8

#ifndef DIRECT_MAPPED
#define DIRECT_MAPPED 0
#define TWO_WAY_SET 1
#endif


/* Interval (in instructions) at which memory-mapped IO registers are
   checked and updated.*/

#define IO_INTERVAL 100


/* Number of instructions that a character remains in receiver buffer
   if another character is available. (Should be multiple of IO_INTERVAL.) */

#define RECV_LATENCY (10*IO_INTERVAL)


/* Number of instructions that it takes to write a character. (Should
   be multiple of IO_INTERVAL.)*/

#define TRANS_LATENCY (IO_INTERVAL)



/* Triple containing a string and two integers.	 Used in tables
   mapping from a name to values. */

typedef struct strint
{
  char *name;
  int value1;
  int value2;
} inst_info;




/* A port is either a Unix file descriptor (an int) or a FILE* pointer. */

#include <stdio.h>

typedef union {int i; FILE* f;} port;

/* Exported functions (from spim.c or xspim.c): */
#ifdef __STDC__

int console_input_available (void);
void control_c_seen (int);
void error (char *fmt, ...);
void fatal_error (char *fmt, ...);
char get_console_char (void);
void put_console_char (char c);
void read_input (char *str, int n);
int* run_error (char *fmt, ...);
void write_output (port, char *fmt, ...);
#else
int console_input_available ();
void control_c_seen ();
void error ();
void fatal_error ();
char get_console_char ();
void put_console_char ();
void read_input ();
int* run_error ();
void write_output ();
#endif


/* Exported variables: */

extern int bare_machine;	/* Non-zero => simulate bare machine */
extern int accept_pseudo_insts;	/* Non-Zero => parse pseudo instructions  */
extern int delayed_branches;	/* Non-zero => simulate delayed branches */
extern int delayed_loads;	/* Non-zero => simulate delayed loads */
extern int quiet;		/* Non-zero => no warning messages */
extern int source_file;		/* Non-zero => program is source, not binary */
extern char *trap_file;		/* Path of file containing trap handler */
extern int force_break;		/* Non-zero => stop interpreter loop  */
extern int parser_error_occurred; /* Non-zero => parse resulted in error */


/* Actual type of structure pointed to depends on X/terminal interface */
extern port message_out, console_out, console_in;

extern int mapped_io;		/* Non-zero => activate memory-mapped IO */

extern mem_addr program_starting_address;

extern int initial_text_size;

extern int initial_data_size;

extern mem_addr initial_data_limit;

extern int initial_stack_size;

extern mem_addr initial_stack_limit;

extern int initial_k_text_size;

extern int initial_k_data_size;

extern mem_addr initial_k_data_limit;
