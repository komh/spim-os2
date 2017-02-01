/* SPIM S20 MIPS simulator.
   Interface to lexical scanner.

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


/* $Header: /Software/SPIM/src/scanner.h 4     12/24/00 1:37p Larus $
*/


/* Exported functions (besides yylex): */

#ifdef __STDC__
void initialize_scanner (FILE *in_file);
void print_erroneous_line (void);
void scanner_start_line (void);
int register_name_to_number (char *name);
char *source_line (void);
int yylex ();
#else
void initialize_scanner ();
void print_erroneous_line ();
void scanner_start_line ();
int register_name_to_number ();
char *source_line ();
int yylex ();
#endif

/* Exported Variables: */

/* This flag tells the scanner to treat the next sequence of letters
   etc as an identifier and not look it up as an opcode. It permits us
   to use opcodes as symbols in most places.  However, because of the
   LALR(1) lookahead, it does not work for labels. */

extern int only_id;

typedef intptr_union yylval_t;
#define YYSTYPE yylval_t
extern YYSTYPE yylval;		/* Value of token from YYLEX */

extern int line_no;		/* Line number in input file*/

extern int y_str_length;	/* Length of Y_STR */
