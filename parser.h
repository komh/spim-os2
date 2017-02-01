/* SPIM S20 MIPS simulator.
   Interface to parser for instructions and assembler directives.

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


/* $Header: /Software/SPIM/src/parser.h 6     12/24/00 1:37p Larus $
*/


/* Exported functions: */

#ifdef __STDC__
void fix_current_label_address (mem_addr new_addr);
int imm_op_to_op (int opcode);
void initialize_parser (char *file_name);
int op_to_imm_op (int opcode);
void yyerror (char *s);
int yyparse ();
#else
void fix_current_label_address ();
int imm_op_to_op ();
void initialize_parser ();
int op_to_imm_op ();
void yyerror ();
int yyparse ();
#endif


/* Exported Variables: */

extern int data_dir;		/* Non-zero means item in data segment */

extern int text_dir;		/* Non-zero means item in text segment */

extern int parse_error_occurred;  /* Non-zero => parse resulted in error */
