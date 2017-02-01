/* SPIM S20 MIPS simulator.
   Parser for instructions and assembler directives.

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


/* $Header: $
*/



%start LINE

%token Y_EOF

%token Y_NL
%token Y_INT
%token Y_ID
%token Y_REG
%token Y_FP_REG
%token Y_STR
%token Y_FP

/* MIPS instructions op codes: */

%token Y_ABS_D_OP
%token Y_ABS_S_OP
%token Y_ADDIU_OP
%token Y_ADDI_OP
%token Y_ADDU_OP
%token Y_ADD_D_OP
%token Y_ADD_OP
%token Y_ADD_S_OP
%token Y_ANDI_OP
%token Y_AND_OP
%token Y_BC0F_OP
%token Y_BC0T_OP
%token Y_BC1F_OP
%token Y_BC1T_OP
%token Y_BC2F_OP
%token Y_BC2T_OP
%token Y_BC3F_OP
%token Y_BC3T_OP
%token Y_BEQ_OP
%token Y_BGEZAL_OP
%token Y_BGEZ_OP
%token Y_BGTZ_OP
%token Y_BLEZ_OP
%token Y_BLTZAL_OP
%token Y_BLTZ_OP
%token Y_BNE_OP
%token Y_BREAK_OP
%token Y_CFC0_OP
%token Y_CFC1_OP
%token Y_CFC2_OP
%token Y_CFC3_OP
%token Y_COP0_OP
%token Y_COP1_OP
%token Y_COP2_OP
%token Y_COP3_OP
%token Y_CTC0_OP
%token Y_CTC1_OP
%token Y_CTC2_OP
%token Y_CTC3_OP
%token Y_CVT_D_S_OP
%token Y_CVT_D_W_OP
%token Y_CVT_S_D_OP
%token Y_CVT_S_W_OP
%token Y_CVT_W_D_OP
%token Y_CVT_W_S_OP
%token Y_C_EQ_D_OP
%token Y_C_EQ_S_OP
%token Y_C_F_D_OP
%token Y_C_F_S_OP
%token Y_C_LE_D_OP
%token Y_C_LE_S_OP
%token Y_C_LT_D_OP
%token Y_C_LT_S_OP
%token Y_C_NGE_D_OP
%token Y_C_NGE_S_OP
%token Y_C_NGLE_D_OP
%token Y_C_NGLE_S_OP
%token Y_C_NGL_D_OP
%token Y_C_NGL_S_OP
%token Y_C_NGT_D_OP
%token Y_C_NGT_S_OP
%token Y_C_OLT_D_OP
%token Y_C_OLT_S_OP
%token Y_C_OLE_D_OP
%token Y_C_OLE_S_OP
%token Y_C_SEQ_D_OP
%token Y_C_SEQ_S_OP
%token Y_C_SF_D_OP
%token Y_C_SF_S_OP
%token Y_C_UEQ_D_OP
%token Y_C_UEQ_S_OP
%token Y_C_ULT_D_OP
%token Y_C_ULT_S_OP
%token Y_C_ULE_D_OP
%token Y_C_ULE_S_OP
%token Y_C_UN_D_OP
%token Y_C_UN_S_OP
%token Y_DIVU_OP
%token Y_DIV_D_OP
%token Y_DIV_OP
%token Y_DIV_S_OP
%token Y_JALR_OP
%token Y_JAL_OP
%token Y_JR_OP
%token Y_J_OP
%token Y_LBU_OP
%token Y_LB_OP
%token Y_LHU_OP
%token Y_LH_OP
%token Y_LUI_OP
%token Y_LWC0_OP
%token Y_LWC1_OP
%token Y_LWC2_OP
%token Y_LWC3_OP
%token Y_LWL_OP
%token Y_LWR_OP
%token Y_LW_OP
%token Y_MFC0_OP
%token Y_MFC1_OP
%token Y_MFC2_OP
%token Y_MFC3_OP
%token Y_MFHI_OP
%token Y_MFLO_OP
%token Y_MOV_D_OP
%token Y_MOV_S_OP
%token Y_MTC0_OP
%token Y_MTC1_OP
%token Y_MTC2_OP
%token Y_MTC3_OP
%token Y_MTHI_OP
%token Y_MTLO_OP
%token Y_MULTU_OP
%token Y_MULT_OP
%token Y_MUL_D_OP
%token Y_MUL_S_OP
%token Y_NEG_D_OP
%token Y_NEG_S_OP
%token Y_NOR_OP
%token Y_ORI_OP
%token Y_OR_OP
%token Y_PFW_OP
%token Y_RFE_OP
%token Y_SB_OP
%token Y_SH_OP
%token Y_SLLV_OP
%token Y_SLL_OP
%token Y_SLTIU_OP
%token Y_SLTI_OP
%token Y_SLTU_OP
%token Y_SLT_OP
%token Y_SRAV_OP
%token Y_SRA_OP
%token Y_SRLV_OP
%token Y_SRL_OP
%token Y_SUBU_OP
%token Y_SUB_D_OP
%token Y_SUB_OP
%token Y_SUB_S_OP
%token Y_SWC0_OP
%token Y_SWC1_OP
%token Y_SWC2_OP
%token Y_SWC3_OP
%token Y_SWL_OP
%token Y_SWR_OP
%token Y_SW_OP
%token Y_SYSCALL_OP
%token Y_TLBP_OP
%token Y_TLBR_OP
%token Y_TLBWI_OP
%token Y_TLBWR_OP
%token Y_XORI_OP
%token Y_XOR_OP


/* Assembler pseudo operations op codes: */

%token Y_ABS_POP
%token Y_BAL_POP
%token Y_BEQZ_POP
%token Y_BGEU_POP
%token Y_BGE_POP
%token Y_BGTU_POP
%token Y_BGT_POP
%token Y_BLEU_POP
%token Y_BLE_POP
%token Y_BLTU_POP
%token Y_BLT_POP
%token Y_BNEZ_POP
%token Y_B_POP
%token Y_LA_POP
%token Y_LD_POP
%token Y_LI_POP
%token Y_LI_D_POP
%token Y_LI_S_POP
%token Y_L_D_POP
%token Y_L_S_POP
%token Y_MFC1_D_POP
%token Y_MTC1_D_POP
%token Y_MOVE_POP
%token Y_MULOU_POP
%token Y_MULO_POP
%token Y_MUL_POP
%token Y_NEGU_POP
%token Y_NEG_POP
%token Y_NOP_POP
%token Y_NOT_POP
%token Y_REMU_POP
%token Y_REM_POP
%token Y_ROL_POP
%token Y_ROR_POP
%token Y_SD_POP
%token Y_SEQ_POP
%token Y_SGEU_POP
%token Y_SGE_POP
%token Y_SGTU_POP
%token Y_SGT_POP
%token Y_SLEU_POP
%token Y_SLE_POP
%token Y_SNE_POP
%token Y_S_D_POP
%token Y_S_S_POP
%token Y_ULHU_POP
%token Y_ULH_POP
%token Y_ULW_POP
%token Y_USH_POP
%token Y_USW_POP

/* Assembler directives: */

%token Y_ALIAS_DIR
%token Y_ALIGN_DIR
%token Y_ASCII_DIR
%token Y_ASCIIZ_DIR
%token Y_ASM0_DIR
%token Y_BGNB_DIR
%token Y_BYTE_DIR
%token Y_COMM_DIR
%token Y_DATA_DIR
%token Y_DOUBLE_DIR
%token Y_ENDB_DIR
%token Y_ENDR_DIR
%token Y_END_DIR
%token Y_ENT_DIR
%token Y_ERR_DIR
%token Y_EXTERN_DIR
%token Y_FILE_DIR
%token Y_FLOAT_DIR
%token Y_FMASK_DIR
%token Y_FRAME_DIR
%token Y_GLOBAL_DIR
%token Y_HALF_DIR
%token Y_K_TEXT_DIR
%token Y_K_DATA_DIR
%token Y_LABEL_DIR
%token Y_LCOMM_DIR
%token Y_LIVEREG_DIR
%token Y_LOC_DIR
%token Y_MASK_DIR
%token Y_NOALIAS_DIR
%token Y_OPTIONS_DIR
%token Y_RDATA_DIR
%token Y_REPEAT_DIR
%token Y_SDATA_DIR
%token Y_SET_DIR
%token Y_SPACE_DIR
%token Y_STRUCT_DIR
%token Y_TEXT_DIR
%token Y_VERSTAMP_DIR
%token Y_VREG_DIR
%token Y_WORD_DIR

