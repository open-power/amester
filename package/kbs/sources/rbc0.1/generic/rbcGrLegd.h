/*
 * rbcGrLegd.h --
 *
 *      TODO: Description
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#ifndef _RBCGRLEGEND
#define _RBCGRLEGEND

#define LEGEND_RIGHT	(1<<0)	/* Right margin */
#define LEGEND_LEFT	(1<<1)	/* Left margin */
#define LEGEND_BOTTOM	(1<<2)	/* Bottom margin */
#define LEGEND_TOP	(1<<3)	/* Top margin, below the graph title. */
#define LEGEND_PLOT	(1<<4)	/* Plot area */
#define LEGEND_XY	(1<<5)	/* Screen coordinates in the plotting
* area. */
#define LEGEND_WINDOW	(1<<6)	/* External window. */
#define LEGEND_IN_MARGIN \
	(LEGEND_RIGHT | LEGEND_LEFT | LEGEND_BOTTOM | LEGEND_TOP)
#define LEGEND_IN_PLOT  (LEGEND_PLOT | LEGEND_XY)

int Rbc_CreateLegend _ANSI_ARGS_((Graph *graphPtr));
void Rbc_DestroyLegend _ANSI_ARGS_((Graph *graphPtr));
void Rbc_DrawLegend _ANSI_ARGS_((Legend *legendPtr, Drawable drawable));
void Rbc_MapLegend _ANSI_ARGS_((Legend *legendPtr, int width, int height));
int Rbc_LegendOp _ANSI_ARGS_((Graph *graphPtr, Tcl_Interp *interp, int argc, char **argv));
int Rbc_LegendSite _ANSI_ARGS_((Legend *legendPtr));
int Rbc_LegendWidth _ANSI_ARGS_((Legend *legendPtr));
int Rbc_LegendHeight _ANSI_ARGS_((Legend *legendPtr));
int Rbc_LegendIsHidden _ANSI_ARGS_((Legend *legendPtr));
int Rbc_LegendIsRaised _ANSI_ARGS_((Legend *legendPtr));
int Rbc_LegendX _ANSI_ARGS_((Legend *legendPtr));
int Rbc_LegendY _ANSI_ARGS_((Legend *legendPtr));
void Rbc_LegendRemoveElement _ANSI_ARGS_((Legend *legendPtr, Element *elemPtr));
#endif /* _RBCGRLEGEND */
