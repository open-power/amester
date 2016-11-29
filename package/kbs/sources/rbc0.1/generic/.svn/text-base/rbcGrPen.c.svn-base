/*
 * rbcGrPen.c --
 *
 *      This module implements pens for the rbc graph widget.
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#include "rbcGraph.h"
#include <X11/Xutil.h>

static Tk_OptionParseProc StringToColor;
static Tk_OptionPrintProc ColorToString;
static Tk_OptionParseProc StringToPen;
static Tk_OptionPrintProc PenToString;
Tk_CustomOption rbcColorOption = {
    StringToColor, ColorToString, (ClientData)0
};
Tk_CustomOption rbcPenOption = {
    StringToPen, PenToString, (ClientData)0
};
Tk_CustomOption rbcBarPenOption = {
    StringToPen, PenToString, (ClientData)&rbcBarElementUid
};
Tk_CustomOption rbcLinePenOption = {
    StringToPen, PenToString, (ClientData)&rbcLineElementUid
};

static char *NameOfColor _ANSI_ARGS_((XColor *colorPtr));
static Pen *NameToPen _ANSI_ARGS_((Graph *graphPtr, char *name));
static int CgetOp _ANSI_ARGS_((Tcl_Interp *interp, Graph *graphPtr, int argc, char *argv[]));
static int ConfigureOp _ANSI_ARGS_((Tcl_Interp *interp, Graph *graphPtr, int argc, char *argv[]));
static int CreateOp _ANSI_ARGS_((Tcl_Interp *interp, Graph *graphPtr, int argc, char **argv));
static int DeleteOp _ANSI_ARGS_((Tcl_Interp *interp, Graph *graphPtr, int argc, char **argv));
static int NamesOp _ANSI_ARGS_((Tcl_Interp *interp, Graph *graphPtr, int argc, char **argv));
static int TypeOp _ANSI_ARGS_((Tcl_Interp *interp, Graph *graphPtr, int argc, char **argv));

/*
 *----------------------------------------------------------------------

 * StringToColor --
 *
 *      Convert the string representation of a color into a XColor pointer.
 *
 * Results:
 *      The return value is a standard Tcl result.  The color pointer is
 *      written into the widget record.
 *
 * Side Effects:
 *      TODO: Side Effects:
 *
 *----------------------------------------------------------------------
 */
static int
StringToColor(clientData, interp, tkwin, string, widgRec, offset)
    ClientData clientData; /* Not used. */
    Tcl_Interp *interp; /* Interpreter to send results back to */
    Tk_Window tkwin; /* Not used. */
    CONST84 char *string; /* String representing color */
    char *widgRec; /* Widget record */
    int offset; /* Offset of color field in record */
{
    XColor **colorPtrPtr = (XColor **)(widgRec + offset);
    XColor *colorPtr;
    unsigned int length;
    char c;

    if ((string == NULL) || (*string == '\0')) {
        *colorPtrPtr = NULL;
        return TCL_OK;
    }
    c = string[0];
    length = strlen(string);

    if ((c == 'd') && (strncmp(string, "defcolor", length) == 0)) {
        colorPtr = COLOR_DEFAULT;
    } else {
        colorPtr = Tk_GetColor(interp, tkwin, Tk_GetUid(string));
        if (colorPtr == NULL) {
            return TCL_ERROR;
        }
    }
    *colorPtrPtr = colorPtr;
    return TCL_OK;
}

/*
 *----------------------------------------------------------------------
 *
 * NameOfColor --
 *
 *      Convert the color option value into a string.
 *
 * Results:
 *      The static string representing the color option is returned.
 *
 * Side Effects:
 *      TODO: Side Effects:
 *
 *----------------------------------------------------------------------
 */
static char *
NameOfColor(colorPtr)
    XColor *colorPtr;
{
    if (colorPtr == NULL) {
        return "";
    } else if (colorPtr == COLOR_DEFAULT) {
        return "defcolor";
    } else {
        return Tk_NameOfColor(colorPtr);
    }
}

/*
 *----------------------------------------------------------------------
 *
 * ColorToString --
 *
 *      Convert the color value into a string.
 *
 * Results:
 *      The string representing the symbol color is returned.
 *
 * Side Effects:
 *      TODO: Side Effects:
 *
 *----------------------------------------------------------------------
 */
static char *
ColorToString(clientData, tkwin, widgRec, offset, freeProcPtr)
    ClientData clientData; /* Not used. */
    Tk_Window tkwin; /* Not used. */
    char *widgRec; /* Widget information record */
    int offset; /* Offset of symbol type in record */
    Tcl_FreeProc **freeProcPtr; /* Not used. */
{
    XColor *colorPtr = *(XColor **)(widgRec + offset);

    return NameOfColor(colorPtr);
}