%{
#include <stdio.h>

#include "spim.h"
#include "spim-utils.h"
#include "inst.h"
#include "mem.h"
#include "reg.h"
#include "sym-tbl.h"
#include "data.h"
#include "scanner.h"
#include "parser.h"


/* return (0) */
#define LINE_PARSE_DONE YYACCEPT

/* return (1) */
#define FILE_PARSE_DONE YYABORT

typedef struct ll
{
  label *head;
  struct ll *tail;
} label_list;


/* Exported Variables: */

int data_dir;			/* Non-zero means item in data segment */

int text_dir;			/* Non-zero means item in text segment */

int parse_error_occurred;  /* Non-zero => parse resulted in error */


/* Local functions: */

#ifdef __STDC__
static imm_expr *branch_offset (int n_inst);
static void check_imm_range (imm_expr*, int32, int32);
static void check_uimm_range (imm_expr*, uint32, uint32);
static void clear_labels (void);
static label_list *cons_label (label *head, label_list *tail);
static void div_inst (int op, int rd, int rs, int rt, int const_divisor);
static void mult_inst (int op, int rd, int rs, int rt);
static void nop_inst (void);
static void set_eq_inst (int op, int rd, int rs, int rt);
static void set_ge_inst (int op, int rd, int rs, int rt);
static void set_gt_inst (int op, int rd, int rs, int rt);
static void set_le_inst (int op, int rd, int rs, int rt);
static void store_word_data (int value);
static void trap_inst (void);
static void yywarn (char*);
#else
static imm_expr *branch_offset ();
static void check_imm_range();
static void check_uimm_range();
static void clear_labels ();
static label_list *cons_label ();
static void div_inst ();
static void mult_inst ();
static void nop_inst ();
static void set_eq_inst ();
static void set_ge_inst ();
static void set_gt_inst ();
static void set_le_inst ();
static void store_word_data ();
static void trap_inst ();
static void yywarn ();
#endif


/* Local variables: */

static int null_term;		/* Non-zero means string terminate by \0 */

static void (*store_op) ();	/* Function to store items in an EXPR_LST */

static label_list *this_line_labels = NULL; /* List of label for curent line */

static int noat_flag = 0;	/* Non-zero means program can use $1 */

static char *input_file_name;	/* Name of file being parsed */

%}



%%

LINE:		{parse_error_occurred = 0; scanner_start_line (); } LBL_CMD ;

LBL_CMD:	OPT_LBL CMD
	|	CMD
	;


OPT_LBL: ID ':' {
			   this_line_labels =
			     cons_label (record_label ((char*)$1.p,
						       text_dir
						       ? current_text_pc ()
						       : current_data_pc (),
						       0),
					 this_line_labels);
				if ($1.p) free($1.p);
			 }

	|	ID '=' Y_INT
		{
		  label *l = record_label ((char*)$1.p, (mem_addr)$3.i, 1);
		  if ($1.p) free($1.p);

		  l->const_flag = 1;
		  clear_labels ();
		}
	;


CMD:	ASM_CODE
		{
		  clear_labels ();
		}
		TERM

	|	ASM_DIRECTIVE
		{
		  clear_labels ();
		}
		TERM

	|	TERM
    ;


TERM:	Y_NL
		{
			LINE_PARSE_DONE;
		}

	|	Y_EOF
		{
		  clear_labels ();
		  FILE_PARSE_DONE;
		}
	;



