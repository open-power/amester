/*
 * rbcGrLegd.c --
 *
 *      This module implements the legend for the rbc graph widget.
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#include "rbcGraph.h"
#include "rbcGrElem.h"

/*
 * -------------------------------------------------------------------
 *
 * Legend --
 *
 *      Contains information specific to how the legend will be
 *      displayed.
 *
 * -------------------------------------------------------------------
 */
struct LegendStruct {
    unsigned int flags;
    Rbc_Uid classUid; /* Type: Element or Marker. */
    int hidden; /* If non-zero, don't display the legend. */
    int raised; /* If non-zero, draw the legend last, above
                 * everything else. */
    int nEntries; /* Number of element entries in table. */
    short int width, height; /* Dimensions of the legend */
    short int nColumns, nRows; /* Number of columns and rows in legend */
    int site;
    Point2D anchorPos; /* Says how to position the legend. Indicates
                        * the site and/or x-y screen coordinates of
                        * the legend.  Used in conjunction with the
                        * anchor to determine its location. */
    Tk_Anchor anchor; /* Anchor of legend. Used to interpret the
                       * positioning point of the legend in the
                       * graph*/
    int x, y; /* Computed origin of legend. */
    Graph *graphPtr;
    Tcl_Command cmdToken; /* Token for graph's widget command. */
    int reqColumns, reqRows;
    Rbc_Pad ipadX, ipadY; /* # of pixels padding around legend entries */
    Rbc_Pad padX, padY; /* # of pixels padding to exterior of legend */
    Tk_Window tkwin; /* Optional external window to draw legend. */
    TextStyle style;
    int maxSymSize; /* Size of largest symbol to be displayed.
                     * Used to calculate size of legend */
    Tk_3DBorder activeBorder; /* Active legend entry background color. */
    int activeRelief; /* 3-D effect on active entry. */
    int entryBorderWidth; /* Border width around each entry in legend. */
    Tk_3DBorder border; /* 3-D effect of legend. */
    int borderWidth; /* Width of legend 3-D border */
    int relief; /* 3-d effect of border around the legend:
                 * TK_RELIEF_RAISED etc. */
    Rbc_BindTable bindTable;
};

#define padLeft  	padX.side1
#define padRight  	padX.side2
#define padTop		padY.side1
#define padBottom	padY.side2
#define PADDING(x)	((x).side1 + (x).side2)

#define DEF_LEGEND_ACTIVE_BACKGROUND 	STD_ACTIVE_BACKGROUND
#define DEF_LEGEND_ACTIVE_BG_MONO	STD_ACTIVE_BG_MONO
#define DEF_LEGEND_ACTIVE_BORDERWIDTH  "2"
#define DEF_LEGEND_ACTIVE_FOREGROUND	STD_ACTIVE_FOREGROUND
#define DEF_LEGEND_ACTIVE_FG_MONO	STD_ACTIVE_FG_MONO
#define DEF_LEGEND_ACTIVE_RELIEF	"flat"
#define DEF_LEGEND_ANCHOR	   	"n"
#define DEF_LEGEND_BACKGROUND	   	(char *)NULL
#define DEF_LEGEND_BG_MONO		(char *)NULL
#define DEF_LEGEND_BORDERWIDTH 	STD_BORDERWIDTH
#define DEF_LEGEND_FOREGROUND		STD_NORMAL_FOREGROUND
#define DEF_LEGEND_FG_MONO		STD_NORMAL_FG_MONO
#define DEF_LEGEND_FONT			STD_FONT_SMALL
#define DEF_LEGEND_HIDE			"no"
#define DEF_LEGEND_IPAD_X		"1"
#define DEF_LEGEND_IPAD_Y		"1"
#define DEF_LEGEND_PAD_X		"1"
#define DEF_LEGEND_PAD_Y		"1"
#define DEF_LEGEND_POSITION		"rightmargin"
#define DEF_LEGEND_RAISED       	"no"
#define DEF_LEGEND_RELIEF		"sunken"
#define DEF_LEGEND_SHADOW_COLOR		(char *)NULL
#define DEF_LEGEND_SHADOW_MONO		(char *)NULL
#define DEF_LEGEND_ROWS			"0"
#define DEF_LEGEND_COLUMNS		"0"

static Tk_OptionParseProc StringToPosition;
static Tk_OptionPrintProc PositionToString;
static Tk_CustomOption legendPositionOption = {
    StringToPosition, PositionToString, (ClientData)0
};
extern Tk_CustomOption rbcDistanceOption;
extern Tk_CustomOption rbcPadOption;
extern Tk_CustomOption rbcShadowOption;
extern Tk_CustomOption rbcCountOption;

