/* SPIM S20 MIPS simulator.
   X interface to SPIM

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


/* $Header: /Software/SPIM/src/windows.c 4     12/24/00 1:37p Larus $
 */


#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Cardinals.h>
#include <X11/Xaw/Paned.h>
#include <X11/Xaw/AsciiText.h>
#include <X11/Xaw/Box.h>
#include <X11/Xaw/Label.h>

#include <stdio.h>

#include "spim.h"
#include "spim-utils.h"
#include "buttons.h"
#include "xspim.h"
#include "windows.h"


/* Exported variables: */

Widget register_window, text_window, data_window;


/* Internal functions: */

#ifdef __STDC__
static void create_command_panel (Widget parent, Dimension app_width,
				  Dimension button_height,
				  Dimension command_hspace,
				  Dimension command_vspace,
				  Dimension command_height);
static void create_data_window (Widget parent, Dimension segment_height);
static void create_display_window (Widget parent, Dimension display_height);
static void create_reg_window (Widget parent, Dimension reg_min_height,
			       Dimension reg_max_height);
static void create_text_window (Widget parent, Dimension segment_height);
#else
static void create_command_panel ();
static void create_data_window ();
static void create_display_window ();
static void create_reg_window ();
static void create_text_window ();
#endif



#ifdef __STDC__
static void
create_reg_window (Widget parent, Dimension reg_min_height,
		   Dimension reg_max_height)
#else
static void
create_reg_window (parent, reg_min_height, reg_max_height)
     Widget parent;
     Dimension reg_min_height, reg_max_height;
#endif
{
  Arg args[15];
  Cardinal n = 0;

  XtSetArg (args[n], XtNtype, XawAsciiString); n++;
  XtSetArg (args[n], XtNeditType, XawtextRead); n++;
  XtSetArg (args[n], XtNpreferredPaneSize, reg_min_height); n++;
  XtSetArg (args[n], XtNmin, reg_min_height); n++;
  XtSetArg (args[n], XtNmax, reg_max_height); n++;
  XtSetArg (args[n], XtNresize, "width"); n++;
  XtSetArg (args[n], XtNwrap, "line"); n++;
  XtSetArg (args[n], XtNstring, ""); n++;
  XtSetArg (args[n], XtNlength, 0); n++;
  XtSetArg (args[n], XtNuseStringInPlace, True); n++;
  XtSetArg (args[n], XtNdisplayCaret, False); n++;
  register_window = XtCreateManagedWidget ("register", asciiTextWidgetClass,
					   parent, args, n);
}


#ifdef __STDC__
static void
create_command_panel (Widget parent, Dimension app_width,
		      Dimension button_height, Dimension command_hspace,
		      Dimension command_vspace, Dimension command_height)
#else
static void
create_command_panel (parent, app_width, button_height, command_hspace,
		    command_vspace, command_height)
     Widget parent;
     Dimension app_width, button_height, command_hspace, command_vspace;
     Dimension command_height;
#endif
{
  Widget panel;
  Arg args[10];
  Cardinal n = 0;

  XtSetArg (args[n], XtNwidth, app_width); n++;
  XtSetArg (args[n], XtNmin, command_height); n++;
  XtSetArg (args[n], XtNmax, command_height); n++;
  XtSetArg (args[n], XtNpreferredPaneSize, 2*button_height + 3 * command_vspace);
  n++;
  XtSetArg (args[n], XtNhSpace, command_hspace); n++;
  XtSetArg (args[n], XtNvSpace, command_vspace); n++;
  XtSetArg (args[n], XtNallowResize, False); n++;
  panel = XtCreateManagedWidget ("panel", boxWidgetClass, parent, args, n);

  create_buttons (panel);
}


#ifdef __STDC__
static void
create_text_window (Widget parent, Dimension segment_height)
#else
static void
create_text_window (parent, segment_height)
     Widget parent;
     Dimension segment_height;