ASM_CODE:	LOAD_OP		DEST_REG	ADDRESS
		{
		  i_type_inst ($1.i == Y_LD_POP ? Y_LW_OP : $1.i,
			       $2.i,
			       addr_expr_reg ((addr_expr *)$3.p),
			       addr_expr_imm ((addr_expr *)$3.p));
		  if ($1.i == Y_LD_POP)
		    i_type_inst_free (Y_LW_OP,
				      $2.i + 1,
				      addr_expr_reg ((addr_expr *)$3.p),
				      incr_expr_offset (addr_expr_imm ((addr_expr *)$3.p),
							4));
		  free (((addr_expr *)$3.p)->imm);
		  free ((addr_expr *)$3.p);
		}

	|	LOAD_COP	COP_REG		ADDRESS
		{
		  i_type_inst ($1.i, $2.i, addr_expr_reg ((addr_expr *)$3.p),
			       addr_expr_imm ((addr_expr *)$3.p));
		  free (((addr_expr *)$3.p)->imm);
		  free ((addr_expr *)$3.p);
		}

	|	LOAD_IMM_OP	DEST_REG	UIMM16
		{
		  i_type_inst_free ($1.i, $2.i, 0, (imm_expr *)$3.p);
		}


	|	Y_LA_POP	DEST_REG	ADDRESS
		{
		  if (addr_expr_reg ((addr_expr *)$3.p))
		    i_type_inst (Y_ADDI_OP, $2.i,
				 addr_expr_reg ((addr_expr *)$3.p),
				 addr_expr_imm ((addr_expr *)$3.p));
		  else
		    i_type_inst (Y_ORI_OP, $2.i, 0,
				 addr_expr_imm ((addr_expr *)$3.p));
		  free (((addr_expr *)$3.p)->imm);
		  free ((addr_expr *)$3.p);
		}


	|	Y_LI_POP	DEST_REG	IMM32
		{
		  i_type_inst_free (Y_ORI_OP, $2.i, 0, (imm_expr *)$3.p);
		}


	|	Y_LI_D_POP	F_DEST		Y_FP
		{
		  int *x = (int *) $3.p;

		  i_type_inst (Y_ORI_OP, 1, 0, const_imm_expr (*x));
		  r_type_inst (Y_MTC1_OP, $2.i, 0, 1);
		  i_type_inst (Y_ORI_OP, 1, 0, const_imm_expr (*(x+1)));
		  r_type_inst (Y_MTC1_OP, $2.i + 1, 0, 1);
		}


	|	Y_LI_S_POP	F_DEST		Y_FP
		{
		  float x = (float) *((double *) $3.p);
		  int *y = (int *) &x;

		  i_type_inst (Y_ORI_OP, 1, 0, const_imm_expr (*y));
		  r_type_inst (Y_MTC1_OP, $2.i, 0, 1);
		}


	|	Y_ULW_POP	DEST_REG	ADDRESS
		{
#ifdef BIGENDIAN
		  i_type_inst (Y_LWL_OP, $2.i,
			       addr_expr_reg ((addr_expr *)$3.p),
			       addr_expr_imm ((addr_expr *)$3.p));
		  i_type_inst_free (Y_LWR_OP, $2.i,
				    addr_expr_reg ((addr_expr *)$3.p),
				    incr_expr_offset (addr_expr_imm ((addr_expr *)$3.p),
						      3));
#else
		  i_type_inst_free (Y_LWL_OP, $2.i,
				    addr_expr_reg ((addr_expr *)$3.p),
				    incr_expr_offset (addr_expr_imm ((addr_expr *)$3.p),
						      3));
		  i_type_inst (Y_LWR_OP, $2.i,
			       addr_expr_reg ((addr_expr *)$3.p),
			       addr_expr_imm ((addr_expr *)$3.p));
#endif
		  free (((addr_expr *)$3.p)->imm);
		  free ((addr_expr *)$3.p);
		}


	|	ULOADH_POP	DEST_REG	ADDRESS
		{
#ifdef BIGENDIAN
		  i_type_inst (($1.i == Y_ULH_POP ? Y_LB_OP : Y_LBU_OP),
			       $2.i,
			       addr_expr_reg ((addr_expr *)$3.p),
			       addr_expr_imm ((addr_expr *)$3.p));
		  i_type_inst_free (Y_LBU_OP, 1,
				    addr_expr_reg ((addr_expr *)$3.p),
				    incr_expr_offset (addr_expr_imm ((addr_expr *)$3.p),
						      1));
#else
		  i_type_inst_free (($1.i == Y_ULH_POP ? Y_LB_OP : Y_LBU_OP),
				    $2.i,
				    addr_expr_reg ((addr_expr *)$3.p),
				    incr_expr_offset (addr_expr_imm ((addr_expr *)$3.p),
						      1));
		  i_type_inst (Y_LBU_OP, 1,
			       addr_expr_reg ((addr_expr *)$3.p),
			       addr_expr_imm ((addr_expr *)$3.p));
#endif
		  r_sh_type_inst (Y_SLL_OP, $2.i, $2.i, 8);
		  r_type_inst (Y_OR_OP, $2.i, $2.i, 1);
		  free (((addr_expr *)$3.p)->imm);
		  free ((addr_expr *)$3.p);
		}


	|	LOADF_OP	F_DEST		ADDRESS
		{
		  i_type_inst (Y_LWC1_OP, $2.i,
			       addr_expr_reg ((addr_expr *)$3.p),
			       addr_expr_imm ((addr_expr *)$3.p));
		  if ($1.i == Y_L_D_POP)
		    i_type_inst_free (Y_LWC1_OP, $2.i + 1,
				      addr_expr_reg ((addr_expr *)$3.p),
				      incr_expr_offset (addr_expr_imm ((addr_expr *)$3.p),
							4));
		  free (((addr_expr *)$3.p)->imm);
		  free ((addr_expr *)$3.p);
		}


	|	STORE_OP	SOURCE		ADDRESS
		{
		  i_type_inst ($1.i == Y_SD_POP ? Y_SW_OP : $1.i,
			       $2.i,
			       addr_expr_reg ((addr_expr *)$3.p),
			       addr_expr_imm ((addr_expr *)$3.p));
		  if ($1.i == Y_SD_POP)
		    i_type_inst_free (Y_SW_OP, $2.i + 1,
				      addr_expr_reg ((addr_expr *)$3.p),
				      incr_expr_offset (addr_expr_imm ((addr_expr *)$3.p),
							4));
		  free (((addr_expr *)$3.p)->imm);
		  free ((addr_expr *)$3.p);
		}


	|	STORE_COP	COP_REG		ADDRESS
		{
		  i_type_inst ($1.i, $2.i,
			       addr_expr_reg ((addr_expr *)$3.p),
			       addr_expr_imm ((addr_expr *)$3.p));
		  free (((addr_expr *)$3.p)->imm);
		  free ((addr_expr *)$3.p);
		}


	|	Y_USW_POP	SOURCE		ADDRESS
		{
#ifdef BIGENDIAN
		  i_type_inst (Y_SWL_OP, $2.i,
			       addr_expr_reg ((addr_expr *)$3.p),
			       addr_expr_imm ((addr_expr *)$3.p));
		  i_type_inst_free (Y_SWR_OP, $2.i,
				    addr_expr_reg ((addr_expr *)$3.p),
				    incr_expr_offset (addr_expr_imm ((addr_expr *)$3.p),
						      3));
#else
		  i_type_inst_free (Y_SWL_OP, $2.i,
				    addr_expr_reg ((addr_expr *)$3.p),
				    incr_expr_offset (addr_expr_imm ((addr_expr *)$3.p),
						      3));
		  i_type_inst (Y_SWR_OP, $2.i,
			       addr_expr_reg ((addr_expr *)$3.p),
			       addr_expr_imm ((addr_expr *)$3.p));
#endif
		  free (((addr_expr *)$3.p)->imm);
		  free ((addr_expr *)$3.p);
		}


	|	Y_USH_POP	SOURCE		ADDRESS
		{
		  i_type_inst (Y_SB_OP, $2.i,
			       addr_expr_reg ((addr_expr *)$3.p),
			       addr_expr_imm ((addr_expr *)$3.p));

		  /* ROL SRC, SRC, 8 */
		  r_sh_type_inst (Y_SLL_OP, 1, $2.i, 24);
		  r_sh_type_inst (Y_SRL_OP, $2.i, $2.i, 8);
		  r_type_inst (Y_OR_OP, $2.i, $2.i, 1);

		  i_type_inst_free (Y_SB_OP, $2.i,
				    addr_expr_reg ((addr_expr *)$3.p),
				    incr_expr_offset (addr_expr_imm ((addr_expr *)$3.p),
						      1));
		  /* ROR SRC, SRC, 8 */
		  r_sh_type_inst (Y_SRL_OP, 1, $2.i, 24);
		  r_sh_type_inst (Y_SLL_OP, $2.i, $2.i, 8);
		  r_type_inst (Y_OR_OP, $2.i, $2.i, 1);

		  free (((addr_expr *)$3.p)->imm);
		  free ((addr_expr *)$3.p);
		}


	|	STOREF_OP	F_SRC1		ADDRESS
		{
		  i_type_inst (Y_SWC1_OP, $2.i,
			       addr_expr_reg ((addr_expr *)$3.p),
			       addr_expr_imm ((addr_expr *)$3.p));
		  if ($1.i == Y_S_D_POP)
		    i_type_inst_free (Y_SWC1_OP, $2.i + 1,
				      addr_expr_reg ((addr_expr *)$3.p),
				      incr_expr_offset (addr_expr_imm ((addr_expr *)$3.p),
							4));
		  free (((addr_expr *)$3.p)->imm);
		  free ((addr_expr *)$3.p);
		}


	|	SYS_OP
		{
		  r_type_inst ($1.i, 0, 0, 0);
		}


	|	Y_BREAK_OP		Y_INT
		{
		  if ($2.i == 1)
		    yyerror ("Breakpoint 1 is reserved for debugger");
		  r_type_inst ($1.i, $2.i, 0, 0);
		}


	|	Y_NOP_POP
		{
		  nop_inst ();
		}


	|	Y_ABS_POP		DEST_REG	SRC1
		{
		  if ($2.i != $3.i)
		    r_type_inst (Y_ADDU_OP, $2.i, 0, $3.i);

		  i_type_inst_free (Y_BGEZ_OP, 0, $3.i, branch_offset (2));
		  r_type_inst (Y_SUB_OP, $2.i, 0, $3.i);
		}


	|	Y_NEG_POP		DEST_REG	SRC1
		{
		  r_type_inst (Y_SUB_OP, $2.i, 0, $3.i);
		}


	|	Y_NEGU_POP		DEST_REG	SRC1
		{
		  r_type_inst (Y_SUBU_OP, $2.i, 0, $3.i);
		}


	|	Y_NOT_POP		DEST_REG	SRC1
		{
		  r_type_inst (Y_NOR_OP, $2.i, $3.i, 0);
		}


	|	Y_MOVE_POP		DEST_REG	SRC1
		{
		  r_type_inst (Y_ADDU_OP, $2.i, 0, $3.i);
		}


	|	BINARY_OP_I	DEST_REG	SRC1		SRC2
		{
		  r_type_inst ($1.i, $2.i, $3.i, $4.i);
		}


	|	BINARY_OP_I	DEST_REG	SRC1		IMM32
		{
		  i_type_inst_free (op_to_imm_op ($1.i), $2.i, $3.i,
				    (imm_expr *)$4.p);
		}


	|	BINARY_OP_I	DEST_REG	IMM32
		{
		  i_type_inst_free (op_to_imm_op ($1.i), $2.i, $2.i,
				    (imm_expr *)$3.p);
		}


	|	BINARY_OPR_I	DEST_REG	SRC1		SRC2
		{
		  r_type_inst ($1.i, $2.i, $4.i, $3.i);
		}


	|	BINARY_OPR_I	DEST_REG	SRC1		Y_INT
		{
		  r_sh_type_inst (op_to_imm_op ($1.i), $2.i, $3.i, $4.i);
		}


	|	BINARY_OPR_I	DEST_REG	Y_INT
		{
		  r_sh_type_inst (op_to_imm_op ($1.i), $2.i, $2.i, $3.i);
		}


	|	BINARY_IMM_ARITH_OP	DEST_REG	SRC1		IMM16
		{
		  i_type_inst_free ($1.i, $2.i, $3.i, (imm_expr *)$4.p);
		}


	|	BINARY_IMM_ARITH_OP	DEST_REG	IMM16
		{
		  i_type_inst_free ($1.i, $2.i, $2.i, (imm_expr *)$3.p);
		}

	|	BINARY_IMM_LOGICAL_OP	DEST_REG	SRC1		UIMM16
		{
		  i_type_inst_free ($1.i, $2.i, $3.i, (imm_expr *)$4.p);
		}


	|	BINARY_IMM_LOGICAL_OP	DEST_REG	UIMM16
		{
		  i_type_inst_free ($1.i, $2.i, $2.i, (imm_expr *)$3.p);
		}


	|	SHIFT_OP	DEST_REG	SRC1		Y_INT
		{
		  if (($4.i < 0) || (31 < $4.i))
		    yywarn("Shift distance can only be in the range 0..31");
		  r_sh_type_inst ($1.i, $2.i, $3.i, $4.i);
		}


	|	SHIFT_OP	DEST_REG	SRC1		SRC2
		{
		  r_type_inst (imm_op_to_op ($1.i), $2.i, $4.i, $3.i);
		}


	|	BINARY_OP_NOI	DEST_REG	SRC1		SRC2
		{
		  r_type_inst ($1.i, $2.i, $3.i, $4.i);
		}


	|	BINARY_OP_NOI	DEST_REG	SRC1		IMM32
		{
		  if (bare_machine && !accept_pseudo_insts)
		    yyerror ("Immediate form not allowed in bare machine");
		  else
		    {
		      if (!zero_imm ((imm_expr *)$4.p))
			/* Use $at */
			i_type_inst (Y_ORI_OP, 1, 0, (imm_expr *)$4.p);
		      r_type_inst ($1.i,
				   $2.i,
				   $3.i,
				   (zero_imm ((imm_expr *)$4.p) ? 0 : 1));
		    }
		  free ((imm_expr *)$4.p);
		}


	|	BINARY_OP_NOI	DEST_REG	IMM32
		{
		  check_uimm_range ((imm_expr *)$3.p, UIMM_MIN, UIMM_MAX);
		  if (bare_machine && !accept_pseudo_insts)
		    yyerror ("Immediate form not allowed in bare machine");
		  else
		    {
		      if (!zero_imm ((imm_expr *)$3.p))
			/* Use $at */
			i_type_inst (Y_ORI_OP, 1, 0, (imm_expr *)$3.p);
		      r_type_inst ($1.i,
				   $2.i,
				   $2.i,
				   (zero_imm ((imm_expr *)$3.p) ? 0 : 1));
		    }
		  free ((imm_expr *)$3.p);
		}


	|	SUB_OP	DEST_REG	SRC1		SRC2
		{
		  r_type_inst ($1.i, $2.i, $3.i, $4.i);
		}


	|	SUB_OP	DEST_REG	SRC1		IMM32
		{
		  int val = eval_imm_expr ((imm_expr *)$4.p);

		  if (bare_machine && !accept_pseudo_insts)
		    yyerror ("Immediate form not allowed in bare machine");
		  else
		    i_type_inst ($1.i == Y_SUB_OP ? Y_ADDI_OP
				 : $1.i == Y_SUBU_OP ? Y_ADDIU_OP
				 : (fatal_error ("Bad SUB_OP\n"), 0),
				 $2.i,
				 $3.i,
				 make_imm_expr (-val, NULL, 0));
		  free ((imm_expr *)$4.p);
		}


	|	SUB_OP	DEST_REG	IMM32
		{
		  int val = eval_imm_expr ((imm_expr *)$3.p);

		  if (bare_machine && !accept_pseudo_insts)
		    yyerror ("Immediate form not allowed in bare machine");
		  else
		    i_type_inst ($1.i == Y_SUB_OP ? Y_ADDI_OP
				 : $1.i == Y_SUBU_OP ? Y_ADDIU_OP
				 : (fatal_error ("Bad SUB_OP\n"), 0),
				 $2.i,
				 $2.i,
				 make_imm_expr (-val, NULL, 0));
		  free ((imm_expr *)$3.p);
		}


	|	DIV_POP		DEST_REG	SRC1
		{
		  /* The hardware divide operation (ignore 1st arg) */
		  if ($1.i != Y_DIV_OP && $1.i != Y_DIVU_OP)
		    yyerror ("REM requires 3 arguments");
		  else
		    r_type_inst ($1.i, 0, $2.i, $3.i);
		}

	|	DIV_POP		DEST_REG	SRC1		SRC2
		{
		  /* Pseudo divide operations */
		  div_inst ($1.i, $2.i, $3.i, $4.i, 0);
		}

	|	DIV_POP		DEST_REG	SRC1		IMM32
		{
		  if (zero_imm ((imm_expr *)$4.p))
		    yyerror ("Divide by zero");
		  else
		    {
		      /* Use $at */
		      i_type_inst_free (Y_ORI_OP, 1, 0, (imm_expr *)$4.p);
		      div_inst ($1.i, $2.i, $3.i, 1, 1);
		    }
		}


	|	MUL_POP		DEST_REG	SRC1		SRC2
		{
		  mult_inst ($1.i, $2.i, $3.i, $4.i);
		}

	|	MUL_POP		DEST_REG	SRC1		IMM32
		{
		  if (zero_imm ((imm_expr *)$4.p))
		    /* Optimize: n * 0 == 0 */
		    i_type_inst_free (Y_ORI_OP, $2.i, 0, (imm_expr *)$4.p);
		  else
		    {
		      /* Use $at */
		      i_type_inst_free (Y_ORI_OP, 1, 0, (imm_expr *)$4.p);
		      mult_inst ($1.i, $2.i, $3.i, 1);
		    }
		}


	|	MULT_OP		SRC1	SRC2
		{
		  r_type_inst ($1.i, 0, $2.i, $3.i);
		}


	|	Y_ROR_POP	DEST_REG	SRC1		SRC2
		{
		  r_type_inst (Y_SUBU_OP, 1, 0, $4.i);
		  r_type_inst (Y_SLLV_OP, 1, 1, $3.i);
		  r_type_inst (Y_SRLV_OP, $2.i, $4.i, $3.i);
		  r_type_inst (Y_OR_OP, $2.i, $2.i, 1);
		}


	|	Y_ROL_POP	DEST_REG	SRC1		SRC2
		{
		  r_type_inst (Y_SUBU_OP, 1, 0, $4.i);
		  r_type_inst (Y_SRLV_OP, 1, 1, $3.i);
		  r_type_inst (Y_SLLV_OP, $2.i, $4.i, $3.i);
		  r_type_inst (Y_OR_OP, $2.i, $2.i, 1);
		}


	|	Y_ROR_POP	DEST_REG	SRC1		IMM32
		{
		  long dist = eval_imm_expr ((imm_expr *)$4.p);

		  check_imm_range ((imm_expr *)$4.p, 0, 31);
		  r_sh_type_inst (Y_SLL_OP, 1, $3.i, -dist);
		  r_sh_type_inst (Y_SRL_OP, $2.i, $3.i, dist);
		  r_type_inst (Y_OR_OP, $2.i, $2.i, 1);
		  free ((imm_expr *)$4.p);
		}


	|	Y_ROL_POP	DEST_REG	SRC1		IMM32
		{
		  long dist = eval_imm_expr ((imm_expr *)$4.p);

		  check_imm_range ((imm_expr *)$4.p, 0, 31);
		  r_sh_type_inst (Y_SRL_OP, 1, $3.i, -dist);
		  r_sh_type_inst (Y_SLL_OP, $2.i, $3.i, dist);
		  r_type_inst (Y_OR_OP, $2.i, $2.i, 1);
		  free ((imm_expr *)$4.p);
		}



	|	SET_LE_POP	DEST_REG	SRC1		SRC2
		{
		  set_le_inst ($1.i, $2.i, $3.i, $4.i);
		}

	|	SET_LE_POP	DEST_REG	SRC1		IMM32
		{
		  if (!zero_imm ((imm_expr *)$4.p))
		    /* Use $at */
		    i_type_inst (Y_ORI_OP, 1, 0, (imm_expr *)$4.p);
		  set_le_inst ($1.i, $2.i, $3.i,
			       (zero_imm ((imm_expr *)$4.p) ? 0 : 1));
		  free ((imm_expr *)$4.p);
		}


	|	SET_GT_POP	DEST_REG	SRC1		SRC2
		{
		  set_gt_inst ($1.i, $2.i, $3.i, $4.i);
		}

	|	SET_GT_POP	DEST_REG	SRC1		IMM32
		{
		  if (!zero_imm ((imm_expr *)$4.p))
		    /* Use $at */
		    i_type_inst (Y_ORI_OP, 1, 0, (imm_expr *)$4.p);
		  set_gt_inst ($1.i, $2.i, $3.i,
			       (zero_imm ((imm_expr *)$4.p) ? 0 : 1));
		  free ((imm_expr *)$4.p);
		}



	|	SET_GE_POP	DEST_REG	SRC1		SRC2
		{
		  set_ge_inst ($1.i, $2.i, $3.i, $4.i);
		}

	|	SET_GE_POP	DEST_REG	SRC1		IMM32
		{
		  if (!zero_imm ((imm_expr *)$4.p))
		    /* Use $at */
		    i_type_inst (Y_ORI_OP, 1, 0, (imm_expr *)$4.p);
		  set_ge_inst ($1.i, $2.i, $3.i,
			       (zero_imm ((imm_expr *)$4.p) ? 0 : 1));
		  free ((imm_expr *)$4.p);
		}


	|	SET_EQ_POP	DEST_REG	SRC1		SRC2
		{
		  set_eq_inst ($1.i, $2.i, $3.i, $4.i);
		}

	|	SET_EQ_POP	DEST_REG	SRC1		IMM32
		{
		  if (!zero_imm ((imm_expr *)$4.p))
		    /* Use $at */
		    i_type_inst (Y_ORI_OP, 1, 0, (imm_expr *)$4.p);
		  set_eq_inst ($1.i, $2.i, $3.i,
			       (zero_imm ((imm_expr *)$4.p) ? 0 : 1));
		  free ((imm_expr *)$4.p);
		}


	|	NULLARY_BR_OP	LABEL
		{
		  i_type_inst_free ($1.i, 0, 0, (imm_expr *)$2.p);
		}


	|	UNARY_BR_OP	SRC1		LABEL
		{
		  i_type_inst_free ($1.i, 0, $2.i, (imm_expr *)$3.p);
		}


	|	UNARY_BR_POP	SRC1		LABEL
		{
		  i_type_inst_free ($1.i == Y_BEQZ_POP ? Y_BEQ_OP : Y_BNE_OP,
			       0, $2.i, (imm_expr *)$3.p);
		}


	|	BINARY_BR_OP	SRC1		SRC2		LABEL
		{
		  i_type_inst_free ($1.i, $3.i, $2.i, (imm_expr *)$4.p);
		}

	|	BINARY_BR_OP	SRC1		BR_IMM32	LABEL
		{
		  if (bare_machine && !accept_pseudo_insts)
		    yyerror ("Immediate form not allowed in bare machine");
		  else
		    {
		      if (zero_imm ((imm_expr *)$3.p))
			i_type_inst ($1.i, $2.i,
				     (zero_imm ((imm_expr *)$3.p) ? 0 : 1),
				     (imm_expr *)$4.p);
		      else
			{
			  /* Use $at */
			  i_type_inst (Y_ORI_OP, 1, 0, (imm_expr *)$3.p);
			  i_type_inst ($1.i, $2.i,
				       (zero_imm ((imm_expr *)$3.p) ? 0 : 1),
				       (imm_expr *)$4.p);
			}
		    }
		  free ((imm_expr *)$3.p);
		  free ((imm_expr *)$4.p);
		}


	|	BR_GT_POP	SRC1		SRC2		LABEL
		{
		  r_type_inst ($1.i == Y_BGT_POP ? Y_SLT_OP : Y_SLTU_OP,
			       1, $3.i, $2.i); /* Use $at */
		  i_type_inst_free (Y_BNE_OP, 0, 1, (imm_expr *)$4.p);
		}

	|	BR_GT_POP	SRC1		BR_IMM32	LABEL
		{
		  if ($1.i == Y_BGT_POP)
		    {
		      /* Use $at */
		      i_type_inst_free (Y_SLTI_OP, 1, $2.i,
					incr_expr_offset ((imm_expr *)$3.p, 1));
		      i_type_inst (Y_BEQ_OP, 0, 1, (imm_expr *)$4.p);
		    }
		  else
		    {
		      /* Use $at */
		      /* Can't add 1 to immediate since 0xffffffff+1 = 0 < 1 */
		      i_type_inst (Y_ORI_OP, 1, 0, (imm_expr *)$3.p);
		      i_type_inst_free (Y_BEQ_OP, $2.i, 1, branch_offset (3));
		      r_type_inst (Y_SLTU_OP, 1, $2.i, 1);
		      i_type_inst (Y_BEQ_OP, 0, 1, (imm_expr *)$4.p);
		    }
		  free ((imm_expr *)$3.p);
		  free ((imm_expr *)$4.p);
		}


	|	BR_GE_POP	SRC1		SRC2		LABEL
		{
		  r_type_inst ($1.i == Y_BGE_POP ? Y_SLT_OP : Y_SLTU_OP,
			       1, $2.i, $3.i); /* Use $at */
		  i_type_inst_free (Y_BEQ_OP, 0, 1, (imm_expr *)$4.p);
		}

	|	BR_GE_POP	SRC1		BR_IMM32	LABEL
		{
		  i_type_inst ($1.i == Y_BGE_POP ? Y_SLTI_OP : Y_SLTIU_OP,
			       1, $2.i, (imm_expr *)$3.p); /* Use $at */
		  i_type_inst_free (Y_BEQ_OP, 0, 1, (imm_expr *)$4.p);
		  free ((imm_expr *)$3.p);
		}


	|	BR_LT_POP	SRC1		SRC2		LABEL
		{
		  r_type_inst ($1.i == Y_BLT_POP ? Y_SLT_OP : Y_SLTU_OP,
			       1, $2.i, $3.i); /* Use $at */
		  i_type_inst_free (Y_BNE_OP, 0, 1, (imm_expr *)$4.p);
		}

	|	BR_LT_POP	SRC1		BR_IMM32	LABEL
		{
		  i_type_inst ($1.i == Y_BLT_POP ? Y_SLTI_OP : Y_SLTIU_OP,
			       1, $2.i, (imm_expr *)$3.p); /* Use $at */
		  i_type_inst_free (Y_BNE_OP, 0, 1, (imm_expr *)$4.p);
		  free ((imm_expr *)$3.p);
		}


	|	BR_LE_POP	SRC1		SRC2		LABEL
		{
		  r_type_inst ($1.i == Y_BLE_POP ? Y_SLT_OP : Y_SLTU_OP,
			       1, $3.i, $2.i); /* Use $at */
		  i_type_inst_free (Y_BEQ_OP, 0, 1, (imm_expr *)$4.p);
		}

	|	BR_LE_POP	SRC1		BR_IMM32	LABEL
		{
		  if ($1.i == Y_BLE_POP)
		    {
		      /* Use $at */
		      i_type_inst_free (Y_SLTI_OP, 1, $2.i,
					incr_expr_offset ((imm_expr *)$3.p, 1));
		      i_type_inst (Y_BNE_OP, 0, 1, (imm_expr *)$4.p);
		    }
		  else
		    {
		      /* Use $at */
		      /* Can't add 1 to immediate since 0xffffffff+1 = 0 < 1 */
		      i_type_inst (Y_ORI_OP, 1, 0, (imm_expr *)$3.p);
		      i_type_inst (Y_BEQ_OP, $2.i, 1, (imm_expr *)$4.p);
		      r_type_inst (Y_SLTU_OP, 1, $2.i, 1);
		      i_type_inst (Y_BNE_OP, 0, 1, (imm_expr *)$4.p);
		    }
		  free ((imm_expr *)$3.p);
		  free ((imm_expr *)$4.p);
		}


	|	J_OPS		LABEL
		{
		  if (($1.i == Y_J_OP) || ($1.i == Y_JR_OP))
		    j_type_inst (Y_J_OP, (imm_expr *)$2.p);
		  else if (($1.i == Y_JAL_OP) || ($1.i == Y_JALR_OP))
		    j_type_inst (Y_JAL_OP, (imm_expr *)$2.p);
		  free ((imm_expr *)$2.p);
		}


	|	J_OPS		SRC1
		{
		  if (($1.i == Y_J_OP) || ($1.i == Y_JR_OP))
		    r_type_inst (Y_JR_OP, 0, $2.i, 0);
		  else if (($1.i == Y_JAL_OP) || ($1.i == Y_JALR_OP))
		    r_type_inst (Y_JALR_OP, 31, $2.i, 0);
		}


	|	J_OPS		DEST		SRC1
		{
		  if (($1.i == Y_J_OP) || ($1.i == Y_JR_OP))
		    r_type_inst (Y_JR_OP, 0, $3.i, 0);
		  else if (($1.i == Y_JAL_OP) || ($1.i == Y_JALR_OP))
		    r_type_inst (Y_JALR_OP, $2.i, $3.i, 0);
		}


	|	B_OP		LABEL
		{
		  i_type_inst_free (($1.i == Y_BAL_POP ? Y_BGEZAL_OP : Y_BGEZ_OP),
				    0, 0, (imm_expr *)$2.p);
		}



	|	MOVE_COP_OP	COP_REG		COP_REG
		{
		  r_type_inst ($1.i, $2.i, $3.i, 0);
		}


	|	MOV_FROM_HILO_OP	REG
		{
		  r_type_inst ($1.i, $2.i, 0, 0);
		}


	|	MOV_TO_HILO_OP	REG
		{
		  r_type_inst ($1.i, 0, $2.i, 0);
		}


	|	MOV_COP_OP	REG		COP_REG
		{
		  if ($1.i == Y_MFC1_D_POP)
		    {
		      r_type_inst (Y_MFC1_OP, $3.i, 0, $2.i);
		      r_type_inst (Y_MFC1_OP, $3.i + 1, 0, $2.i + 1);
		    }
		  else if ($1.i == Y_MTC1_D_POP)
		    {
		      r_type_inst (Y_MTC1_OP, $3.i, 0, $2.i);
		      r_type_inst (Y_MTC1_OP, $3.i + 1, 0, $2.i + 1);
		    }
		  else
		    r_type_inst ($1.i, $3.i, 0, $2.i);
		}


	|	CTL_COP_OP	COP_REG		COP_REG
		{
		  r_type_inst ($1.i, $3.i, 0, $2.i);
		}


	|	FP_ABS_OP	F_DEST		F_SRC1
		{
		  r_type_inst ($1.i, $2.i, $3.i, 0);
		}


	|	FP_BINARY_OP	F_DEST		F_SRC1		F_SRC2
		{
		  r_type_inst ($1.i, $2.i, $3.i, $4.i);
		}


	|	FP_CONVERT_OP	F_DEST		F_SRC2
		{
		  r_type_inst ($1.i, $2.i, $3.i, 0);
		}


	|	FP_NEG_OP	F_DEST		F_SRC2
		{
		  r_type_inst ($1.i, $2.i, $3.i, 0);
		}


	|	FP_CMP_OP	F_SRC1		F_SRC2
		{
		  r_cond_type_inst ($1.i, $2.i, $3.i);
		}
	;