static Tk_ConfigSpec configSpecs[] = {
    {TK_CONFIG_BORDER, "-activebackground", "activeBackground", "ActiveBackground", DEF_LEGEND_ACTIVE_BACKGROUND, Tk_Offset(Legend, activeBorder), TK_CONFIG_COLOR_ONLY},
    {TK_CONFIG_BORDER, "-activebackground", "activeBackground", "ActiveBackground", DEF_LEGEND_ACTIVE_BG_MONO, Tk_Offset(Legend, activeBorder), TK_CONFIG_MONO_ONLY},
    {TK_CONFIG_CUSTOM, "-activeborderwidth", "activeBorderWidth", "BorderWidth", DEF_LEGEND_BORDERWIDTH, Tk_Offset(Legend, entryBorderWidth), TK_CONFIG_DONT_SET_DEFAULT, &rbcDistanceOption},
    {TK_CONFIG_COLOR, "-activeforeground", "activeForeground", "ActiveForeground", DEF_LEGEND_ACTIVE_FOREGROUND, Tk_Offset(Legend, style.activeColor), TK_CONFIG_COLOR_ONLY},
    {TK_CONFIG_COLOR, "-activeforeground", "activeForeground", "ActiveForeground", DEF_LEGEND_ACTIVE_FG_MONO, Tk_Offset(Legend, style.activeColor), TK_CONFIG_MONO_ONLY},
    {TK_CONFIG_RELIEF, "-activerelief", "activeRelief", "Relief", DEF_LEGEND_ACTIVE_RELIEF, Tk_Offset(Legend, activeRelief), TK_CONFIG_DONT_SET_DEFAULT},
    {TK_CONFIG_ANCHOR, "-anchor", "anchor", "Anchor", DEF_LEGEND_ANCHOR, Tk_Offset(Legend, anchor), TK_CONFIG_DONT_SET_DEFAULT},
    {TK_CONFIG_SYNONYM, "-bg", "background", (char *)NULL, (char *)NULL, 0, 0},
    {TK_CONFIG_BORDER, "-background", "background", "Background", DEF_LEGEND_BG_MONO, Tk_Offset(Legend, border), TK_CONFIG_NULL_OK | TK_CONFIG_MONO_ONLY},
    {TK_CONFIG_BORDER, "-background", "background", "Background", DEF_LEGEND_BACKGROUND, Tk_Offset(Legend, border), TK_CONFIG_NULL_OK | TK_CONFIG_COLOR_ONLY},
    {TK_CONFIG_CUSTOM, "-borderwidth", "borderWidth", "BorderWidth", DEF_LEGEND_BORDERWIDTH, Tk_Offset(Legend, borderWidth), TK_CONFIG_DONT_SET_DEFAULT, &rbcDistanceOption},
    {TK_CONFIG_SYNONYM, "-bd", "borderWidth", (char *)NULL, (char *)NULL, 0, 0},
    {TK_CONFIG_CUSTOM, "-columns", "columns", "columns", DEF_LEGEND_COLUMNS, Tk_Offset(Legend, reqColumns), TK_CONFIG_DONT_SET_DEFAULT, &rbcCountOption},
    {TK_CONFIG_FONT, "-font", "font", "Font", DEF_LEGEND_FONT, Tk_Offset(Legend, style.font), 0},
    {TK_CONFIG_SYNONYM, "-fg", "foreground", (char *)NULL, (char *)NULL, 0, 0},
    {TK_CONFIG_COLOR, "-foreground", "foreground", "Foreground", DEF_LEGEND_FOREGROUND, Tk_Offset(Legend, style.color), TK_CONFIG_COLOR_ONLY},
    {TK_CONFIG_COLOR, "-foreground", "foreground", "Foreground", DEF_LEGEND_FG_MONO, Tk_Offset(Legend, style.color), TK_CONFIG_MONO_ONLY},
    {TK_CONFIG_BOOLEAN, "-hide", "hide", "Hide", DEF_LEGEND_HIDE, Tk_Offset(Legend, hidden), TK_CONFIG_DONT_SET_DEFAULT},
    {TK_CONFIG_CUSTOM, "-ipadx", "iPadX", "Pad", DEF_LEGEND_IPAD_X, Tk_Offset(Legend, ipadX), TK_CONFIG_DONT_SET_DEFAULT, &rbcPadOption},
    {TK_CONFIG_CUSTOM, "-ipady", "iPadY", "Pad", DEF_LEGEND_IPAD_Y, Tk_Offset(Legend, ipadY), TK_CONFIG_DONT_SET_DEFAULT, &rbcPadOption},
    {TK_CONFIG_CUSTOM, "-padx", "padX", "Pad", DEF_LEGEND_PAD_X, Tk_Offset(Legend, padX), TK_CONFIG_DONT_SET_DEFAULT, &rbcPadOption},
    {TK_CONFIG_CUSTOM, "-pady", "padY", "Pad", DEF_LEGEND_PAD_Y, Tk_Offset(Legend, padY), TK_CONFIG_DONT_SET_DEFAULT, &rbcPadOption},
    {TK_CONFIG_CUSTOM, "-position", "position", "Position", DEF_LEGEND_POSITION, 0, TK_CONFIG_DONT_SET_DEFAULT, &legendPositionOption},
    {TK_CONFIG_BOOLEAN, "-raised", "raised", "Raised", DEF_LEGEND_RAISED, Tk_Offset(Legend, raised), TK_CONFIG_DONT_SET_DEFAULT},
    {TK_CONFIG_RELIEF, "-relief", "relief", "Relief", DEF_LEGEND_RELIEF, Tk_Offset(Legend, relief), TK_CONFIG_DONT_SET_DEFAULT},
    {TK_CONFIG_CUSTOM, "-rows", "rows", "rows", DEF_LEGEND_ROWS, Tk_Offset(Legend, reqRows), TK_CONFIG_DONT_SET_DEFAULT, &rbcCountOption},
    {TK_CONFIG_CUSTOM, "-shadow", "shadow", "Shadow", DEF_LEGEND_SHADOW_COLOR, Tk_Offset(Legend, style.shadow), TK_CONFIG_COLOR_ONLY, &rbcShadowOption},
    {TK_CONFIG_CUSTOM, "-shadow", "shadow", "Shadow", DEF_LEGEND_SHADOW_MONO, Tk_Offset(Legend, style.shadow), TK_CONFIG_MONO_ONLY, &rbcShadowOption},
    {TK_CONFIG_END, NULL, NULL, NULL, NULL, 0, 0}
};

static Tcl_IdleProc DisplayLegend;
static Rbc_BindPickProc PickLegendEntry;
static Tk_EventProc LegendEventProc;

static void EventuallyRedrawLegend _ANSI_ARGS_((Legend *legendPtr));
static int CreateLegendWindow _ANSI_ARGS_((Tcl_Interp *interp, Legend *legendPtr, char *pathName));
static void SetLegendOrigin _ANSI_ARGS_((Legend *legendPtr));
static void ConfigureLegend _ANSI_ARGS_((Graph *graphPtr, Legend *legendPtr));
static int GetOp _ANSI_ARGS_((Graph *graphPtr, Tcl_Interp *interp, int argc, char *argv[]));
static int ActivateOp _ANSI_ARGS_((Graph *graphPtr, Tcl_Interp *interp, int argc, char *argv[]));
static int BindOp _ANSI_ARGS_((Graph *graphPtr, Tcl_Interp *interp, int argc, char **argv));
static int CgetOp _ANSI_ARGS_((Graph *graphPtr, Tcl_Interp *interp, int argc, char **argv));
static int ConfigureOp _ANSI_ARGS_((Graph *graphPtr, Tcl_Interp *interp, int argc, char **argv));

/*
 *--------------------------------------------------------------
 *
 * EventuallyRedrawLegend --
 *
 *      Tells the Tk dispatcher to call the graph display routine at
 *      the next idle point.  This request is made only if the window
 *      is displayed and no other redraw request is pending.
 *
 * Results:
 *       None.
 *
 * Side effects:
 *      The window is eventually redisplayed.
 *
 *--------------------------------------------------------------
 */
static void
EventuallyRedrawLegend(legendPtr)
    Legend *legendPtr; /* Legend record */
{
    if ((legendPtr->tkwin != NULL) && !(legendPtr->flags & REDRAW_PENDING)) {
        Tcl_DoWhenIdle(DisplayLegend, legendPtr);
        legendPtr->flags |= REDRAW_PENDING;
    }
}

/*
 *--------------------------------------------------------------
 *
 * LegendEventProc --
 *
 *      This procedure is invoked by the Tk dispatcher for various
 *      events on graphs.
 *
 * Results:
 *      None.
 *
 * Side effects:
 *      When the window gets deleted, internal structures get
 *      cleaned up.  When it gets exposed, the graph is eventually
 *      redisplayed.
 *
 *--------------------------------------------------------------
 */