/*
 *----------------------------------------------------------------------
 *
 * StringToPen --
 *
 *      Convert the color value into a string.
 *
 * Results:
 *      The string representing the symbol color is returned.
 *
 * Side Effects:
 *      TODO: Side Effects:
 *
 *----------------------------------------------------------------------
 */
static int
StringToPen(clientData, interp, tkwin, string, widgRec, offset)
    ClientData clientData; /* Not used. */
    Tcl_Interp *interp; /* Interpreter to send results back to */
    Tk_Window tkwin; /* Not used. */
    CONST84 char *string; /* String representing pen */
    char *widgRec; /* Widget record */
    int offset; /* Offset of pen field in record */
{
    Rbc_Uid classUid = *(Rbc_Uid *)clientData; /* Element type. */
    Pen **penPtrPtr = (Pen **)(widgRec + offset);
    Pen *penPtr;
    Graph *graphPtr;

    penPtr = NULL;
    graphPtr = Rbc_GetGraphFromWindowData(tkwin);

    if (classUid == NULL) {
        classUid = graphPtr->classUid;
    }
    if ((string != NULL) && (string[0] != '\0')) {
        if (Rbc_GetPen(graphPtr, string, classUid, &penPtr) != TCL_OK) {
            return TCL_ERROR;
        }
    }
    /* Release the old pen */
    if (*penPtrPtr != NULL) {
        Rbc_FreePen(graphPtr, *penPtrPtr);
    }
    *penPtrPtr = penPtr;
    return TCL_OK;
}

/*
 *----------------------------------------------------------------------
 *
 * PenToString --
 *
 *      Parse the name of the name.
 *
 * Results:
 *      The return value is a standard Tcl result.
 *
 * Side Effects:
 *      TODO: Side Effects:
 *
 *----------------------------------------------------------------------
 */
static char *
PenToString(clientData, tkwin, widgRec, offset, freeProcPtr)
    ClientData clientData; /* Not used. */
    Tk_Window tkwin; /* Not used. */
    char *widgRec; /* Widget information record */
    int offset; /* Offset of pen in record */
    Tcl_FreeProc **freeProcPtr; /* Not used. */
{
    Pen *penPtr = *(Pen **)(widgRec + offset);

    return penPtr->name;
}

/*
 *----------------------------------------------------------------------
 *
 * NameToPen --
 *
 *      Find and return the pen style from a given name.
 *
 * Results:
 *      A standard TCL result.
 *
 * Side Effects:
 *      TODO: Side Effects:
 *
 *----------------------------------------------------------------------
 */
static Pen *
NameToPen(graphPtr, name)
    Graph *graphPtr;
    char *name;
{
    Tcl_HashEntry *hPtr;
    Pen *penPtr;

    hPtr = Tcl_FindHashEntry(&(graphPtr->penTable), name);
    if (hPtr == NULL) {
notFound:
        Tcl_AppendResult(graphPtr->interp, "can't find pen \"", name,
                         "\" in \"", Tk_PathName(graphPtr->tkwin), "\"", (char *)NULL);
        return NULL;
    }
    penPtr = (Pen *)Tcl_GetHashValue(hPtr);
    if (penPtr->flags & PEN_DELETE_PENDING) {
        goto notFound;
    }
    return penPtr;
}