LOAD_OP:	Y_LB_OP
	|	Y_LBU_OP
	|	Y_LH_OP
	|	Y_LHU_OP
	|	Y_LW_OP
	|	Y_LWL_OP
	|	Y_LWR_OP
	|	Y_LD_POP
	|	Y_PFW_OP
	;

LOAD_COP:	Y_LWC0_OP
	|	Y_LWC2_OP
	|	Y_LWC3_OP
	;

LOAD_IMM_OP:	Y_LUI_OP;


ULOADH_POP:	Y_ULH_POP
	|	Y_ULHU_POP
	;

LOADF_OP:	Y_LWC1_OP
	|	Y_L_S_POP
	|	Y_L_D_POP
	;


STORE_OP:	Y_SB_OP
	|	Y_SH_OP
	|	Y_SW_OP
	|	Y_SWL_OP
	|	Y_SWR_OP
	|	Y_SD_POP
	;

STORE_COP:	Y_SWC0_OP
	|	Y_SWC2_OP
	|	Y_SWC3_OP
	;

STOREF_OP:	Y_SWC1_OP
	|	Y_S_S_POP
	|	Y_S_D_POP
	;


SYS_OP:		Y_RFE_OP
	|	Y_SYSCALL_OP
	;


/* These binary operations have immediate analogues. */

