/*
 * rbcGrGrid.c --
 *
 *      This module implements grid lines for the rbc graph widget.
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#include "rbcGraph.h"

extern Tk_CustomOption rbcDistanceOption;
extern Tk_CustomOption rbcDashesOption;
extern Tk_CustomOption rbcAnyXAxisOption;
extern Tk_CustomOption rbcAnyYAxisOption;


#define DEF_GRID_DASHES		"dot"
#define DEF_GRID_FOREGROUND	RGB_GREY64
#define DEF_GRID_FG_MONO	RGB_BLACK
#define DEF_GRID_LINE_WIDTH	"0"
#define DEF_GRID_HIDE_BARCHART	"no"
#define DEF_GRID_HIDE_GRAPH	"yes"
#define DEF_GRID_MINOR		"yes"
#define DEF_GRID_MAP_X_GRAPH	"x"
#define DEF_GRID_MAP_X_BARCHART	(char *)NULL
#define DEF_GRID_MAP_Y		"y"
#define DEF_GRID_POSITION	(char *)NULL

static Tk_ConfigSpec configSpecs[] = {
    {TK_CONFIG_COLOR, "-color", "color", "Color", DEF_GRID_FOREGROUND, Tk_Offset(Grid, colorPtr), TK_CONFIG_COLOR_ONLY | ALL_GRAPHS},
    {TK_CONFIG_COLOR, "-color", "color", "color", DEF_GRID_FG_MONO, Tk_Offset(Grid, colorPtr), TK_CONFIG_MONO_ONLY | ALL_GRAPHS},
    {TK_CONFIG_CUSTOM, "-dashes", "dashes", "Dashes", DEF_GRID_DASHES, Tk_Offset(Grid, dashes), TK_CONFIG_NULL_OK | ALL_GRAPHS, &rbcDashesOption},
    {TK_CONFIG_BOOLEAN, "-hide", "hide", "Hide", DEF_GRID_HIDE_BARCHART, Tk_Offset(Grid, hidden), BARCHART},
    {TK_CONFIG_BOOLEAN, "-hide", "hide", "Hide", DEF_GRID_HIDE_GRAPH, Tk_Offset(Grid, hidden), GRAPH | STRIPCHART},
    {TK_CONFIG_CUSTOM, "-linewidth", "lineWidth", "Linewidth", DEF_GRID_LINE_WIDTH, Tk_Offset(Grid, lineWidth), TK_CONFIG_DONT_SET_DEFAULT | ALL_GRAPHS, &rbcDistanceOption},
    {TK_CONFIG_CUSTOM, "-mapx", "mapX", "MapX", DEF_GRID_MAP_X_GRAPH, Tk_Offset(Grid, axes.x), GRAPH | STRIPCHART, &rbcAnyXAxisOption},
    {TK_CONFIG_CUSTOM, "-mapx", "mapX", "MapX", DEF_GRID_MAP_X_BARCHART, Tk_Offset(Grid, axes.x), BARCHART, &rbcAnyXAxisOption},
    {TK_CONFIG_CUSTOM, "-mapy", "mapY", "MapY", DEF_GRID_MAP_Y, Tk_Offset(Grid, axes.y), ALL_GRAPHS, &rbcAnyYAxisOption},
    {TK_CONFIG_BOOLEAN, "-minor", "minor", "Minor", DEF_GRID_MINOR, Tk_Offset(Grid, minorGrid), TK_CONFIG_DONT_SET_DEFAULT | ALL_GRAPHS},
    {TK_CONFIG_END, NULL, NULL, NULL, NULL, 0, 0}
};

static void ConfigureGrid _ANSI_ARGS_((Graph *graphPtr, Grid *gridPtr));
static int CgetOp _ANSI_ARGS_((Graph *graphPtr, Tcl_Interp *interp, int argc, char **argv));
static int ConfigureOp _ANSI_ARGS_((Graph *graphPtr, Tcl_Interp *interp, int argc, char **argv));
static int MapOp _ANSI_ARGS_((Graph *graphPtr, Tcl_Interp *interp, int argc, char **argv));
static int UnmapOp _ANSI_ARGS_((Graph *graphPtr, Tcl_Interp *interp, int argc, char **argv));
static int ToggleOp _ANSI_ARGS_((Graph *graphPtr, Tcl_Interp *interp, int argc, char **argv));

/*
 *----------------------------------------------------------------------
 *
 * ConfigureGrid --
 *
 *      Configures attributes of the grid such as line width,
 *      dashes, and position.  The grid are first turned off
 *      before any of the attributes changes.
 *
 * Results:
 *      None
 *
 * Side Effects:
 *      Crosshair GC is allocated.
 *
 *----------------------------------------------------------------------
 */