static void
LegendEventProc(clientData, eventPtr)
    ClientData clientData; /* Legend record */
    register XEvent *eventPtr; /* Event which triggered call to routine */
{
    Legend *legendPtr = clientData;

    if (eventPtr->type == Expose) {
        if (eventPtr->xexpose.count == 0) {
            EventuallyRedrawLegend(legendPtr);
        }
    } else if (eventPtr->type == DestroyNotify) {
        Graph *graphPtr = legendPtr->graphPtr;

        if (legendPtr->tkwin != graphPtr->tkwin) {
            Rbc_DeleteWindowInstanceData(legendPtr->tkwin);
            if (legendPtr->cmdToken != NULL) {
                Tcl_DeleteCommandFromToken(graphPtr->interp,
                                           legendPtr->cmdToken);
                legendPtr->cmdToken = NULL;
            }
            legendPtr->tkwin = graphPtr->tkwin;
        }
        if (legendPtr->flags & REDRAW_PENDING) {
            Tcl_CancelIdleCall(DisplayLegend, legendPtr);
            legendPtr->flags &= ~REDRAW_PENDING;
        }
        legendPtr->site = LEGEND_RIGHT;
        graphPtr->flags |= (MAP_WORLD | REDRAW_WORLD);
        Rbc_MoveBindingTable(legendPtr->bindTable, graphPtr->tkwin);
        Rbc_EventuallyRedrawGraph(graphPtr);
    } else if (eventPtr->type == ConfigureNotify) {
        EventuallyRedrawLegend(legendPtr);
    }
}

/*
 *----------------------------------------------------------------------
 *
 * CreateLegendWindow --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
static int
CreateLegendWindow(interp, legendPtr, pathName)
    Tcl_Interp *interp;
    Legend *legendPtr;
    char *pathName;
{
    Tk_Window tkwin;

    tkwin = Tk_MainWindow(interp);
    tkwin = Tk_CreateWindowFromPath(interp, tkwin, pathName, NULL);
    if (tkwin == NULL) {
        return TCL_ERROR;
    }
    Rbc_SetWindowInstanceData(tkwin, legendPtr);
    Tk_CreateEventHandler(tkwin, ExposureMask | StructureNotifyMask,
                          LegendEventProc, legendPtr);
    /* Move the legend's binding table to the new window. */
    Rbc_MoveBindingTable(legendPtr->bindTable, tkwin);
    if (legendPtr->tkwin != legendPtr->graphPtr->tkwin) {
        Tk_DestroyWindow(legendPtr->tkwin);
    }
    legendPtr->cmdToken = Tcl_CreateCommand(interp, pathName, Rbc_GraphInstCmdProc, legendPtr->graphPtr, NULL);
    legendPtr->tkwin = tkwin;
    legendPtr->site = LEGEND_WINDOW;
    return TCL_OK;
}

/*
 *----------------------------------------------------------------------
 *
 * StringToPosition --
 *
 *      Convert the string representation of a legend XY position into
 *      window coordinates.  The form of the string must be "@x,y" or
 *      none.
 *
 * Results:
 *      The return value is a standard Tcl result.  The symbol type is
 *      written into the widget record.
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
static int
StringToPosition(clientData, interp, tkwin, string, widgRec, offset)
    ClientData clientData; /* Not used. */
    Tcl_Interp *interp; /* Interpreter to send results back to */
    Tk_Window tkwin; /* Not used. */
    CONST84 char *string; /* New legend position string */
    char *widgRec; /* Widget record */
    int offset; /* offset to XPoint structure */
{
    Legend *legendPtr = (Legend *)widgRec;
    char c;
    unsigned int length;

    c = string[0];
    length = strlen(string);

    if ((string == NULL) || (*string == '\0')) {
        legendPtr->site = LEGEND_RIGHT;
    } else if ((c == 'l') && (strncmp(string, "leftmargin", length) == 0)) {
        legendPtr->site = LEGEND_LEFT;
    } else if ((c == 'r') && (strncmp(string, "rightmargin", length) == 0)) {
        legendPtr->site = LEGEND_RIGHT;
    } else if ((c == 't') && (strncmp(string, "topmargin", length) == 0)) {
        legendPtr->site = LEGEND_TOP;
    } else if ((c == 'b') && (strncmp(string, "bottommargin", length) == 0)) {
        legendPtr->site = LEGEND_BOTTOM;
    } else if ((c == 'p') && (strncmp(string, "plotarea", length) == 0)) {
        legendPtr->site = LEGEND_PLOT;
    } else if (c == '@') {
        char *comma;
        long x, y;
        int result;

        comma = strchr(string + 1, ',');
        if (comma == NULL) {
            Tcl_AppendResult(interp, "bad screen position \"", string,
                             "\": should be @x,y", (char *)NULL);
            return TCL_ERROR;
        }
        x = y = 0;
        *comma = '\0';
        result = ((Tcl_ExprLong(interp, string + 1, &x) == TCL_OK) &&
                  (Tcl_ExprLong(interp, comma + 1, &y) == TCL_OK));
        *comma = ',';
        if (!result) {
            return TCL_ERROR;
        }
        legendPtr->anchorPos.x = (int)x;
        legendPtr->anchorPos.y = (int)y;
        legendPtr->site = LEGEND_XY;
    } else if (c == '.') {
        if (legendPtr->tkwin != legendPtr->graphPtr->tkwin) {
            Tk_DestroyWindow(legendPtr->tkwin);
            legendPtr->tkwin = legendPtr->graphPtr->tkwin;
        }
        if (CreateLegendWindow(interp, legendPtr, string) != TCL_OK) {
            return TCL_ERROR;
        }
        legendPtr->site = LEGEND_WINDOW;
    } else {
        Tcl_AppendResult(interp, "bad position \"", string, "\": should be  \
\"leftmargin\", \"rightmargin\", \"topmargin\", \"bottommargin\", \
\"plotarea\", .window or @x,y", (char *)NULL);
        return TCL_ERROR;
    }
    return TCL_OK;
}

/*
 *----------------------------------------------------------------------
 *
 * PositionToString --
 *
 *      Convert the window coordinates into a string.
 *
 * Results:
 *      The string representing the coordinate position is returned.
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
static char *
PositionToString(clientData, tkwin, widgRec, offset, freeProcPtr)
    ClientData clientData; /* Not used. */
    Tk_Window tkwin; /* Not used. */
    char *widgRec; /* Widget record */
    int offset; /* offset of XPoint in record */
    Tcl_FreeProc **freeProcPtr; /* Memory deallocation scheme to use */
{
    Legend *legendPtr = (Legend *)widgRec;

    switch (legendPtr->site) {
        case LEGEND_LEFT:
            return "leftmargin";
        case LEGEND_RIGHT:
            return "rightmargin";
        case LEGEND_TOP:
            return "topmargin";
        case LEGEND_BOTTOM:
            return "bottommargin";
        case LEGEND_PLOT:
            return "plotarea";
        case LEGEND_WINDOW:
            return Tk_PathName(legendPtr->tkwin);
        case LEGEND_XY: {
                char string[200];
                char *result;

                sprintf(string, "@%d,%d", (int)legendPtr->anchorPos.x,
                        (int)legendPtr->anchorPos.y);
                result = RbcStrdup(string);
                *freeProcPtr = (Tcl_FreeProc *)Tcl_Free;
                return result;
            }
        default:
            return "unknown legend position";
    }
}