BINARY_OP_I:	Y_ADD_OP
	|	Y_ADDU_OP
	|	Y_AND_OP
	|	Y_XOR_OP
	|	Y_OR_OP
	|	Y_SLT_OP
	|	Y_SLTU_OP
	;

BINARY_OPR_I:	Y_SLLV_OP
	|	Y_SRAV_OP
	|	Y_SRLV_OP
	;

BINARY_IMM_ARITH_OP: Y_ADDI_OP
	|	Y_ADDIU_OP
	|	Y_SLTI_OP
	|	Y_SLTIU_OP
	;

BINARY_IMM_LOGICAL_OP: Y_ANDI_OP
	|	Y_ORI_OP
	|	Y_XORI_OP
	;

SHIFT_OP:	Y_SLL_OP
	|	Y_SRA_OP
	|	Y_SRL_OP
	;

/* These binary operations do not have immediate analogues. */

BINARY_OP_NOI:	Y_NOR_OP ;

SUB_OP:		Y_SUB_OP
	|	Y_SUBU_OP
	;

DIV_POP:	Y_DIV_OP
	|	Y_DIVU_OP
	|	Y_REM_POP
	|	Y_REMU_POP
	;

MUL_POP:	Y_MUL_POP
	|	Y_MULO_POP
	|	Y_MULOU_POP
	;

SET_LE_POP:	Y_SLE_POP
	|	Y_SLEU_POP
	;

SET_GT_POP:	Y_SGT_POP
	|	Y_SGTU_POP
	;