/*
 *----------------------------------------------------------------------
 *
 * DestroyPen --
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
DestroyPen(graphPtr, penPtr)
    Graph *graphPtr;
    Pen *penPtr;
{
    Tk_FreeOptions(penPtr->configSpecs, (char *)penPtr, graphPtr->display, 0);
    (*penPtr->destroyProc) (graphPtr, penPtr);
    if ((penPtr->name != NULL) && (penPtr->name[0] != '\0')) {
        ckfree((char *)penPtr->name);
    }
    if (penPtr->hashPtr != NULL) {
        Tcl_DeleteHashEntry(penPtr->hashPtr);
    }
    ckfree((char *)penPtr);
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_FreePen --
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
Rbc_FreePen(graphPtr, penPtr)
    Graph *graphPtr;
    Pen *penPtr;
{
    penPtr->refCount--;
    if ((penPtr->refCount == 0) && (penPtr->flags & PEN_DELETE_PENDING)) {
        DestroyPen(graphPtr, penPtr);
    }
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_CreatePen --
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
Pen *
Rbc_CreatePen(graphPtr, penName, classUid, nOpts, options)
    Graph *graphPtr;
    char *penName;
    Rbc_Uid classUid;
    int nOpts;
    char **options;
{

    Pen *penPtr;
    Tcl_HashEntry *hPtr;
    unsigned int length, configFlags;
    int isNew;
    register int i;

    /*
     * Scan the option list for a "-type" entry.  This will indicate
     * what type of pen we are creating. Otherwise we'll default to the
     * suggested type.  Last -type option wins.
     */
    for (i = 0; i < nOpts; i += 2) {
        length = strlen(options[i]);
        if ((length > 2) && (strncmp(options[i], "-type", length) == 0)) {
            char *arg;

            arg = options[i + 1];
            if (strcmp(arg, "bar") == 0) {
                classUid = rbcBarElementUid;
            } else if (strcmp(arg, "line") != 0) {
                classUid = rbcLineElementUid;
            } else if (strcmp(arg, "strip") != 0) {
                classUid = rbcLineElementUid;
            } else {
                Tcl_AppendResult(graphPtr->interp, "unknown pen type \"",
                                 arg, "\" specified", (char *)NULL);
                return NULL;
            }
        }
    }
    if (classUid == rbcStripElementUid) {
        classUid = rbcLineElementUid;
    }
    hPtr = Tcl_CreateHashEntry(&(graphPtr->penTable), penName, &isNew);
    if (!isNew) {
        penPtr = (Pen *)Tcl_GetHashValue(hPtr);
        if (!(penPtr->flags & PEN_DELETE_PENDING)) {
            Tcl_AppendResult(graphPtr->interp, "pen \"", penName,
                             "\" already exists in \"", Tk_PathName(graphPtr->tkwin), "\"",
                             (char *)NULL);
            return NULL;
        }
        if (penPtr->classUid != classUid) {
            Tcl_AppendResult(graphPtr->interp, "pen \"", penName,
                             "\" in-use: can't change pen type from \"", penPtr->classUid,
                             "\" to \"", classUid, "\"", (char *)NULL);
            return NULL;
        }
        penPtr->flags &= ~PEN_DELETE_PENDING;
    } else {
        if (classUid == rbcBarElementUid) {
            penPtr = Rbc_BarPen(penName);
        } else {
            penPtr = Rbc_LinePen(penName);
        }
        penPtr->classUid = classUid;
        penPtr->hashPtr = hPtr;
        Tcl_SetHashValue(hPtr, penPtr);
    }

    configFlags = (penPtr->flags & (ACTIVE_PEN | NORMAL_PEN));
    if (Rbc_ConfigureWidgetComponent(graphPtr->interp, graphPtr->tkwin,
                                     penPtr->name, "Pen", penPtr->configSpecs, nOpts, options,
                                     (char *)penPtr, configFlags) != TCL_OK) {
        if (isNew) {
            DestroyPen(graphPtr, penPtr);
        }
        return NULL;
    }
    (*penPtr->configProc) (graphPtr, penPtr);
    return penPtr;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_GetPen --
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
Rbc_GetPen(graphPtr, name, classUid, penPtrPtr)
    Graph *graphPtr;
    CONST84 char *name;
    Rbc_Uid classUid;
    Pen **penPtrPtr;
{
    Pen *penPtr;

    penPtr = NameToPen(graphPtr, name);
    if (penPtr == NULL) {
        return TCL_ERROR;
    }
    if (classUid == rbcStripElementUid) {
        classUid = rbcLineElementUid;
    }
    if (penPtr->classUid != classUid) {
        Tcl_AppendResult(graphPtr->interp, "pen \"", name,
                         "\" is the wrong type (is \"", penPtr->classUid, "\"",
                         ", wanted \"", classUid, "\")", (char *)NULL);
        return TCL_ERROR;
    }
    penPtr->refCount++;
    *penPtrPtr = penPtr;
    return TCL_OK;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_DestroyPens --
 *
 *      Release memory and resources allocated for the style.
 *
 * Results:
 *      None.
 *
 * Side effects:
 *      Everything associated with the pen style is freed up.
 *
 *----------------------------------------------------------------------
 */
void
Rbc_DestroyPens(graphPtr)
    Graph *graphPtr;
{
    Tcl_HashEntry *hPtr;
    Tcl_HashSearch cursor;
    Pen *penPtr;

    for (hPtr = Tcl_FirstHashEntry(&(graphPtr->penTable), &cursor);
            hPtr != NULL; hPtr = Tcl_NextHashEntry(&cursor)) {
        penPtr = (Pen *)Tcl_GetHashValue(hPtr);
        penPtr->hashPtr = NULL;
        DestroyPen(graphPtr, penPtr);
    }
    Tcl_DeleteHashTable(&(graphPtr->penTable));
}

/*
 * ----------------------------------------------------------------------
 *
 * CgetOp --
 *
 *      Queries axis attributes (font, line width, label, etc).
 *
 * Results:
 *      A standard Tcl result.  If querying configuration values,
 *      interp->result will contain the results.
 *
 * Side Effects:
 *      TODO: Side Effects:
 *
 * ----------------------------------------------------------------------
 */
static int
CgetOp(interp, graphPtr, argc, argv)
    Tcl_Interp *interp;
    Graph *graphPtr;
    int argc; /* Not used. */
    char *argv[];
{
    Pen *penPtr;
    unsigned int configFlags;

    penPtr = NameToPen(graphPtr, argv[3]);
    if (penPtr == NULL) {
        return TCL_ERROR;
    }
    configFlags = (penPtr->flags & (ACTIVE_PEN | NORMAL_PEN));
    return Tk_ConfigureValue(interp, graphPtr->tkwin, penPtr->configSpecs,
                             (char *)penPtr, argv[4], configFlags);
}

/*
 * ----------------------------------------------------------------------
 *
 * ConfigureOp --
 *
 *      Queries or resets pen attributes (font, line width, color, etc).
 *
 * Results:
 *      A standard Tcl result.  If querying configuration values,
 *      interp->result will contain the results.
 *
 * Side Effects:
 *      Pen resources are possibly allocated (GC, font).
 *
 * ----------------------------------------------------------------------
 */
static int
ConfigureOp(interp, graphPtr, argc, argv)
    Tcl_Interp *interp;
    Graph *graphPtr;
    int argc;
    char *argv[];
{
    int flags;
    Pen *penPtr;
    int nNames, nOpts;
    int redraw;
    char **options;
    register int i;

    /* Figure out where the option value pairs begin */
    argc -= 3;
    argv += 3;
    for (i = 0; i < argc; i++) {
        if (argv[i][0] == '-') {
            break;
        }
        if (NameToPen(graphPtr, argv[i]) == NULL) {
            return TCL_ERROR;
        }
    }
    nNames = i;			/* Number of pen names specified */
    nOpts = argc - i;		/* Number of options specified */
    options = argv + i;		/* Start of options in argv  */

    redraw = 0;
    for (i = 0; i < nNames; i++) {
        penPtr = NameToPen(graphPtr, argv[i]);
        flags = TK_CONFIG_ARGV_ONLY | (penPtr->flags & (ACTIVE_PEN|NORMAL_PEN));
        if (nOpts == 0) {
            return Tk_ConfigureInfo(interp, graphPtr->tkwin,
                                    penPtr->configSpecs, (char *)penPtr, (char *)NULL, flags);
        } else if (nOpts == 1) {
            return Tk_ConfigureInfo(interp, graphPtr->tkwin,
                                    penPtr->configSpecs, (char *)penPtr, options[0], flags);
        }
        if (Tk_ConfigureWidget(interp, graphPtr->tkwin, penPtr->configSpecs,
                               nOpts, options, (char *)penPtr, flags) != TCL_OK) {
            break;
        }
        (*penPtr->configProc) (graphPtr, penPtr);
        if (penPtr->refCount > 0) {
            redraw++;
        }
    }
    if (redraw) {
        graphPtr->flags |= REDRAW_BACKING_STORE | DRAW_MARGINS;
        Rbc_EventuallyRedrawGraph(graphPtr);
    }
    if (i < nNames) {
        return TCL_ERROR;
    }
    return TCL_OK;
}

/*
 *----------------------------------------------------------------------
 *
 * CreateOp --
 *
 *      Adds a new penstyle to the graph.
 *
 * Results:
 *      A standard Tcl result.
 *
 * Side Effects:
 *      TODO: Side Effects:
 *
 *----------------------------------------------------------------------
 */
static int
CreateOp(interp, graphPtr, argc, argv)
    Tcl_Interp *interp;
    Graph *graphPtr;
    int argc;
    char **argv;
{
    Pen *penPtr;

    penPtr = Rbc_CreatePen(graphPtr, argv[3], graphPtr->classUid, argc - 4,
                           argv + 4);
    if (penPtr == NULL) {
        return TCL_ERROR;
    }
    Tcl_SetResult(interp, penPtr->name, TCL_VOLATILE);
    return TCL_OK;
}

/*
 *--------------------------------------------------------------
 *
 * DeleteOp --
 *
 *      Delete the given pen.
 *
 * Results:
 *      Always returns TCL_OK.  The interp->result field is
 *      a list of the graph axis limits.
 *
 * Side Effects:
 *      TODO: Side Effects:
 *
 *--------------------------------------------------------------
 */
static int
DeleteOp(interp, graphPtr, argc, argv)
    Tcl_Interp *interp;
    Graph *graphPtr;
    int argc;
    char **argv;
{
    Pen *penPtr;
    int i;

    for (i = 3; i < argc; i++) {
        penPtr = NameToPen(graphPtr, argv[i]);
        if (penPtr == NULL) {
            return TCL_ERROR;
        }
        if (penPtr->flags & PEN_DELETE_PENDING) {
            Tcl_AppendResult(graphPtr->interp, "can't find pen \"", argv[i],
                             "\" in \"", Tk_PathName(graphPtr->tkwin), "\"", (char *)NULL);
            return TCL_ERROR;
        }
        penPtr->flags |= PEN_DELETE_PENDING;
        if (penPtr->refCount == 0) {
            DestroyPen(graphPtr, penPtr);
        }
    }
    return TCL_OK;
}

/*
 * ----------------------------------------------------------------------
 *
 * NamesOp --
 *
 *      Return a list of the names of all the axes.
 *
 * Results:
 *      Returns a standard Tcl result.
 *
 * Side Effects:
 *      TODO: Side Effects:
 *
 * ----------------------------------------------------------------------
 */
static int
NamesOp(interp, graphPtr, argc, argv)
    Tcl_Interp *interp;
    Graph *graphPtr;
    int argc;
    char **argv;
{
    Tcl_HashSearch cursor;
    Pen *penPtr;
    register int i;
    register Tcl_HashEntry *hPtr;

    for (hPtr = Tcl_FirstHashEntry(&(graphPtr->penTable), &cursor);
            hPtr != NULL; hPtr = Tcl_NextHashEntry(&cursor)) {
        penPtr = (Pen *)Tcl_GetHashValue(hPtr);
        if (penPtr->flags & PEN_DELETE_PENDING) {
            continue;
        }
        if (argc == 3) {
            Tcl_AppendElement(interp, penPtr->name);
            continue;
        }
        for (i = 3; i < argc; i++) {
            if (Tcl_StringMatch(penPtr->name, argv[i])) {
                Tcl_AppendElement(interp, penPtr->name);
                break;
            }
        }
    }
    return TCL_OK;
}

/*
 * ----------------------------------------------------------------------
 *
 * TypeOp --
 *
 *      Return the type of pen.
 *
 * Results:
 *      Returns a standard Tcl result.
 *
 * Side Effects:
 *      TODO: Side Effects:
 *
 * ----------------------------------------------------------------------
 */
static int
TypeOp(interp, graphPtr, argc, argv)
    Tcl_Interp *interp;
    Graph *graphPtr;
    int argc;
    char **argv;
{
    Pen *penPtr;

    penPtr = NameToPen(graphPtr, argv[3]);
    if (penPtr == NULL) {
        return TCL_ERROR;
    }
    Tcl_SetResult(interp, penPtr->classUid, TCL_STATIC);
    return TCL_OK;
}

static Rbc_OpSpec penOps[] = {
    {"cget", 2, (Rbc_Op)CgetOp, 5, 5, "penName option",},
    {"configure", 2, (Rbc_Op)ConfigureOp, 4, 0,
     "penName ?penName?... ?option value?...",},
    {"create", 2, (Rbc_Op)CreateOp, 4, 0, "penName ?option value?...",},
    {"delete", 2, (Rbc_Op)DeleteOp, 3, 0, "?penName?...",},
    {"names", 1, (Rbc_Op)NamesOp, 3, 0, "?pattern?...",},
    {"type", 1, (Rbc_Op)TypeOp, 4, 4, "penName",},
};
static int nPenOps = sizeof(penOps) / sizeof(Rbc_OpSpec);

/*
 *----------------------------------------------------------------------
 *
 * Rbc_PenOp --
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
Rbc_PenOp(graphPtr, interp, argc, argv)
    Graph *graphPtr;
    Tcl_Interp *interp;
    int argc;
    char **argv;
{
    Rbc_Op proc;

    proc = Rbc_GetOp(interp, nPenOps, penOps, RBC_OP_ARG2, argc, argv, 0);
    if (proc == NULL) {
        return TCL_ERROR;
    }
    return (*proc) (interp, graphPtr, argc, argv);
}