/*
 *----------------------------------------------------------------------
 *
 * SetLegendOrigin --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
static void
SetLegendOrigin(legendPtr)
    Legend *legendPtr;
{
    Graph *graphPtr;
    int x, y, width, height;

    graphPtr = legendPtr->graphPtr;
    x = y = width = height = 0;		/* Suppress compiler warning. */
    switch (legendPtr->site) {
        case LEGEND_RIGHT:
            width = graphPtr->rightMargin.width - graphPtr->rightMargin.axesOffset;
            height = graphPtr->bottom - graphPtr->top;
            x = graphPtr->width - (width + graphPtr->inset);
            y = graphPtr->top;
            break;
        case LEGEND_LEFT:
            width = graphPtr->leftMargin.width - graphPtr->leftMargin.axesOffset;
            height = graphPtr->bottom - graphPtr->top;
            x = graphPtr->inset;
            y = graphPtr->top;
            break;
        case LEGEND_TOP:
            width = graphPtr->right - graphPtr->left;
            height = graphPtr->topMargin.height - graphPtr->topMargin.axesOffset;
            if (graphPtr->title != NULL) {
                height -= graphPtr->titleTextStyle.height;
            }
            x = graphPtr->left;
            y = graphPtr->inset;
            if (graphPtr->title != NULL) {
                y += graphPtr->titleTextStyle.height;
            }
            break;
        case LEGEND_BOTTOM:
            width = graphPtr->right - graphPtr->left;
            height = graphPtr->bottomMargin.height -
                     graphPtr->bottomMargin.axesOffset;
            x = graphPtr->left;
            y = graphPtr->height - (height + graphPtr->inset);
            break;
        case LEGEND_PLOT:
            width = graphPtr->right - graphPtr->left;
            height = graphPtr->bottom - graphPtr->top;
            x = graphPtr->left;
            y = graphPtr->top;
            break;
        case LEGEND_XY:
            width = legendPtr->width;
            height = legendPtr->height;
            x = (int)legendPtr->anchorPos.x;
            y = (int)legendPtr->anchorPos.y;
            if (x < 0) {
                x += graphPtr->width;
            }
            if (y < 0) {
                y += graphPtr->height;
            }
            break;
        case LEGEND_WINDOW:
            legendPtr->anchor = TK_ANCHOR_NW;
            legendPtr->x = legendPtr->y = 0;
            return;
    }
    width = legendPtr->width - width;
    height = legendPtr->height - height;
    Rbc_TranslateAnchor(x, y, width, height, legendPtr->anchor, &x, &y);

    legendPtr->x = x + legendPtr->padLeft;
    legendPtr->y = y + legendPtr->padTop;
}


/*
 *----------------------------------------------------------------------
 *
 * PickLegendEntry --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
static ClientData
PickLegendEntry(clientData, x, y, contextPtr)
    ClientData clientData;
    int x, y; /* Point to be tested */
    ClientData *contextPtr; /* Not used. */
{
    Graph *graphPtr = clientData;
    Legend *legendPtr;
    int width, height;

    legendPtr = graphPtr->legend;
    width = legendPtr->width;
    height = legendPtr->height;

    x -= legendPtr->x + legendPtr->borderWidth;
    y -= legendPtr->y + legendPtr->borderWidth;
    width -= 2 * legendPtr->borderWidth + PADDING(legendPtr->padX);
    height -= 2 * legendPtr->borderWidth + PADDING(legendPtr->padY);

    if ((x >= 0) && (x < width) && (y >= 0) && (y < height)) {
        int row, column;
        int n;

        /*
         * It's in the bounding box, so compute the index.
         */
        row = y / legendPtr->style.height;
        column = x / legendPtr->style.width;
        n = (column * legendPtr->nRows) + row;
        if (n < legendPtr->nEntries) {
            Rbc_ChainLink *linkPtr;
            Element *elemPtr;
            int count;

            /* Legend entries are stored in reverse. */
            count = 0;
            for (linkPtr = Rbc_ChainLastLink(graphPtr->elements.displayList);
                    linkPtr != NULL; linkPtr = Rbc_ChainPrevLink(linkPtr)) {
                elemPtr = Rbc_ChainGetValue(linkPtr);
                if (elemPtr->label != NULL) {
                    if (count == n) {
                        return elemPtr;
                    }
                    count++;
                }
            }
            if (linkPtr != NULL) {
                return Rbc_ChainGetValue(linkPtr);
            }
        }
    }
    return NULL;
}

/*
 * -----------------------------------------------------------------
 *
 * Rbc_MapLegend --
 *
 *      Calculates the dimensions (width and height) needed for
 *      the legend.  Also determines the number of rows and columns
 *      necessary to list all the valid element labels.
 *
 * Results:
 *      None.
 *
 * Side effects:
 *      The following fields of the legend are calculated and set.
 *
 *      nEntries   - number of valid labels of elements in the
 *      	      display list.
 *      nRows	    - number of rows of entries
 *      nColumns    - number of columns of entries
 *      style.height - height of each entry
 *      style.width  - width of each entry
 *      height	    - width of legend (includes borders and padding)
 *      width	    - height of legend (includes borders and padding)
 *
 * -----------------------------------------------------------------
 */