SET_GE_POP:	Y_SGE_POP
	|	Y_SGEU_POP
	;

SET_EQ_POP:	Y_SEQ_POP
	|	Y_SNE_POP
	;

MULT_OP:	Y_MULT_OP
	|	Y_MULTU_OP
	;

NULLARY_BR_OP:	Y_BC0T_OP
	|	Y_BC1T_OP
	|	Y_BC2T_OP
	|	Y_BC3T_OP
	|	Y_BC0F_OP
	|	Y_BC1F_OP
	|	Y_BC2F_OP
	|	Y_BC3F_OP
	;

UNARY_BR_OP:	Y_BGEZ_OP
	|	Y_BGEZAL_OP
	|	Y_BGTZ_OP
	|	Y_BLEZ_OP
	|	Y_BLTZ_OP
	|	Y_BLTZAL_OP
	;

UNARY_BR_POP:	Y_BEQZ_POP
	|	Y_BNEZ_POP
	;

BINARY_BR_OP:	Y_BEQ_OP
	|	Y_BNE_OP
	;

BR_GT_POP:	Y_BGT_POP
	|	Y_BGTU_POP

BR_GE_POP:	Y_BGE_POP
	|	Y_BGEU_POP

BR_LT_POP:	Y_BLT_POP
	|	Y_BLTU_POP

BR_LE_POP:	Y_BLE_POP
	|	Y_BLEU_POP
	;

J_OPS:		Y_J_OP
	|	Y_JR_OP
	|	Y_JAL_OP
	|	Y_JALR_OP
	;

B_OP:		Y_B_POP
	|	Y_BAL_POP
	;

MOVE_COP_OP:	Y_MOV_S_OP
	|	Y_MOV_D_OP
	;

MOV_FROM_HILO_OP:	Y_MFHI_OP
	|	Y_MFLO_OP
	;

MOV_TO_HILO_OP:	Y_MTHI_OP
	|	Y_MTLO_OP
	;

MOV_COP_OP:	Y_MFC0_OP
	|	Y_MFC1_OP
	|	Y_MFC1_D_POP
	|	Y_MFC2_OP
	|	Y_MFC3_OP
	|	Y_MTC0_OP
	|	Y_MTC1_OP
	|	Y_MTC1_D_POP
	|	Y_MTC2_OP
	|	Y_MTC3_OP
	;

CTL_COP_OP:	Y_CFC0_OP
	|	Y_CFC1_OP
	|	Y_CFC2_OP
	|	Y_CFC3_OP
	|	Y_CTC0_OP
	|	Y_CTC1_OP
	|	Y_CTC2_OP
	|	Y_CTC3_OP
	;

FP_ABS_OP:	Y_ABS_S_OP
	|	Y_ABS_D_OP
	;

FP_BINARY_OP:	Y_ADD_S_OP
	|	Y_ADD_D_OP
	|	Y_DIV_S_OP
	|	Y_DIV_D_OP
	|	Y_MUL_S_OP
	|	Y_MUL_D_OP
	|	Y_SUB_S_OP
	|	Y_SUB_D_OP
	;

FP_CONVERT_OP:	Y_CVT_D_S_OP
	|	Y_CVT_D_W_OP
	|	Y_CVT_S_D_OP
	|	Y_CVT_S_W_OP
	|	Y_CVT_W_D_OP
	|	Y_CVT_W_S_OP
	;

FP_NEG_OP:	Y_NEG_S_OP
	|	Y_NEG_D_OP
	;

FP_CMP_OP:	Y_C_F_S_OP
	|	Y_C_UN_S_OP
	|	Y_C_EQ_S_OP
	|	Y_C_UEQ_S_OP
	|	Y_C_OLT_S_OP
	|	Y_C_OLE_S_OP
	|	Y_C_ULT_S_OP
	|	Y_C_ULE_S_OP
	|	Y_C_SF_S_OP
	|	Y_C_NGLE_S_OP
	|	Y_C_SEQ_S_OP
	|	Y_C_NGL_S_OP
	|	Y_C_LT_S_OP
	|	Y_C_NGE_S_OP
	|	Y_C_LE_S_OP
	|	Y_C_NGT_S_OP
	|	Y_C_F_D_OP
	|	Y_C_UN_D_OP
	|	Y_C_EQ_D_OP
	|	Y_C_UEQ_D_OP
	|	Y_C_OLT_D_OP
	|	Y_C_OLE_D_OP
	|	Y_C_ULT_D_OP
	|	Y_C_ULE_D_OP
	|	Y_C_SF_D_OP
	|	Y_C_NGLE_D_OP
	|	Y_C_SEQ_D_OP
	|	Y_C_NGL_D_OP
	|	Y_C_LT_D_OP
	|	Y_C_NGE_D_OP
	|	Y_C_LE_D_OP
	|	Y_C_NGT_D_OP
	;



ASM_DIRECTIVE:	Y_ALIAS_DIR	Y_REG	Y_REG

	|	Y_ALIGN_DIR	EXPR
		{
		  align_data ($2.i);
		}

	|	Y_ASCII_DIR {null_term = 0;}	STR_LST
		{
		  if (text_dir)
		    yyerror ("Can't put data in text segment");
		}

	|	Y_ASCIIZ_DIR {null_term = 1;}	STR_LST
		{
		  if (text_dir)
		    yyerror ("Can't put data in text segment");
		}


	|	Y_ASM0_DIR

	|	Y_BGNB_DIR	Y_INT


	|	Y_BYTE_DIR
		{store_op = store_byte;}
		EXPR_LST
		{
		  if (text_dir)
		    yyerror ("Can't put data in text segment");
		}


	|	Y_COMM_DIR	ID		EXPR
		{
		  align_data (2);
		  if (lookup_label ((char*)$2.p)->addr == 0)
		  {
		    record_label ((char*)$2.p, current_data_pc (), 1);
			if ($1.p) free($1.p);
		  }
		  increment_data_pc ($3.i);
		}


	|	Y_DATA_DIR
		{
		  user_kernel_data_segment (0);
		  data_dir = 1; text_dir = 0;
		  enable_data_alignment ();
		}

	|	Y_DATA_DIR	Y_INT
		{
		  user_kernel_data_segment (0);
		  data_dir = 1; text_dir = 0;
		  enable_data_alignment ();
		  set_data_pc ($2.i);
		}


	|	Y_K_DATA_DIR
		{
		  user_kernel_data_segment (1);
		  data_dir = 1; text_dir = 0;
		  enable_data_alignment ();
		}

	|	Y_K_DATA_DIR	Y_INT
		{
		  user_kernel_data_segment (1);
		  data_dir = 1; text_dir = 0;
		  enable_data_alignment ();
		  set_data_pc ($2.i);
		}


	|	Y_DOUBLE_DIR
		{
		  store_op = store_double;
		  if (data_dir) set_data_alignment(3);
		}
		FP_EXPR_LST
		{
		  if (text_dir)
		    yyerror ("Can't put data in text segment");
		}


	|	Y_END_DIR	OPTIONAL_ID

	|	Y_ENDB_DIR	Y_INT

	|	Y_ENDR_DIR

	|	Y_ENT_DIR	ID

	|	Y_ENT_DIR	ID		Y_INT


	|	Y_EXTERN_DIR	ID		EXPR
		{
		  extern_directive ((char*)$2.p, $3.i);
		}


	|	Y_ERR_DIR
		{
		  fatal_error ("File contains an .err directive\n");
		}


	|	Y_FILE_DIR	Y_INT		Y_STR


	|	Y_FLOAT_DIR
		{
		  store_op = store_float;
		  if (data_dir) set_data_alignment (2);
		}
		FP_EXPR_LST
		{
		  if (text_dir)
		    yyerror ("Can't put data in text segment");
		}


	|	Y_FMASK_DIR	Y_INT		Y_INT

	|	Y_FRAME_DIR	REGISTER	Y_INT	REGISTER


	|	Y_GLOBAL_DIR	ID
		{
		  make_label_global ((char*)$2.p);
		  if ($2.p) free($2.p);
		}


	|	Y_HALF_DIR
		{
		  store_op = store_half;
		  if (data_dir) set_data_alignment (1);
		}
		EXPR_LST
		{
		  if (text_dir)
		    yyerror ("Can't put data in text segment");
		}


	|	Y_LABEL_DIR	ID
		{
		  record_label ((char*)$2.p,
				text_dir
				? current_text_pc ()
				: current_data_pc (),
				1);
		  if ($1.p) free($1.p);
		}


	|	Y_LCOMM_DIR	ID		EXPR
		{
		  lcomm_directive ((char*)$2.p, $3.i);
		}


		/* Produced by cc 2.10 */
	|	Y_LIVEREG_DIR	Y_INT		Y_INT


	|	Y_LOC_DIR	Y_INT		Y_INT

	|	Y_MASK_DIR	Y_INT		Y_INT

	|	Y_NOALIAS_DIR	Y_REG	Y_REG

	|	Y_OPTIONS_DIR	ID

	|	Y_REPEAT_DIR	EXPR
		{
		  yyerror ("Warning: repeat directive ignored");
		}


	|	Y_RDATA_DIR
		{
		  user_kernel_data_segment (0);
		  data_dir = 1; text_dir = 0;
		  enable_data_alignment ();
		}

	|	Y_RDATA_DIR	Y_INT
		{
		  user_kernel_data_segment (0);
		  data_dir = 1; text_dir = 0;
		  enable_data_alignment ();
		  set_data_pc ($2.i);
		}


	|	Y_SDATA_DIR
		{
		  user_kernel_data_segment (0);
		  data_dir = 1; text_dir = 0;
		  enable_data_alignment ();
		}

	|	Y_SDATA_DIR	Y_INT
		{
		  user_kernel_data_segment (0);
		  data_dir = 1; text_dir = 0;
		  enable_data_alignment ();
		  set_data_pc ($2.i);
		}


	|	Y_SET_DIR		ID
		{
		  if (streq ((char*)$2.p, "noat"))
		    noat_flag = 1;
		  else if (streq ((char*)$2.p, "at"))
		    noat_flag = 0;
		}


	|	Y_SPACE_DIR	EXPR
		{
		  if (data_dir)
		    increment_data_pc ($2.i);
		  else if (text_dir)
		    increment_text_pc ($2.i);
		}


	|	Y_STRUCT_DIR	EXPR
		{
		  yyerror ("Warning: struct directive ignored");
		}


	|	Y_TEXT_DIR
		{
		  user_kernel_text_segment (0);
		  data_dir = 0; text_dir = 1;
		  enable_data_alignment ();
		}

	|	Y_TEXT_DIR	Y_INT
		{
		  user_kernel_text_segment (0);
		  data_dir = 0; text_dir = 1;
		  enable_data_alignment ();
		  set_text_pc ($2.i);
		}


	|	Y_K_TEXT_DIR
		{
		  user_kernel_text_segment (1);
		  data_dir = 0; text_dir = 1;
		  enable_data_alignment ();
		}

	|	Y_K_TEXT_DIR	Y_INT
		{
		  user_kernel_text_segment (1);
		  data_dir = 0; text_dir = 1;
		  enable_data_alignment ();
		  set_text_pc ($2.i);
		}


	|	Y_VERSTAMP_DIR	Y_INT		Y_INT

	|	Y_VREG_DIR	REGISTER	Y_INT	Y_INT


	|	Y_WORD_DIR
		{
		  store_op = store_word_data;
		  if (data_dir) set_data_alignment (2);
		}
		EXPR_LST

	;