#endif
{
  Arg args[15];
  Cardinal n = 0;

  XtSetArg (args[n], XtNallowResize, False); n++;
  XtSetArg (args[n], XtNshowGrip, False); n++;
  XtSetArg (args[n], XtNresize, False); n++;
  XtSetArg (args[n], XtNmin, TEXTHEIGHT); n++;
  XtSetArg (args[n], XtNlabel, "Text Segments"); n++;
  XtSetArg (args[n], XtNborderWidth, 0); n++;
  XtSetArg (args[n], XtNuseStringInPlace, True); n++;
  XtCreateManagedWidget ("TextSegmentLabel", labelWidgetClass, parent,
			 args, n);

  n = 0;
  XtSetArg (args[n], XtNtype, XawAsciiString); n++;
/*  XtSetArg (args[n], XtNeditType, XawtextRead); n++;*/
  XtSetArg (args[n], XtNpreferredPaneSize, segment_height); n++;
  XtSetArg (args[n], XtNstring, ""); n++;
  XtSetArg (args[n], XtNborderWidth, 0); n++;
  XtSetArg (args[n], XtNdisplayCaret, True); n++;
  XtSetArg (args[n], XtNdisplayCaret, False); n++;
  XtSetArg (args[n], XtNscrollVertical, XawtextScrollWhenNeeded); n++;
  text_window = XtCreateManagedWidget ("file", asciiTextWidgetClass, parent,
				       args, n);
}


#ifdef __STDC__
static void
create_data_window (Widget parent, Dimension segment_height)
#else
static void
create_data_window (parent, segment_height)
     Widget parent;
     Dimension segment_height;
#endif
{
  Arg args[15];
  Cardinal n = 0;

  XtSetArg (args[n], XtNallowResize, False); n++;
  XtSetArg (args[n], XtNshowGrip, False); n++;
  XtSetArg (args[n], XtNresize, False); n++;
  XtSetArg (args[n], XtNmin, TEXTHEIGHT); n++;
  XtSetArg (args[n], XtNlabel, "Data Segments"); n++;
  XtSetArg (args[n], XtNborderWidth, 0); n++;
  XtSetArg (args[n], XtNuseStringInPlace, True); n++;
  XtSetArg (args[n], XtNdisplayCaret, False); n++;
  XtCreateManagedWidget ("DataSegmentLabel", labelWidgetClass, parent,
			 args, n);

  n = 0;
  XtSetArg (args[n], XtNtype, XawAsciiString); n++;
  XtSetArg (args[n], XtNeditType, XawtextRead); n++;
  XtSetArg (args[n], XtNpreferredPaneSize, segment_height); n++;
  XtSetArg (args[n], XtNstring, ""); n++;
  XtSetArg (args[n], XtNborderWidth, 0); n++;
  XtSetArg (args[n], XtNdisplayCaret, False); n++;
  XtSetArg (args[n], XtNscrollVertical, XawtextScrollWhenNeeded); n++;
  data_window = XtCreateManagedWidget ("file", asciiTextWidgetClass, parent,
				       args, n);
}


#ifdef __STDC__
static void
create_display_window (Widget parent, Dimension display_height)
#else
static void
create_display_window (parent, display_height)
     Widget parent;
     Dimension display_height;
#endif
{
  Arg args[15];
  Cardinal n = 0;

  XtSetArg (args[n], XtNeditType, XawtextEdit); n++;
  XtSetArg (args[n], XtNpreferredPaneSize, display_height); n++;
  XtSetArg (args[n], XtNborderWidth, 0); n++;
  XtSetArg (args[n], XtNdisplayCaret, False); n++;
  XtSetArg (args[n], XtNdisplayNonprinting, False); n++;
  XtSetArg (args[n], XtNscrollVertical, XawtextScrollWhenNeeded); n++;
  XtSetArg (args[n], XtNwrap, "line"); n++;
  message = XtCreateManagedWidget ("display", asciiTextWidgetClass, parent,
				   args, n);
  message_out.f = (FILE *) message;
}


#ifdef __STDC__
void
create_sub_windows (Widget parent, Dimension app_width,
		    Dimension reg_min_height, Dimension reg_max_height,
		    Dimension command_height, Dimension command_hspace,
		    Dimension command_vspace, Dimension button_height,
		    Dimension segment_height, Dimension display_height)
#else
void
create_sub_windows (parent, app_width, reg_min_height, reg_max_height,
		    command_height, command_hspace, command_vspace,
		    button_height, segment_height, display_height)
     Widget parent;
     Dimension app_width, reg_min_height, reg_max_height;
     Dimension command_height, command_hspace, command_vspace;
     Dimension button_height, segment_height, display_height;
#endif
{
  Widget pane;
  Arg args[10];
  Cardinal n = 0;

  XtSetArg (args[n], XtNwidth, app_width); n++;
  pane = XtCreateManagedWidget ("pane", panedWidgetClass, parent, args, n);

  create_reg_window (pane, reg_min_height, reg_max_height);
  create_command_panel (pane, app_width, button_height, command_hspace,
			command_vspace, command_height);
  create_text_window (pane, segment_height);
  create_data_window (pane, segment_height);
  create_display_window (pane, display_height);
}