static void
ConfigureGrid(graphPtr, gridPtr)
    Graph *graphPtr;
    Grid *gridPtr;
{
    XGCValues gcValues;
    unsigned long gcMask;
    GC newGC;

    gcValues.background = gcValues.foreground = gridPtr->colorPtr->pixel;
    gcValues.line_width = LineWidth(gridPtr->lineWidth);
    gcMask = (GCForeground | GCBackground | GCLineWidth);
    if (LineIsDashed(gridPtr->dashes)) {
        gcValues.line_style = LineOnOffDash;
        gcMask |= GCLineStyle;
    }
    newGC = Rbc_GetPrivateGC(graphPtr->tkwin, gcMask, &gcValues);
    if (LineIsDashed(gridPtr->dashes)) {
        Rbc_SetDashes(graphPtr->display, newGC, &(gridPtr->dashes));
    }
    if (gridPtr->gc != NULL) {
        Rbc_FreePrivateGC(graphPtr->display, gridPtr->gc);
    }
    gridPtr->gc = newGC;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_MapGrid --
 *
 *      Determines the coordinates of the line segments corresponding
 *      to the grid lines for each axis.
 *
 * Results:
 *      None.
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_MapGrid(graphPtr)
    Graph *graphPtr;
{
    Grid *gridPtr = (Grid *)graphPtr->gridPtr;
    int nSegments;
    Segment2D *segments;

    if (gridPtr->x.segments != NULL) {
        ckfree((char *)gridPtr->x.segments);
        gridPtr->x.segments = NULL;
    }
    if (gridPtr->y.segments != NULL) {
        ckfree((char *)gridPtr->y.segments);
        gridPtr->y.segments = NULL;
    }
    gridPtr->x.nSegments = gridPtr->y.nSegments = 0;
    /*
     * Generate line segments to represent the grid.  Line segments
     * are calculated from the major tick intervals of each axis mapped.
     */
    Rbc_GetAxisSegments(graphPtr, gridPtr->axes.x, &segments, &nSegments);
    if (nSegments > 0) {
        gridPtr->x.nSegments = nSegments;
        gridPtr->x.segments = segments;
    }
    Rbc_GetAxisSegments(graphPtr, gridPtr->axes.y, &segments, &nSegments);
    if (nSegments > 0) {
        gridPtr->y.nSegments = nSegments;
        gridPtr->y.segments = segments;
    }
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_DrawGrid --
 *
 *      Draws the grid lines associated with each axis.
 *
 * Results:
 *      None.
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_DrawGrid(graphPtr, drawable)
    Graph *graphPtr;
    Drawable drawable; /* Pixmap or window to draw into */
{
    Grid *gridPtr = (Grid *)graphPtr->gridPtr;

    if (gridPtr->hidden) {
        return;
    }
    if (gridPtr->x.nSegments > 0) {
        Rbc_Draw2DSegments(graphPtr->display, drawable, gridPtr->gc,
                           gridPtr->x.segments, gridPtr->x.nSegments);
    }
    if (gridPtr->y.nSegments > 0) {
        Rbc_Draw2DSegments(graphPtr->display, drawable, gridPtr->gc,
                           gridPtr->y.segments, gridPtr->y.nSegments);
    }
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_GridToPostScript --
 *
 *      Prints the grid lines associated with each axis.
 *
 * Results:
 *      None.
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_GridToPostScript(graphPtr, psToken)
    Graph *graphPtr;
    PsToken psToken;
{
    Grid *gridPtr = (Grid *)graphPtr->gridPtr;

    if (gridPtr->hidden) {
        return;
    }
    Rbc_LineAttributesToPostScript(psToken, gridPtr->colorPtr,
                                   gridPtr->lineWidth, &(gridPtr->dashes), CapButt, JoinMiter);
    if (gridPtr->x.nSegments > 0) {
        Rbc_2DSegmentsToPostScript(psToken, gridPtr->x.segments,
                                   gridPtr->x.nSegments);
    }
    if (gridPtr->y.nSegments > 0) {
        Rbc_2DSegmentsToPostScript(psToken, gridPtr->y.segments,
                                   gridPtr->y.nSegments);
    }
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_DestroyGrid --
 *
 *      TODO: Description
 *
 * Results:
 *      None.
 *
 * Side Effects:
 *      Grid GC is released.
 *
 *----------------------------------------------------------------------
 */
void
Rbc_DestroyGrid(graphPtr)
    Graph *graphPtr;
{
    Grid *gridPtr = (Grid *)graphPtr->gridPtr;

    Tk_FreeOptions(configSpecs, (char *)gridPtr, graphPtr->display, Rbc_GraphType(graphPtr));
    if (gridPtr->gc != NULL) {
        Rbc_FreePrivateGC(graphPtr->display, gridPtr->gc);
    }
    if (gridPtr->x.segments != NULL) {
        ckfree((char *)gridPtr->x.segments);
    }
    if (gridPtr->y.segments != NULL) {
        ckfree((char *)gridPtr->y.segments);
    }
    ckfree((char *)gridPtr);
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_CreateGrid --
 *
 *      Creates and initializes a new grid structure.
 *
 * Results:
 *      Returns TCL_ERROR if the configuration failed, otherwise TCL_OK.
 *
 * Side Effects:
 *      Memory for grid structure is allocated.
 *
 *----------------------------------------------------------------------
 */
int
Rbc_CreateGrid(graphPtr)
    Graph *graphPtr;
{
    Grid *gridPtr;

    gridPtr = RbcCalloc(1, sizeof(Grid));
    assert(gridPtr);
    gridPtr->minorGrid = TRUE;
    graphPtr->gridPtr = gridPtr;

    if (Rbc_ConfigureWidgetComponent(graphPtr->interp, graphPtr->tkwin, "grid",
                                     "Grid", configSpecs, 0, (char **)NULL, (char *)gridPtr,
                                     Rbc_GraphType(graphPtr)) != TCL_OK) {
        return TCL_ERROR;
    }
    ConfigureGrid(graphPtr, gridPtr);
    return TCL_OK;
}

/*
 *----------------------------------------------------------------------
 *
 * CgetOp --
 *
 *      Queries configuration attributes of the grid such as line
 *      width, dashes, and position.
 *
 * Results:
 *      A standard Tcl result.
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
static int
CgetOp(graphPtr, interp, argc, argv)
    Graph *graphPtr;
    Tcl_Interp *interp;
    int argc;
    char **argv;
{
    Grid *gridPtr = (Grid *)graphPtr->gridPtr;

    return Tk_ConfigureValue(interp, graphPtr->tkwin, configSpecs,
                             (char *)gridPtr, argv[3], Rbc_GraphType(graphPtr));
}

/*
 *----------------------------------------------------------------------
 *
 * ConfigureOp --
 *
 *      Queries or resets configuration attributes of the grid
 *      such as line width, dashes, and position.
 *
 * Results:
 *      A standard Tcl result.
 *
 * Side Effects:
 *      Grid attributes are reset.  The graph is redrawn at the
 *      next idle point.
 *
 *----------------------------------------------------------------------
 */
static int
ConfigureOp(graphPtr, interp, argc, argv)
    Graph *graphPtr;
    Tcl_Interp *interp;
    int argc;
    char **argv;
{
    Grid *gridPtr = (Grid *)graphPtr->gridPtr;
    int flags;

    flags = Rbc_GraphType(graphPtr) | TK_CONFIG_ARGV_ONLY;
    if (argc == 3) {
        return Tk_ConfigureInfo(interp, graphPtr->tkwin, configSpecs,
                                (char *)gridPtr, (char *)NULL, flags);
    } else if (argc == 4) {
        return Tk_ConfigureInfo(interp, graphPtr->tkwin, configSpecs,
                                (char *)gridPtr, argv[3], flags);
    }
    if (Tk_ConfigureWidget(graphPtr->interp, graphPtr->tkwin, configSpecs,
                           argc - 3, argv + 3, (char *)gridPtr, flags) != TCL_OK) {
        return TCL_ERROR;
    }
    ConfigureGrid(graphPtr, gridPtr);
    graphPtr->flags |= REDRAW_BACKING_STORE;
    Rbc_EventuallyRedrawGraph(graphPtr);
    return TCL_OK;
}

/*
 *----------------------------------------------------------------------
 *
 * MapOp --
 *
 *      Maps the grid.
 *
 * Results:
 *      A standard Tcl result.
 *
 * Side Effects:
 *      Grid attributes are reset and the graph is redrawn if necessary.
 *
 *----------------------------------------------------------------------
 */
static int
MapOp(graphPtr, interp, argc, argv)
    Graph *graphPtr;
    Tcl_Interp *interp;
    int argc;
    char **argv;
{
    Grid *gridPtr = (Grid *)graphPtr->gridPtr;

    if (gridPtr->hidden) {
        gridPtr->hidden = FALSE;/* Changes "-hide" configuration option */
        graphPtr->flags |= REDRAW_BACKING_STORE;
        Rbc_EventuallyRedrawGraph(graphPtr);
    }
    return TCL_OK;
}

/*
 *----------------------------------------------------------------------
 *
 * MapOp --
 *
 *      Maps or unmaps the grid (off or on).
 *
 * Results:
 *      A standard Tcl result.
 *
 * Side Effects:
 *      Grid attributes are reset and the graph is redrawn if necessary.
 *
 *----------------------------------------------------------------------
 */
static int
UnmapOp(graphPtr, interp, argc, argv)
    Graph *graphPtr;
    Tcl_Interp *interp;
    int argc;
    char **argv;
{
    Grid *gridPtr = (Grid *)graphPtr->gridPtr;

    if (!gridPtr->hidden) {
        gridPtr->hidden = TRUE;	/* Changes "-hide" configuration option */
        graphPtr->flags |= REDRAW_BACKING_STORE;
        Rbc_EventuallyRedrawGraph(graphPtr);
    }
    return TCL_OK;
}

/*
 *----------------------------------------------------------------------
 *
 * ToggleOp --
 *
 *      Toggles the state of the grid shown/hidden.
 *
 * Results:
 *      A standard Tcl result.
 *
 * Side Effects:
 *      Grid is hidden/displayed. The graph is redrawn at the next
 *      idle time.
 *
 *----------------------------------------------------------------------
 */
static int
ToggleOp(graphPtr, interp, argc, argv)
    Graph *graphPtr;
    Tcl_Interp *interp;
    int argc;
    char **argv;
{
    Grid *gridPtr = (Grid *)graphPtr->gridPtr;

    gridPtr->hidden = (!gridPtr->hidden);
    graphPtr->flags |= REDRAW_BACKING_STORE;
    Rbc_EventuallyRedrawGraph(graphPtr);
    return TCL_OK;
}


static Rbc_OpSpec gridOps[] = {
    {"cget", 2, (Rbc_Op)CgetOp, 4, 4, "option",},
    {"configure", 2, (Rbc_Op)ConfigureOp, 3, 0, "?options...?",},
    {"off", 2, (Rbc_Op)UnmapOp, 3, 3, "",},
    {"on", 2, (Rbc_Op)MapOp, 3, 3, "",},
    {"toggle", 1, (Rbc_Op)ToggleOp, 3, 3, "",},
};
static int nGridOps = sizeof(gridOps) / sizeof(Rbc_OpSpec);

/*
 *----------------------------------------------------------------------
 *
 * Rbc_GridOp --
 *
 *      User routine to configure grid lines.  Grids are drawn
 *      at major tick intervals across the graph.
 *
 * Results:
 *      The return value is a standard Tcl result.
 *
 * Side Effects:
 *      Grid may be drawn in the plotting area.
 *
 *----------------------------------------------------------------------
 */
int
Rbc_GridOp(graphPtr, interp, argc, argv)
    Graph *graphPtr;
    Tcl_Interp *interp;
    int argc;
    char **argv;
{
    Rbc_Op proc;

    proc = Rbc_GetOp(interp, nGridOps, gridOps, RBC_OP_ARG2, argc, argv, 0);
    if (proc == NULL) {
        return TCL_ERROR;
    }
    return (*proc) (graphPtr, interp, argc, argv);
}