void
Rbc_MapLegend(legendPtr, plotWidth, plotHeight)
    Legend *legendPtr;
    int plotWidth; /* Maximum width available in window
                    * to draw the legend. Will calculate number
                    * of columns from this. */
    int plotHeight; /* Maximum height available in window
                     * to draw the legend. Will calculate number
                     * of rows from this. */
{
    Rbc_ChainLink *linkPtr;
    Element *elemPtr;
    int nRows, nColumns, nEntries;
    int legendWidth, legendHeight;
    int entryWidth, entryHeight;
    int symbolWidth;
    Tk_FontMetrics fontMetrics;

    /* Initialize legend values to default (no legend displayed) */

    legendPtr->style.width = legendPtr->style.height = 0;
    legendPtr->nRows = legendPtr->nColumns = 0;
    legendPtr->nEntries = 0;
    legendPtr->height = legendPtr->width = 0;

    if (legendPtr->site == LEGEND_WINDOW) {
        if (Tk_Width(legendPtr->tkwin) > 1) {
            plotWidth = Tk_Width(legendPtr->tkwin);
        }
        if (Tk_Height(legendPtr->tkwin) > 1) {
            plotHeight = Tk_Height(legendPtr->tkwin);
        }
    }
    if ((legendPtr->hidden) || (plotWidth < 1) || (plotHeight < 1)) {
        return;			/* Legend is not being displayed */
    }

    /*
     * Count the number of legend entries and determine the widest and
     * tallest label.  The number of entries would normally be the
     * number of elements, but 1) elements can be hidden and 2)
     * elements can have no legend entry (-label "").
     */
    nEntries = 0;
    entryWidth = entryHeight = 0;
    for (linkPtr = Rbc_ChainLastLink(legendPtr->graphPtr->elements.displayList);
            linkPtr != NULL; linkPtr = Rbc_ChainPrevLink(linkPtr)) {
        int width, height;

        elemPtr = Rbc_ChainGetValue(linkPtr);
        if (elemPtr->label == NULL) {
            continue;		/* Element has no legend entry. */
        }
        Rbc_GetTextExtents(&legendPtr->style, elemPtr->label, &width, &height);
        if (entryWidth < width) {
            entryWidth = width;
        }
        if (entryHeight < height) {
            entryHeight = height;
        }
        nEntries++;
    }

    if (nEntries == 0) {
        return;			/* No legend entries. */
    }


    Tk_GetFontMetrics(legendPtr->style.font, &fontMetrics);
    symbolWidth = 2 * fontMetrics.ascent;

    entryWidth += 2 * legendPtr->entryBorderWidth + PADDING(legendPtr->ipadX) +
                  5 + symbolWidth;
    entryHeight += 2 * legendPtr->entryBorderWidth + PADDING(legendPtr->ipadY);

    legendWidth = plotWidth - 2 * legendPtr->borderWidth -
                  PADDING(legendPtr->padX);
    legendHeight = plotHeight - 2 * legendPtr->borderWidth -
                   PADDING(legendPtr->padY);

    /*
     * The number of rows and columns is computed as one of the following:
     *
     *	both options set		User defined.
     *  -rows				Compute columns from rows.
     *  -columns			Compute rows from columns.
     *	neither set			Compute rows and columns from
     *					size of plot.
     */
    if (legendPtr->reqRows > 0) {
        nRows = legendPtr->reqRows;
        if (nRows > nEntries) {
            nRows = nEntries;
        }
        if (legendPtr->reqColumns > 0) {
            nColumns = legendPtr->reqColumns;
            if (nColumns > nEntries) {
                nColumns = nEntries; /* Both -rows, -columns set. */
            }
        } else {
            nColumns = ((nEntries - 1) / nRows) + 1; /* Only -rows. */
        }
    } else if (legendPtr->reqColumns > 0) { /* Only -columns. */
        nColumns = legendPtr->reqColumns;
        if (nColumns > nEntries) {
            nColumns = nEntries;
        }
        nRows = ((nEntries - 1) / nColumns) + 1;
    } else {
        /* Compute # of rows and columns from the legend size. */
        nRows = legendHeight / entryHeight;
        nColumns = legendWidth / entryWidth;

        if (nRows > nEntries) {
            nRows = nEntries;
        } else if (nRows < 1) {
            nRows = 1;
        }
        if (nColumns > nEntries) {
            nColumns = nEntries;
        } else if (nColumns < 1) {
            nColumns = 1;
        }
        if ((legendPtr->site == LEGEND_TOP) ||
                (legendPtr->site == LEGEND_BOTTOM)) {
            nRows = ((nEntries - 1) / nColumns) + 1;
        } else {
            nColumns = ((nEntries - 1) / nRows) + 1;
        }
    }
    if (nRows < 1) {
        nRows = 1;
    }
    if (nColumns < 1) {
        nColumns = 1;
    }
    legendWidth = 2 * legendPtr->borderWidth + PADDING(legendPtr->padX);
    legendHeight = 2 * legendPtr->borderWidth + PADDING(legendPtr->padY);
    legendHeight += nRows * entryHeight;
    legendWidth += nColumns * entryWidth;

    legendPtr->height = legendHeight;
    legendPtr->width = legendWidth;
    legendPtr->nRows = nRows;
    legendPtr->nColumns = nColumns;
    legendPtr->nEntries = nEntries;
    legendPtr->style.height = entryHeight;
    legendPtr->style.width = entryWidth;

    if ((legendPtr->tkwin != legendPtr->graphPtr->tkwin) &&
            ((Tk_ReqWidth(legendPtr->tkwin) != legendWidth) ||
             (Tk_ReqHeight(legendPtr->tkwin) != legendHeight))) {
        Tk_GeometryRequest(legendPtr->tkwin, legendWidth, legendHeight);
    }
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_DrawLegend --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_DrawLegend(legendPtr, drawable)
    Legend *legendPtr;
    Drawable drawable; /* Pixmap or window to draw into */
{
    Graph *graphPtr;
    Rbc_ChainLink *linkPtr;
    Pixmap pixmap;
    Tk_3DBorder border;
    Tk_FontMetrics fontMetrics;
    Tk_Window tkwin;
    int count;
    int labelX, startY, symbolX, symbolY;
    int symbolSize, midX, midY;
    int width, height;
    int x, y;
    register Element *elemPtr;

    graphPtr = legendPtr->graphPtr;
    graphPtr->flags &= ~DRAW_LEGEND;
    if ((legendPtr->hidden) || (legendPtr->nEntries == 0)) {
        return;
    }
    SetLegendOrigin(legendPtr);

    if (legendPtr->tkwin != graphPtr->tkwin) {
        tkwin = legendPtr->tkwin;
        width = Tk_Width(tkwin);
        if (width < 1) {
            width = legendPtr->width;
        }
        height = Tk_Height(tkwin);
        if (height < 1) {
            height = legendPtr->height;
        }
    } else {
        width = legendPtr->width;
        height = legendPtr->height;
    }
    Tk_GetFontMetrics(legendPtr->style.font, &fontMetrics);

    symbolSize = fontMetrics.ascent;
    midX = symbolSize + 1 + legendPtr->entryBorderWidth;
    midY = (symbolSize / 2) + 1 + legendPtr->entryBorderWidth;
    labelX = 2 * symbolSize + legendPtr->entryBorderWidth +
             legendPtr->ipadX.side1 + 5;
    symbolY = midY + legendPtr->ipadY.side1;
    symbolX = midX + legendPtr->ipadX.side1;

    pixmap = Tk_GetPixmap(graphPtr->display, Tk_WindowId(legendPtr->tkwin),
                          width, height, Tk_Depth(legendPtr->tkwin));

    if (legendPtr->border != NULL) {
        /* Background color and relief. */
        Rbc_Fill3DRectangle(legendPtr->tkwin, pixmap, legendPtr->border, 0, 0,
                            width, height, 0, TK_RELIEF_FLAT);
    } else if (legendPtr->site & LEGEND_IN_PLOT) {
        /*
         * Legend background is transparent and is positioned over the
         * the plot area.  Either copy the part of the background from
         * the backing store pixmap or (if no backing store exists)
         * just fill it with the background color of the plot.
         */
        if (graphPtr->backPixmap != None) {
            XCopyArea(graphPtr->display, graphPtr->backPixmap, pixmap,
                      graphPtr->drawGC, legendPtr->x, legendPtr->y, width, height,
                      0, 0);
        } else {
            XFillRectangle(graphPtr->display, pixmap, graphPtr->plotFillGC,
                           0, 0, width, height);
        }
    } else {
        /*
         * The legend is positioned in one of the margins or the
         * external window.  Draw either the solid or tiled background
         * with the the border.
         */
        if (graphPtr->tile != NULL) {
            Rbc_SetTileOrigin(legendPtr->tkwin, graphPtr->tile, legendPtr->x,
                              legendPtr->y);
            Rbc_TileRectangle(legendPtr->tkwin, pixmap, graphPtr->tile, 0, 0,
                              width, height);
        } else {
            XFillRectangle(graphPtr->display, pixmap, graphPtr->fillGC, 0, 0,
                           width, height);
        }
    }
    x = legendPtr->padLeft + legendPtr->borderWidth;
    y = legendPtr->padTop + legendPtr->borderWidth;
    count = 0;
    startY = y;
    for (linkPtr = Rbc_ChainLastLink(graphPtr->elements.displayList);
            linkPtr != NULL; linkPtr = Rbc_ChainPrevLink(linkPtr)) {
        elemPtr = Rbc_ChainGetValue(linkPtr);
        if (elemPtr->label == NULL) {
            continue;		/* Skip this entry */
        }
        if (elemPtr->flags & LABEL_ACTIVE) {
            legendPtr->style.state |= STATE_ACTIVE;
            Rbc_Fill3DRectangle(legendPtr->tkwin, pixmap,
                                legendPtr->activeBorder, x, y,
                                legendPtr->style.width, legendPtr->style.height,
                                legendPtr->entryBorderWidth, legendPtr->activeRelief);
        } else {
            legendPtr->style.state &= ~STATE_ACTIVE;
            if (elemPtr->labelRelief != TK_RELIEF_FLAT) {
                Rbc_Draw3DRectangle(legendPtr->tkwin, pixmap, graphPtr->border,
                                    x, y, legendPtr->style.width, legendPtr->style.height,
                                    legendPtr->entryBorderWidth, elemPtr->labelRelief);
            }
        }
        (*elemPtr->procsPtr->drawSymbolProc) (graphPtr, pixmap, elemPtr,
                                              x + symbolX, y + symbolY, symbolSize);
        Rbc_DrawText(legendPtr->tkwin, pixmap, elemPtr->label,
                     &legendPtr->style, x + labelX,
                     y + legendPtr->entryBorderWidth + legendPtr->ipadY.side1);
        count++;

        /* Check when to move to the next column */
        if ((count % legendPtr->nRows) > 0) {
            y += legendPtr->style.height;
        } else {
            x += legendPtr->style.width;
            y = startY;
        }
    }
    /*
     * Draw the border and/or background of the legend.
     */
    border = legendPtr->border;
    if (border == NULL) {
        border = graphPtr->border;
    }
    Rbc_Draw3DRectangle(legendPtr->tkwin, pixmap, border, 0, 0, width, height,
                        legendPtr->borderWidth, legendPtr->relief);

    XCopyArea(graphPtr->display, pixmap, drawable, graphPtr->drawGC, 0, 0,
              width, height, legendPtr->x, legendPtr->y);
    Tk_FreePixmap(graphPtr->display, pixmap);
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_LegendToPostScript --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_LegendToPostScript(legendPtr, psToken)
    Legend *legendPtr;
    PsToken psToken;
{
    Graph *graphPtr;
    double x, y, startY;
    Element *elemPtr;
    int labelX, symbolX, symbolY;
    int count;
    Rbc_ChainLink *linkPtr;
    int symbolSize, midX, midY;
    int width, height;
    Tk_FontMetrics fontMetrics;

    if ((legendPtr->hidden) || (legendPtr->nEntries == 0)) {
        return;
    }
    SetLegendOrigin(legendPtr);

    x = legendPtr->x, y = legendPtr->y;
    width = legendPtr->width - PADDING(legendPtr->padX);
    height = legendPtr->height - PADDING(legendPtr->padY);

    graphPtr = legendPtr->graphPtr;
    if (graphPtr->postscript->decorations) {
        if (legendPtr->border != NULL) {
            Rbc_Fill3DRectangleToPostScript(psToken, legendPtr->border, x, y,
                                            width, height, legendPtr->borderWidth, legendPtr->relief);
        } else {
            Rbc_Draw3DRectangleToPostScript(psToken, graphPtr->border, x, y,
                                            width, height, legendPtr->borderWidth, legendPtr->relief);
        }
    } else {
        Rbc_ClearBackgroundToPostScript(psToken);
        Rbc_RectangleToPostScript(psToken, x, y, width, height);
    }
    x += legendPtr->borderWidth;
    y += legendPtr->borderWidth;

    Tk_GetFontMetrics(legendPtr->style.font, &fontMetrics);
    symbolSize = fontMetrics.ascent;
    midX = symbolSize + 1 + legendPtr->entryBorderWidth;
    midY = (symbolSize / 2) + 1 + legendPtr->entryBorderWidth;
    labelX = 2 * symbolSize + legendPtr->entryBorderWidth +
             legendPtr->ipadX.side1 + 5;
    symbolY = midY + legendPtr->ipadY.side1;
    symbolX = midX + legendPtr->ipadX.side1;

    count = 0;
    startY = y;
    for (linkPtr = Rbc_ChainLastLink(graphPtr->elements.displayList);
            linkPtr != NULL; linkPtr = Rbc_ChainPrevLink(linkPtr)) {
        elemPtr = Rbc_ChainGetValue(linkPtr);
        if (elemPtr->label == NULL) {
            continue;		/* Skip this label */
        }
        if (elemPtr->flags & LABEL_ACTIVE) {
            legendPtr->style.state |= STATE_ACTIVE;
            Rbc_Fill3DRectangleToPostScript(psToken, legendPtr->activeBorder,
                                            x, y, legendPtr->style.width, legendPtr->style.height,
                                            legendPtr->entryBorderWidth, legendPtr->activeRelief);
        } else {
            legendPtr->style.state &= ~STATE_ACTIVE;
            if (elemPtr->labelRelief != TK_RELIEF_FLAT) {
                Rbc_Draw3DRectangleToPostScript(psToken, graphPtr->border,
                                                x, y, legendPtr->style.width, legendPtr->style.height,
                                                legendPtr->entryBorderWidth, elemPtr->labelRelief);
            }
        }
        (*elemPtr->procsPtr->printSymbolProc) (graphPtr, psToken, elemPtr,
                                               x + symbolX, y + symbolY, symbolSize);
        Rbc_TextToPostScript(psToken, elemPtr->label, &(legendPtr->style),
                             x + labelX,
                             y + legendPtr->entryBorderWidth + legendPtr->ipadY.side1);
        count++;
        if ((count % legendPtr->nRows) > 0) {
            y += legendPtr->style.height;
        } else {
            x += legendPtr->style.width;
            y = startY;
        }
    }
}

/*
 *----------------------------------------------------------------------
 *
 * DisplayLegend --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
static void
DisplayLegend(clientData)
    ClientData clientData;
{
    Legend *legendPtr = clientData;
    int width, height;

    legendPtr->flags &= ~REDRAW_PENDING;

    if (legendPtr->tkwin == NULL) {
        return;			/* Window has been destroyed. */
    }
    if (legendPtr->site == LEGEND_WINDOW) {
        width = Tk_Width(legendPtr->tkwin);
        height = Tk_Height(legendPtr->tkwin);
        if ((width <= 1) || (height <= 1)) {
            return;
        }
        if ((width != legendPtr->width) || (height != legendPtr->height)) {
            Rbc_MapLegend(legendPtr, width, height);
        }
    }
    if (!Tk_IsMapped(legendPtr->tkwin)) {
        return;
    }
    Rbc_DrawLegend(legendPtr, Tk_WindowId(legendPtr->tkwin));
}