ADDRESS:	{only_id = 1;} ADDR {only_id = 0; $$ = $2;}

ADDR:		'(' REGISTER ')'
		{
		  $$.p = make_addr_expr (0, NULL, $2.i);
		}

	|	ABS_ADDR
		{
		  $$.p = make_addr_expr ($1.i, NULL, 0);
		}

	|	ABS_ADDR '(' REGISTER ')'
		{
		  $$.p = make_addr_expr ($1.i, NULL, $3.i);
		}

	|	Y_ID
		{
		  $$.p = make_addr_expr (0, (char*)$1.p, 0);
		  if ($1.p) free ((char*)$1.p);
		}

	|	Y_ID '(' REGISTER ')'
		{
		  $$.p = make_addr_expr (0, (char*)$1.p, $3.i);
		  if ($1.p) free ((char*)$1.p);
		}

	|	Y_ID '+' ABS_ADDR
		{
		  $$.p = make_addr_expr ($3.i, (char*)$1.p, 0);
		  if ($1.p) free ((char*)$1.p);
		}

	|	ABS_ADDR '+' ID
		{
		  $$.p = make_addr_expr ($1.i, (char*)$3.p, 0);
		}

	|	Y_ID '-' ABS_ADDR
		{
		  $$.p = make_addr_expr (- $3.i, (char*)$1.p, 0);
		  if ($1.p) free ((char*)$1.p);
		}

	|	Y_ID '+' ABS_ADDR '(' REGISTER ')'
		{
		  $$.p = make_addr_expr ($3.i, (char*)$1.p, $5.i);
		  if ($1.p) free ((char*)$1.p);
		}

	|	Y_ID '-' ABS_ADDR '(' REGISTER ')'
		{
		  $$.p = make_addr_expr (- $3.i, (char*)$1.p, $5.i);
		  if ($1.p) free ((char*)$1.p);
		}
	;


BR_IMM32:	{only_id = 1;} IMM32 {only_id = 0; $$ = $2;}

IMM16:	IMM32
		{
		  check_imm_range($1.p, IMM_MIN, IMM_MAX);
		  $$ = $1;
		}

UIMM16:	IMM32
		{
		  check_uimm_range($1.p, UIMM_MIN, UIMM_MAX);
		  $$ = $1;
		}


IMM32:		ABS_ADDR
		{
		  $$.p = make_imm_expr ($1.i, NULL, 0);
		}

	|	'(' ABS_ADDR ')' '>' '>' Y_INT
		{
		  $$.p = make_imm_expr ($2.i >> $6.i, NULL, 0);
		}

	|	ID
		{
		  $$.p = make_imm_expr (0, (char*)$1.p, 0);
		}

	|	Y_ID '+' ABS_ADDR
		{
		  $$.p = make_imm_expr ($3.i, (char*)$1.p, 0);
		  free ((char*)$1.p);
		}

	|	Y_ID '-' ABS_ADDR
		{
		  $$.p = make_imm_expr (- $3.i, (char*)$1.p, 0);
		  free ((char*)$1.p);
		}
	;


ABS_ADDR:	Y_INT

	|	Y_INT '+' Y_INT
		{$$.i = $1.i + $3.i;}

	|	Y_INT Y_INT
		{
		  /* Y_INT '-' Y_INT */
		  if ($2.i >= 0)
		    yyerror ("Syntax error");
		  $$.i = $1.i - $2.i;
		}
	;

DEST_REG:	REGISTER ;

SRC1:		REGISTER ;

SRC2:		REGISTER ;

DEST:		REGISTER ;

REG:		REGISTER ;

SOURCE:		REGISTER ;

REGISTER:	Y_REG
		{
		  if ($1.i < 0 || $1.i > 31)
		    yyerror ("Register number out of range");
		  if ($1.i == 1 && !bare_machine && !noat_flag)
		    yyerror ("Register 1 is reserved for assembler");
		  $$ = $1;
		}

F_DEST:		FP_REGISTER ;

F_SRC1:		FP_REGISTER ;

F_SRC2:		FP_REGISTER ;

FP_REGISTER:	Y_FP_REG
		{
		  if ($1.i < 0 || $1.i > 31)
		    yyerror ("FP register number out of range");
		  $$ = $1;
		}


COP_REG:	Y_REG

	|	Y_FP_REG

	;


LABEL:		ID
		{
		  $$.p = make_imm_expr (-(int)current_text_pc (), (char*)$1.p, 1);
		}


STR_LST:	STR_LST STR
	|	STR
	;


STR:		Y_STR
		{
		  store_string ((char*)$1.p, y_str_length, null_term);
		  free ((char*)$1.p);
		}
	|	Y_STR ':' Y_INT
		{
		  int i;

		  for (i = 0; i < $3.i; i ++)
		    store_string ((char*)$1.p, y_str_length, null_term);
		  free ((char*)$1.p);
		}
	;


EXPRESSION:	{only_id = 1;} EXPR {only_id = 0; $$ = $2;}

EXPR:		Y_INT

	|	ID
		{
		  label *l = lookup_label ((char*)$1.p);

		  if (l->addr == 0)
		    {
		      record_data_uses_symbol (current_data_pc (), l);
		      $$.p = NULL;
		    }
		  else
		    $$.i = l->addr;
		}


EXPR_LST:	EXPR_LST	EXPRESSION
		{
		  store_op ($2.p);
		}
	|	EXPRESSION
		{
		  store_op ($1.p);
		}
	|	EXPRESSION ':' Y_INT
		{
		  int i;

		  for (i = 0; i < $3.i; i ++)
		    store_op ($1.p);
		}
	;


FP_EXPR_LST:	FP_EXPR_LST Y_FP
		{
		  store_op ($2.p);
		}
	|	Y_FP
		{
		  store_op ($1.p);
		}
	;


OPTIONAL_ID:	{only_id = 1;} OPT_ID {only_id = 0; $$ = $2;}

OPT_ID:		ID
	|	{$$.p = (void*)NULL;}
	;


ID:		{only_id = 1;} Y_ID {only_id = 0; $$ = $2;}


%%

/* Maintain and update the address of labels for the current line. */

#ifdef __STDC__
void
fix_current_label_address (mem_addr new_addr)
#else
void
fix_current_label_address (new_addr)
     mem_addr new_addr;
#endif
{
  label_list *l;

  for (l = this_line_labels; l != NULL; l = l->tail)
    {
      l->head->addr = new_addr;
    }
  clear_labels ();
}


#ifdef __STDC__
static label_list *
cons_label (label *head, label_list *tail)
#else
static label_list *
cons_label (head, tail)
     label *head;
     label_list *tail;
#endif
{
  label_list *c = (label_list *) malloc (sizeof (label_list));

  c->head = head;
  c->tail = tail;
  return (c);
}


#ifdef __STDC__
static void
clear_labels (void)
#else
static void
clear_labels ()
#endif
{
  label_list *n;

  for ( ; this_line_labels != NULL; this_line_labels = n)
    {
      resolve_label_uses(this_line_labels->head);
      n = this_line_labels->tail;
      free (this_line_labels);
    }
}


/* Operations on op codes. */

#ifdef __STDC__
int
op_to_imm_op (int opcode)
#else
int
op_to_imm_op (opcode)
     int opcode;
#endif
{
  switch (opcode)
    {
    case Y_ADD_OP: return (Y_ADDI_OP);
    case Y_ADDU_OP: return (Y_ADDIU_OP);
    case Y_AND_OP: return (Y_ANDI_OP);
    case Y_OR_OP: return (Y_ORI_OP);
    case Y_XOR_OP: return (Y_XORI_OP);
    case Y_SLT_OP: return (Y_SLTI_OP);
    case Y_SLTU_OP: return (Y_SLTIU_OP);
    case Y_SLLV_OP: return (Y_SLL_OP);
    case Y_SRAV_OP: return (Y_SRA_OP);
    case Y_SRLV_OP: return (Y_SRL_OP);
    default: fatal_error ("Can't convert op to immediate op\n"); return (0);
    }
}


#ifdef __STDC__
int
imm_op_to_op (int opcode)
#else
int
imm_op_to_op (opcode)
     int opcode;
#endif
{
  switch (opcode)
    {
    case Y_ADDI_OP: return (Y_ADD_OP);
    case Y_ADDIU_OP: return (Y_ADDU_OP);
    case Y_ANDI_OP: return (Y_AND_OP);
    case Y_ORI_OP: return (Y_OR_OP);
    case Y_XORI_OP: return (Y_XOR_OP);
    case Y_SLTI_OP: return (Y_SLT_OP);
    case Y_SLTIU_OP: return (Y_SLTU_OP);
    case Y_J_OP: return (Y_JR_OP);
    case Y_LUI_OP: return (Y_ADDU_OP);
    case Y_SLL_OP: return (Y_SLLV_OP);
    case Y_SRA_OP: return (Y_SRAV_OP);
    case Y_SRL_OP: return (Y_SRLV_OP);
    default: fatal_error ("Can't convert immediate op to op\n"); return (0);
    }
}


#ifdef __STDC__
static void
nop_inst (void)
#else
static void
nop_inst ()
#endif
{
  r_type_inst (Y_SLL_OP, 0, 0, 0); /* = 0 */
}


#ifdef __STDC__
static void
trap_inst (void)
#else
static void
trap_inst ()
#endif
{
  r_type_inst (Y_BREAK_OP, 0, 0, 0);
}


#ifdef __STDC__
static imm_expr *
branch_offset (int n_inst)
#else
static imm_expr *
branch_offset (n_inst)
     int n_inst;
#endif
{
  return (const_imm_expr (n_inst << 2)); /* Later shifted right 2 places */
}


#ifdef __STDC__
static void
div_inst (int op, int rd, int rs, int rt, int const_divisor)
#else
static void
div_inst (op, rd, rs, rt, const_divisor)
     int op, rd, rs, rt, const_divisor;
#endif
{
  if (rd != 0 && !const_divisor)
    {
      i_type_inst_free (Y_BNE_OP, 0, rt, branch_offset (2));
      trap_inst ();
    }

  if (op == Y_DIV_OP || op == Y_REM_POP)
    r_type_inst (Y_DIV_OP, 0, rs, rt);
  else
    r_type_inst (Y_DIVU_OP, 0, rs, rt);

  if (rd != 0)
    {
      if (op == Y_DIV_OP || op == Y_DIVU_OP)
	/* Quotient */
	r_type_inst (Y_MFLO_OP, rd, 0, 0);
      else
	/* Remainder */
	r_type_inst (Y_MFHI_OP, rd, 0, 0);
    }
}


#ifdef __STDC__
static void
mult_inst (int op, int rd, int rs, int rt)
#else
static void
mult_inst (op, rd, rs, rt)
     int op, rd, rs, rt;
#endif
{
  if (op == Y_MULOU_POP)
    r_type_inst (Y_MULTU_OP, 0, rs, rt);
  else
    r_type_inst (Y_MULT_OP, 0, rs, rt);
  if (op == Y_MULOU_POP && rd != 0)
    {
      r_type_inst (Y_MFHI_OP, 1, 0, 0);	/* Use $at */
      i_type_inst_free (Y_BEQ_OP, 0, 1, branch_offset (2));
      trap_inst ();
    }
  else if (op == Y_MULO_POP && rd != 0)
    {
      r_type_inst (Y_MFHI_OP, 1, 0, 0); /* use $at */
      r_type_inst (Y_MFLO_OP, rd, 0, 0);
      r_sh_type_inst (Y_SRA_OP, rd, rd, 31);
      i_type_inst_free (Y_BEQ_OP, rd, 1, branch_offset (2));
      trap_inst ();
    }
  if (rd != 0)
    r_type_inst (Y_MFLO_OP, rd, 0, 0);
}


#ifdef __STDC__
static void
set_le_inst (int op, int rd, int rs, int rt)
#else
static void
set_le_inst (op, rd, rs, rt)
     int op, rd, rs, rt;
#endif
{
  i_type_inst_free (Y_BNE_OP, rs, rt, branch_offset (3));
  i_type_inst_free (Y_ORI_OP, rd, 0, const_imm_expr (1));
  i_type_inst_free (Y_BEQ_OP, 0, 0, branch_offset (2));
  r_type_inst ((op == Y_SLE_POP ? Y_SLT_OP : Y_SLTU_OP), rd, rs, rt);
}


#ifdef __STDC__
static void
set_gt_inst (int op, int rd, int rs, int rt)
#else
static void
set_gt_inst (op, rd, rs, rt)
     int op, rd, rs, rt;
#endif
{
  r_type_inst (op == Y_SGT_POP ? Y_SLT_OP : Y_SLTU_OP, rd, rt, rs);
}


#ifdef __STDC__
static void
set_ge_inst (int op, int rd, int rs, int rt)
#else
static void
set_ge_inst (op, rd, rs, rt)
     int op, rd, rs, rt;
#endif
{
  i_type_inst_free (Y_BNE_OP, rs, rt, branch_offset (3));
  i_type_inst_free (Y_ORI_OP, rd, 0, const_imm_expr (1));
  i_type_inst_free (Y_BEQ_OP, 0, 0, branch_offset (2));
  r_type_inst (op == Y_SGE_POP ? Y_SLT_OP : Y_SLTU_OP, rd, rt, rs);
}


#ifdef __STDC__
static void
set_eq_inst (int op, int rd, int rs, int rt)
#else
static void
set_eq_inst (op, rd, rs, rt)
     int op, rd, rs, rt;
#endif
{
  imm_expr *if_eq, *if_neq;

  if (op == Y_SEQ_POP)
    if_eq = const_imm_expr (1), if_neq = const_imm_expr (0);
  else
    if_eq = const_imm_expr (0), if_neq = const_imm_expr (1);

  i_type_inst_free (Y_BEQ_OP, rs, rt, branch_offset (3));
  /* RD <- 0 (if not equal) */
  i_type_inst_free (Y_ORI_OP, rd, 0, if_neq);
  i_type_inst_free (Y_BEQ_OP, 0, 0, branch_offset (2)); /* Branch always */
  /* RD <- 1 */
  i_type_inst_free (Y_ORI_OP, rd, 0, if_eq);
}


/* Store the value either as a datum or instruction. */

#ifdef __STDC__
static void
store_word_data (int value)
#else
static void
store_word_data (value)
     int value;
#endif
{
  if (data_dir)
    store_word (value);
  else if (text_dir)
    store_instruction (inst_decode (value));
}



#ifdef __STDC__
void
initialize_parser (char *file_name)
#else
void
initialize_parser (file_name)
     char *file_name;
#endif
{
  input_file_name = file_name;
  only_id = 0;
  data_dir = 0;
  text_dir = 1;
}


#ifdef __STDC__
static void
check_imm_range(imm_expr* expr, int32 min, int32 max)
#else
static void
check_imm_range()
     imm_expr* expr;
     int32 min;
     int32 max;
#endif
{
  if (expr->symbol == NULL || SYMBOL_IS_DEFINED (expr->symbol))
    {
      /* If expression can be evaluated, compare its value against the limits
	 and complain if the value is out of bounds. */
      int32 value = eval_imm_expr (expr);

      if (value < min || max < value)
	{
	  char str[200];
	  sprintf (str, "immediate value (%d) out of range (%d .. %d)",
		   value, min, max);
	  yywarn (str);
	}
    }
}


#ifdef __STDC__
static void
check_uimm_range(imm_expr* expr, uint32 min, uint32 max)
#else
static void
check_uimm_range()^
     imm_expr* expr;
     int32 umin;
     int32 umax;
#endif
{
  if (expr->symbol == NULL || SYMBOL_IS_DEFINED (expr->symbol))
    {
      /* If expression can be evaluated, compare its value against the limits
	     and complain if the value is out of bounds. */
      uint32 value = eval_imm_expr (expr);

      if (value < min || max < value)
	{
	  char str[200];
	  sprintf (str, "immediate value (%d) out of range (%d .. %d)",
		   value, min, max);
	  yywarn (str);
	}
    }
}

#ifdef __STDC__
void
yyerror (char *s)
#else
void
yyerror (s)
     char *s;
#endif
{
  parse_error_occurred = 1;
  yywarn (s);
}


#ifdef __STDC__
void
yywarn (char *s)
#else
void
yywarn (s)
     char *s;
#endif
{
  error ("spim: (parser) %s on line %d of file %s\n", s, line_no, input_file_name);
  print_erroneous_line ();
}