/*
 *----------------------------------------------------------------------
 *
 * ConfigureLegend --
 *
 *      Routine to configure the legend.
 *
 * Results:
 *      A standard Tcl result.
 *
 * Side Effects:
 *      Graph will be redrawn to reflect the new legend attributes.
 *
 *----------------------------------------------------------------------
 */
static void
ConfigureLegend(graphPtr, legendPtr)
    Graph *graphPtr;
    Legend *legendPtr;
{
    Rbc_ResetTextStyle(graphPtr->tkwin, &(legendPtr->style));

    if (legendPtr->site == LEGEND_WINDOW) {
        EventuallyRedrawLegend(legendPtr);
    } else {
        /*
         *  Update the layout of the graph (and redraw the elements) if
         *  any of the following legend options (all of which affect the
         *	size of the legend) have changed.
         *
         *		-activeborderwidth, -borderwidth
         *		-border
         *		-font
         *		-hide
         *		-ipadx, -ipady, -padx, -pady
         *		-rows
         *
         *  If the position of the legend changed to/from the default
         *  position, also indicate that a new layout is needed.
         *
         */
        if (Rbc_ConfigModified(configSpecs, "-*border*", "-*pad?",
                               "-position", "-hide", "-font", "-rows", (char *)NULL)) {
            graphPtr->flags |= MAP_WORLD;
        }
        graphPtr->flags |= (REDRAW_WORLD | REDRAW_BACKING_STORE);
        Rbc_EventuallyRedrawGraph(graphPtr);
    }
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_DestroyLegend --
 *
 *      TODO: Description
 *
 * Results:
 *      None.
 *
 * Side effects:
 *      Resources associated with the legend are freed.
 *
 *----------------------------------------------------------------------
 */
void
Rbc_DestroyLegend(graphPtr)
    Graph *graphPtr;
{
    Legend *legendPtr = graphPtr->legend;

    Tk_FreeOptions(configSpecs, (char *)legendPtr, graphPtr->display, 0);
    Rbc_FreeTextStyle(graphPtr->display, &(legendPtr->style));
    Rbc_DestroyBindingTable(legendPtr->bindTable);
    if (legendPtr->tkwin != graphPtr->tkwin) {
        Tk_Window tkwin;

        /* The graph may be in the process of being torn down */
        if (legendPtr->cmdToken != NULL) {
            Tcl_DeleteCommandFromToken(graphPtr->interp, legendPtr->cmdToken);
        }
        if (legendPtr->flags & REDRAW_PENDING) {
            Tcl_CancelIdleCall(DisplayLegend, legendPtr);
            legendPtr->flags &= ~REDRAW_PENDING;
        }
        tkwin = legendPtr->tkwin;
        legendPtr->tkwin = NULL;
        if (tkwin != NULL) {
            Tk_DeleteEventHandler(tkwin, ExposureMask | StructureNotifyMask,
                                  LegendEventProc, legendPtr);
            Rbc_DeleteWindowInstanceData(tkwin);
            Tk_DestroyWindow(tkwin);
        }
    }
    ckfree((char *)legendPtr);
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_CreateLegend --
 *
 *      Creates and initializes a legend structure with default settings
 *
 * Results:
 *      A standard Tcl result.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
int
Rbc_CreateLegend(graphPtr)
    Graph *graphPtr;
{
    Legend *legendPtr;

    legendPtr = RbcCalloc(1, sizeof(Legend));
    assert(legendPtr);
    graphPtr->legend = legendPtr;
    legendPtr->graphPtr = graphPtr;
    legendPtr->tkwin = graphPtr->tkwin;
    legendPtr->hidden = FALSE;
    legendPtr->anchorPos.x = legendPtr->anchorPos.y = -SHRT_MAX;
    legendPtr->relief = TK_RELIEF_SUNKEN;
    legendPtr->activeRelief = TK_RELIEF_FLAT;
    legendPtr->entryBorderWidth = legendPtr->borderWidth = 2;
    legendPtr->ipadX.side1 = legendPtr->ipadX.side2 = 1;
    legendPtr->ipadY.side1 = legendPtr->ipadY.side2 = 1;
    legendPtr->padX.side1 = legendPtr->padX.side2 = 1;
    legendPtr->padY.side1 = legendPtr->padY.side2 = 1;
    legendPtr->anchor = TK_ANCHOR_N;
    legendPtr->site = LEGEND_RIGHT;
    Rbc_InitTextStyle(&(legendPtr->style));
    legendPtr->style.justify = TK_JUSTIFY_LEFT;
    legendPtr->style.anchor = TK_ANCHOR_NW;
    legendPtr->bindTable = Rbc_CreateBindingTable(graphPtr->interp,
                           graphPtr->tkwin, graphPtr, PickLegendEntry, Rbc_GraphTags);

    if (Rbc_ConfigureWidgetComponent(graphPtr->interp, graphPtr->tkwin,
                                     "legend", "Legend", configSpecs, 0, (char **)NULL,
                                     (char *)legendPtr, 0) != TCL_OK) {
        return TCL_ERROR;
    }
    ConfigureLegend(graphPtr, legendPtr);
    return TCL_OK;
}

/*
 *----------------------------------------------------------------------
 *
 * GetOp --
 *
 *      Find the legend entry from the given argument.  The argument
 *      can be either a screen position "@x,y" or the name of an
 *      element.
 *
 *      I don't know how useful it is to test with the name of an
 *      element.
 *
 * Results:
 *      A standard Tcl result.
 *
 * Side Effects:
 *      Graph will be redrawn to reflect the new legend attributes.
 *
 *----------------------------------------------------------------------
 */
static int
GetOp(graphPtr, interp, argc, argv)
    Graph *graphPtr;
    Tcl_Interp *interp;
    int argc; /* Not used. */
    char *argv[];
{
    register Element *elemPtr;
    Legend *legendPtr = graphPtr->legend;
    int x, y;
    char c;

    if ((legendPtr->hidden) || (legendPtr->nEntries == 0)) {
        return TCL_OK;
    }
    elemPtr = NULL;
    c = argv[3][0];
    if ((c == 'c') && (strcmp(argv[3], "current") == 0)) {
        elemPtr = (Element *)Rbc_GetCurrentItem(legendPtr->bindTable);
    } else if ((c == '@') &&
               (Rbc_GetXY(interp, graphPtr->tkwin, argv[3], &x, &y) == TCL_OK)) {
        elemPtr = (Element *)PickLegendEntry(graphPtr, x, y, NULL);
    }
    if (elemPtr != NULL) {
        Tcl_SetResult(interp, elemPtr->name, TCL_VOLATILE);
    }
    return TCL_OK;
}

/*
 *----------------------------------------------------------------------
 *
 * ActivateOp --
 *
 *      Activates a particular label in the legend.
 *
 * Results:
 *      A standard Tcl result.
 *
 * Side Effects:
 *      Graph will be redrawn to reflect the new legend attributes.
 *
 *----------------------------------------------------------------------
 */
static int
ActivateOp(graphPtr, interp, argc, argv)
    Graph *graphPtr;
    Tcl_Interp *interp;
    int argc;
    char *argv[];
{
    Legend *legendPtr = graphPtr->legend;
    Element *elemPtr;
    unsigned int active, redraw;
    Tcl_HashEntry *hPtr;
    Tcl_HashSearch cursor;
    register int i;

    active = (argv[2][0] == 'a') ? LABEL_ACTIVE : 0;
    redraw = 0;
    for (hPtr = Tcl_FirstHashEntry(&(graphPtr->elements.table), &cursor);
            hPtr != NULL; hPtr = Tcl_NextHashEntry(&cursor)) {
        elemPtr = Tcl_GetHashValue(hPtr);
        for (i = 3; i < argc; i++) {
            if (Tcl_StringMatch(elemPtr->name, argv[i])) {
                break;
            }
        }
        if ((i < argc) && (active != (elemPtr->flags & LABEL_ACTIVE))) {
            elemPtr->flags ^= LABEL_ACTIVE;
            if (elemPtr->label != NULL) {
                redraw++;
            }
        }
    }
    if ((redraw) && (!legendPtr->hidden)) {
        /*
         * See if how much we need to draw. If the graph is already
         * schedule for a redraw, just make sure the right flags are
         * set.  Otherwise redraw only the legend: it's either in an
         * external window or it's the only thing that need updating.
         */
        if (graphPtr->flags & REDRAW_PENDING) {
            if (legendPtr->site & LEGEND_IN_PLOT) {
                graphPtr->flags |= REDRAW_BACKING_STORE;
            }
            graphPtr->flags |= REDRAW_WORLD; /* Redraw entire graph. */
        } else {
            EventuallyRedrawLegend(legendPtr);
        }
    }
    /* Return the names of all the active legend entries */
    for (hPtr = Tcl_FirstHashEntry(&(graphPtr->elements.table), &cursor);
            hPtr != NULL; hPtr = Tcl_NextHashEntry(&cursor)) {
        elemPtr = Tcl_GetHashValue(hPtr);
        if (elemPtr->flags & LABEL_ACTIVE) {
            Tcl_AppendElement(interp, elemPtr->name);
        }
    }
    return TCL_OK;
}

/*
 *----------------------------------------------------------------------
 *
 * BindOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
static int
BindOp(graphPtr, interp, argc, argv)
    Graph *graphPtr;
    Tcl_Interp *interp;
    int argc;
    char **argv;
{
    if (argc == 3) {
        Tcl_HashEntry *hPtr;
        Tcl_HashSearch cursor;
        char *tagName;

        for (hPtr = Tcl_FirstHashEntry(&(graphPtr->elements.tagTable), &cursor); hPtr != NULL; hPtr = Tcl_NextHashEntry(&cursor)) {
            tagName = Tcl_GetHashKey(&(graphPtr->elements.tagTable), hPtr);
            Tcl_AppendElement(interp, tagName);
        }
        return TCL_OK;
    }
    return Rbc_ConfigureBindings(interp, graphPtr->legend->bindTable, Rbc_MakeElementTag(graphPtr, argv[3]), argc - 4, argv + 4);
}

/*
 *----------------------------------------------------------------------
 *
 * CgetOp --
 *
 *      Queries or resets options for the legend.
 *
 * Results:
 *      A standard Tcl result.
 *
 * Side Effects:
 *      Graph will be redrawn to reflect the new legend attributes.
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
    return Tk_ConfigureValue(interp, graphPtr->tkwin, configSpecs,
                             (char *)graphPtr->legend, argv[3], 0);
}

/*
 *----------------------------------------------------------------------
 *
 * ConfigureOp --
 *
 *      Queries or resets options for the legend.
 *
 * Results:
 *      A standard Tcl result.
 *
 * Side Effects:
 *      Graph will be redrawn to reflect the new legend attributes.
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
    int flags = TK_CONFIG_ARGV_ONLY;
    Legend *legendPtr;

    legendPtr = graphPtr->legend;
    if (argc == 3) {
        return Tk_ConfigureInfo(interp, graphPtr->tkwin, configSpecs,
                                (char *)legendPtr, (char *)NULL, flags);
    } else if (argc == 4) {
        return Tk_ConfigureInfo(interp, graphPtr->tkwin, configSpecs,
                                (char *)legendPtr, argv[3], flags);
    }
    if (Tk_ConfigureWidget(interp, graphPtr->tkwin, configSpecs, argc - 3,
                           argv + 3, (char *)legendPtr, flags) != TCL_OK) {
        return TCL_ERROR;
    }
    ConfigureLegend(graphPtr, legendPtr);
    return TCL_OK;
}

static Rbc_OpSpec legendOps[] = {
    {"activate", 1, (Rbc_Op)ActivateOp, 3, 0, "?pattern?...",},
    {"bind", 1, (Rbc_Op)BindOp, 3, 6, "elemName sequence command",},
    {"cget", 2, (Rbc_Op)CgetOp, 4, 4, "option",},
    {"configure", 2, (Rbc_Op)ConfigureOp, 3, 0, "?option value?...",},
    {"deactivate", 1, (Rbc_Op)ActivateOp, 3, 0, "?pattern?...",},
    {"get", 1, (Rbc_Op)GetOp, 4, 4, "index",},
};
static int nLegendOps = sizeof(legendOps) / sizeof(Rbc_OpSpec);

/*
 *----------------------------------------------------------------------
 *
 * Rbc_LegendOp --
 *
 *      TODO: Description
 *
 * Results:
 *      A standard Tcl result.
 *
 * Side Effects:
 *      Legend is possibly redrawn.
 *
 *----------------------------------------------------------------------
 */
int
Rbc_LegendOp(graphPtr, interp, argc, argv)
    Graph *graphPtr;
    Tcl_Interp *interp;
    int argc;
    char **argv;
{
    Rbc_Op proc;
    int result;

    proc = Rbc_GetOp(interp, nLegendOps, legendOps, RBC_OP_ARG2, argc, argv,0);
    if (proc == NULL) {
        return TCL_ERROR;
    }
    result = (*proc) (graphPtr, interp, argc, argv);
    return result;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_LegendSite --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
int
Rbc_LegendSite(legendPtr)
    Legend *legendPtr;
{
    return legendPtr->site;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_LegendWidth --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
int
Rbc_LegendWidth(legendPtr)
    Legend *legendPtr;
{
    return legendPtr->width;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_LegendHeight --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
int
Rbc_LegendHeight(legendPtr)
    Legend *legendPtr;
{
    return legendPtr->height;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_LegendIsHidden --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
int
Rbc_LegendIsHidden(legendPtr)
    Legend *legendPtr;
{
    return legendPtr->hidden;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_LegendIsRaised --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
int
Rbc_LegendIsRaised(legendPtr)
    Legend *legendPtr;
{
    return legendPtr->raised;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_LegendX --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
int
Rbc_LegendX(legendPtr)
    Legend *legendPtr;
{
    return legendPtr->x;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_LegendY --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
int
Rbc_LegendY(legendPtr)
    Legend *legendPtr;
{
    return legendPtr->y;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_LegendRemoveElement --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_LegendRemoveElement(legendPtr, elemPtr)
    Legend *legendPtr;
    Element *elemPtr;
{
    Rbc_DeleteBindings(legendPtr->bindTable, elemPtr);
}
