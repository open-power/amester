/*
 * rbcWinop.c --
 *
 *      This module implements simple window commands for the rbc toolkit.
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#include "rbcInt.h"

#ifndef NO_WINOP

#include "rbcImage.h"
#include <X11/Xutil.h>
#ifndef WIN32
#include <X11/Xproto.h>
#endif

static Tcl_CmdProc WinopCmd;

static int GetRealizedWindow _ANSI_ARGS_((Tcl_Interp *interp, char *string, Tk_Window *tkwinPtr));
static Window StringToWindow _ANSI_ARGS_((Tcl_Interp *interp, char *string));
static int LowerOp _ANSI_ARGS_((ClientData clientData, Tcl_Interp *interp, int argc, char **argv));
static int RaiseOp _ANSI_ARGS_((ClientData clientData, Tcl_Interp *interp, int argc, char **argv));
static int MapOp _ANSI_ARGS_((ClientData clientData, Tcl_Interp *interp, int argc, char **argv));
static int MoveOp _ANSI_ARGS_((ClientData clientData, Tcl_Interp *interp, int argc, char **argv));
static int UnmapOp _ANSI_ARGS_((ClientData clientData, Tcl_Interp *interp, int argc, char **argv));
static int ChangesOp _ANSI_ARGS_((ClientData clientData, Tcl_Interp *interp, int argc, char **argv));
static int QueryOp _ANSI_ARGS_((ClientData clientData, Tcl_Interp *interp, int argc, char **argv));
static int WarpToOp _ANSI_ARGS_((ClientData clientData, Tcl_Interp *interp, int argc, char **argv));
static int ConvolveOp _ANSI_ARGS_((ClientData clientData, Tcl_Interp *interp, int argc, char **argv));
static int QuantizeOp _ANSI_ARGS_((ClientData clientData, Tcl_Interp *interp, int argc, char **argv));
static int ReadJPEGOp _ANSI_ARGS_((ClientData clientData, Tcl_Interp *interp, int argc, char **argv));
static int GradientOp _ANSI_ARGS_((ClientData clientData, Tcl_Interp *interp, int argc, char **argv));
static int ResampleOp _ANSI_ARGS_((ClientData clientData, Tcl_Interp *interp, int argc, char **argv));
static int RotateOp _ANSI_ARGS_((ClientData clientData, Tcl_Interp *interp, int argc, char **argv));
static int SnapOp _ANSI_ARGS_((ClientData clientData, Tcl_Interp *interp, int argc, char **argv));
static int SubsampleOp _ANSI_ARGS_((ClientData clientData, Tcl_Interp *interp, int argc, char **argv));
static int ImageOp _ANSI_ARGS_((ClientData clientData, Tcl_Interp *interp, int argc, char **argv));

/*
 *--------------------------------------------------------------
 *
 * GetRealizedWindow --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
GetRealizedWindow(interp, string, tkwinPtr)
    Tcl_Interp *interp;
    char *string;
    Tk_Window *tkwinPtr;
{
    Tk_Window tkwin;

    tkwin = Tk_NameToWindow(interp, string, Tk_MainWindow(interp));
    if (tkwin == NULL) {
        return TCL_ERROR;
    }
    if (Tk_WindowId(tkwin) == None) {
        Tk_MakeWindowExist(tkwin);
    }
    *tkwinPtr = tkwin;
    return TCL_OK;
}

/*
 *--------------------------------------------------------------
 *
 * StringToWindow --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static Window
StringToWindow(interp, string)
    Tcl_Interp *interp;
    char *string;
{
    int xid;

    if (string[0] == '.') {
        Tk_Window tkwin;

        if (GetRealizedWindow(interp, string, &tkwin) != TCL_OK) {
            return None;
        }
        if (Tk_IsTopLevel(tkwin)) {
            return Rbc_GetRealWindowId(tkwin);
        } else {
            return Tk_WindowId(tkwin);
        }
    } else if (Tcl_GetInt(interp, string, &xid) == TCL_OK) {
#ifdef WIN32
        static TkWinWindow tkWinWindow;

        tkWinWindow.handle = (HWND)xid;
        tkWinWindow.winPtr = NULL;
        tkWinWindow.type = TWD_WINDOW;
        return (Window)&tkWinWindow;
#else
        return (Window)xid;
#endif
    }
    return None;
}

#ifdef WIN32

/*
 *--------------------------------------------------------------
 *
 * GetWindowSize --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
GetWindowSize(interp, window, widthPtr, heightPtr)
    Tcl_Interp *interp;
    Window window;
    int *widthPtr;
    int *heightPtr;
{
    int result;
    RECT region;
    TkWinWindow *winPtr = (TkWinWindow *)window;

    result = GetWindowRect(winPtr->handle, &region);
    if (result) {
        *widthPtr = region.right - region.left;
        *heightPtr = region.bottom - region.top;
        return TCL_OK;
    }
    return TCL_ERROR;
}

#else

/*
 *----------------------------------------------------------------------
 *
 * XGeometryErrorProc --
 *
 *      Flags errors generated from XGetGeometry calls to the X server.
 *
 * Results:
 *      Always returns 0.
 *
 * Side Effects:
 *      Sets a flag, indicating an error occurred.
 *
 *----------------------------------------------------------------------
 */
static int
XGeometryErrorProc(clientData, errEventPtr)
    ClientData clientData;
    XErrorEvent *errEventPtr;
{
    int *errorPtr = clientData;

    *errorPtr = TCL_ERROR;
    return 0;
}

/*
 *--------------------------------------------------------------
 *
 * GetWindowSize --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
GetWindowSize(interp, window, widthPtr, heightPtr)
    Tcl_Interp *interp;
    Window window;
    int *widthPtr, *heightPtr;
{
    int result;
    int any = -1;
    int x, y, borderWidth, depth;
    Window root;
    Tk_ErrorHandler handler;
    Tk_Window tkwin;

    tkwin = Tk_MainWindow(interp);
    handler = Tk_CreateErrorHandler(Tk_Display(tkwin), any, X_GetGeometry,
                                    any, XGeometryErrorProc, &result);
    result = XGetGeometry(Tk_Display(tkwin), window, &root, &x, &y,
                          (unsigned int *)widthPtr, (unsigned int *)heightPtr,
                          (unsigned int *)&borderWidth, (unsigned int *)&depth);
    Tk_DeleteErrorHandler(handler);
    XSync(Tk_Display(tkwin), False);
    if (result) {
        return TCL_OK;
    }
    return TCL_ERROR;
}
#endif /*WIN32*/


#ifndef WIN32
/*
 *--------------------------------------------------------------
 *
 * ColormapOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
ColormapOp(clientData, interp, argc, argv)
    ClientData clientData;
    Tcl_Interp *interp;
    int argc; /* Not used. */
    char **argv;
{
    register int i;
    Tk_Window tkwin;
#define MAXCOLORS 256
    register XColor *colorPtr;
    XColor colorArr[MAXCOLORS];
    unsigned long int pixelValues[MAXCOLORS];
    int inUse[MAXCOLORS];
    char string[20];
    unsigned long int *indexPtr;
    int nFree;

    if (GetRealizedWindow(interp, argv[2], &tkwin) != TCL_OK) {
        return TCL_ERROR;
    }
    /* Initially, we assume all color cells are allocated. */
    memset((char *)inUse, 0, sizeof(int) * MAXCOLORS);

    /*
     * Start allocating color cells.  This will tell us which color cells
     * haven't already been allocated in the colormap.  We'll release the
     * cells as soon as we find out how many there are.
     */
    nFree = 0;
    for (indexPtr = pixelValues, i = 0; i < MAXCOLORS; i++, indexPtr++) {
        if (!XAllocColorCells(Tk_Display(tkwin), Tk_Colormap(tkwin),
                              False, NULL, 0, indexPtr, 1)) {
            break;
        }
        inUse[*indexPtr] = TRUE;/* Indicate the cell is unallocated */
        nFree++;
    }
    XFreeColors(Tk_Display(tkwin), Tk_Colormap(tkwin), pixelValues, nFree, 0);
    for (colorPtr = colorArr, i = 0; i < MAXCOLORS; i++, colorPtr++) {
        colorPtr->pixel = i;
    }
    XQueryColors(Tk_Display(tkwin), Tk_Colormap(tkwin), colorArr, MAXCOLORS);
    for (colorPtr = colorArr, i = 0; i < MAXCOLORS; i++, colorPtr++) {
        if (!inUse[colorPtr->pixel]) {
            sprintf(string, "#%02x%02x%02x", (colorPtr->red >> 8),
                    (colorPtr->green >> 8), (colorPtr->blue >> 8));
            Tcl_AppendElement(interp, string);
            sprintf(string, "%ld", colorPtr->pixel);
            Tcl_AppendElement(interp, string);
        }
    }
    return TCL_OK;
}

#endif

/*
 *--------------------------------------------------------------
 *
 * LowerOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
LowerOp(clientData, interp, argc, argv)
    ClientData clientData;
    Tcl_Interp *interp;
    int argc; /* Not used. */
    char **argv;
{
    register int i;
    Window window;
    Display *display;

    display = Tk_Display(Tk_MainWindow(interp));
    for (i = 2; i < argc; i++) {
        window = StringToWindow(interp, argv[i]);
        if (window == None) {
            return TCL_ERROR;
        }
        XLowerWindow(display, window);
    }
    return TCL_OK;
}

/*
 *--------------------------------------------------------------
 *
 * RaiseOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */

static int
RaiseOp(clientData, interp, argc, argv)
    ClientData clientData;
    Tcl_Interp *interp;
    int argc; /* Not used. */
    char **argv;
{
    register int i;
    Window window;
    Display *display;

    display = Tk_Display(Tk_MainWindow(interp));
    for (i = 2; i < argc; i++) {
        window = StringToWindow(interp, argv[i]);
        if (window == None) {
            return TCL_ERROR;
        }
        XRaiseWindow(display, window);
    }
    return TCL_OK;
}

/*
 *--------------------------------------------------------------
 *
 * MapOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
MapOp(clientData, interp, argc, argv)
    ClientData clientData;
    Tcl_Interp *interp;
    int argc; /* Not used. */
    char **argv;
{
    register int i;
    Window window;
    Display *display;

    display = Tk_Display(Tk_MainWindow(interp));
    for (i = 2; i < argc; i++) {
        if (argv[i][0] == '.') {
            Tk_Window tkwin;
            Tk_FakeWin *fakePtr;

            if (GetRealizedWindow(interp, argv[i], &tkwin) != TCL_OK) {
                return TCL_ERROR;
            }
            fakePtr = (Tk_FakeWin *) tkwin;
            fakePtr->flags |= TK_MAPPED;
            window = Tk_WindowId(tkwin);
        } else {
            int xid;

            if (Tcl_GetInt(interp, argv[i], &xid) != TCL_OK) {
                return TCL_ERROR;
            }
            window = (Window)xid;
        }
        XMapWindow(display, window);
    }
    return TCL_OK;
}

/*
 *--------------------------------------------------------------
 *
 * MoveOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
MoveOp(clientData, interp, argc, argv)
    ClientData clientData;
    Tcl_Interp *interp;
    int argc; /* Not Used. */
    char **argv;
{
    int x, y;
    Tk_Window tkwin;
    Window window;
    Display *display;

    tkwin = Tk_MainWindow(interp);
    display = Tk_Display(tkwin);
    window = StringToWindow(interp, argv[2]);
    if (window == None) {
        return TCL_ERROR;
    }
    if (Tk_GetPixels(interp, tkwin, argv[3], &x) != TCL_OK) {
        Tcl_AppendResult(interp, ": bad window x-coordinate", (char *)NULL);
        return TCL_ERROR;
    }
    if (Tk_GetPixels(interp, tkwin, argv[4], &y) != TCL_OK) {
        Tcl_AppendResult(interp, ": bad window y-coordinate", (char *)NULL);
        return TCL_ERROR;
    }
    XMoveWindow(display, window, x, y);
    return TCL_OK;
}

/*
 *--------------------------------------------------------------
 *
 * UnmapOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
UnmapOp(clientData, interp, argc, argv)
    ClientData clientData;
    Tcl_Interp *interp;
    int argc; /* Not used. */
    char **argv;
{
    register int i;
    Window window;
    Display *display;

    display = Tk_Display(Tk_MainWindow(interp));
    for (i = 2; i < argc; i++) {
        if (argv[i][0] == '.') {
            Tk_Window tkwin;
            Tk_FakeWin *fakePtr;

            if (GetRealizedWindow(interp, argv[i], &tkwin) != TCL_OK) {
                return TCL_ERROR;
            }
            fakePtr = (Tk_FakeWin *) tkwin;
            fakePtr->flags &= ~TK_MAPPED;
            window = Tk_WindowId(tkwin);
        } else {
            int xid;

            if (Tcl_GetInt(interp, argv[i], &xid) != TCL_OK) {
                return TCL_ERROR;
            }
            window = (Window)xid;
        }
        XMapWindow(display, window);
    }
    return TCL_OK;
}

/*
 *--------------------------------------------------------------
 *
 * ChangesOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
ChangesOp(clientData, interp, argc, argv)
    ClientData clientData;
    Tcl_Interp *interp;
    int argc; /* Not used. */
    char **argv; /* Not used. */
{
    Tk_Window tkwin;

    if (GetRealizedWindow(interp, argv[2], &tkwin) != TCL_OK) {
        return TCL_ERROR;
    }
    if (Tk_IsTopLevel(tkwin)) {
        XSetWindowAttributes attrs;
        Window window;
        unsigned int mask;

        window = Rbc_GetRealWindowId(tkwin);
        attrs.backing_store = WhenMapped;
        attrs.save_under = True;
        mask = CWBackingStore | CWSaveUnder;
        XChangeWindowAttributes(Tk_Display(tkwin), window, mask, &attrs);
    }
    return TCL_OK;
}

/*
 *--------------------------------------------------------------
 *
 * QueryOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
QueryOp(clientData, interp, argc, argv)
    ClientData clientData;
    Tcl_Interp *interp;
    int argc; /* Not used. */
    char **argv; /* Not used. */
{
    int rootX, rootY, childX, childY;
    Window root, child;
    unsigned int mask;
    Tk_Window tkwin = (Tk_Window)clientData;

    /* GetCursorPos */
    if (XQueryPointer(Tk_Display(tkwin), Tk_WindowId(tkwin), &root,
                      &child, &rootX, &rootY, &childX, &childY, &mask)) {
        char string[200];

        sprintf(string, "@%d,%d", rootX, rootY);
        Tcl_SetResult(interp, string, TCL_VOLATILE);
    }
    return TCL_OK;
}

/*
 *--------------------------------------------------------------
 *
 * WarpToOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
WarpToOp(clientData, interp, argc, argv)
    ClientData clientData;
    Tcl_Interp *interp;
    int argc; /* Not used. */
    char **argv;
{
    Tk_Window tkwin, mainWindow;

    mainWindow = (Tk_Window)clientData;
    if (argc > 2) {
        if (argv[2][0] == '@') {
            int x, y;
            Window root;

            if (Rbc_GetXY(interp, mainWindow, argv[2], &x, &y) != TCL_OK) {
                return TCL_ERROR;
            }
            root = RootWindow(Tk_Display(mainWindow),
                              Tk_ScreenNumber(mainWindow));
            XWarpPointer(Tk_Display(mainWindow), None, root, 0, 0, 0, 0, x, y);
        } else {
            if (GetRealizedWindow(interp, argv[2], &tkwin) != TCL_OK) {
                return TCL_ERROR;
            }
            if (!Tk_IsMapped(tkwin)) {
                Tcl_AppendResult(interp, "can't warp to unmapped window \"",
                                 Tk_PathName(tkwin), "\"", (char *)NULL);
                return TCL_ERROR;
            }
            XWarpPointer(Tk_Display(tkwin), None, Tk_WindowId(tkwin),
                         0, 0, 0, 0, Tk_Width(tkwin) / 2, Tk_Height(tkwin) / 2);
        }
    }
    return QueryOp(clientData, interp, 0, (char **)NULL);
}

#ifdef notdef
/*
 *--------------------------------------------------------------
 *
 * ReparentOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
ReparentOp(clientData, interp, argc, argv)
    ClientData clientData;
    Tcl_Interp *interp;
    int argc;
    char **argv;
{
    Tk_Window tkwin;

    if (GetRealizedWindow(interp, argv[2], &tkwin) != TCL_OK) {
        return TCL_ERROR;
    }
    if (argc == 4) {
        Tk_Window newParent;

        if (GetRealizedWindow(interp, argv[3], &newParent) != TCL_OK) {
            return TCL_ERROR;
        }
        Rbc_RelinkWindow2(tkwin, Rbc_GetRealWindowId(tkwin), newParent, 0, 0);
    } else {
        Rbc_UnlinkWindow(tkwin);
    }
    return TCL_OK;
}
#endif

/*
 * This is a temporary home for these image routines.  They will be
 * moved when a new image type is created for them.
 */

/*
 *--------------------------------------------------------------
 *
 * ConvolveOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
ConvolveOp(clientData, interp, argc, argv)
    ClientData clientData; /* Not used. */
    Tcl_Interp *interp;
    int argc; /* Not used. */
    char **argv;
{
    Tk_PhotoHandle srcPhoto, destPhoto;
    Rbc_ColorImage srcImage, destImage;
    Filter2D filter;
    int nValues;
    char **valueArr;
    double *kernel;
    double value, sum;
    register int i;
    int dim;
    int result = TCL_ERROR;

    srcPhoto = Rbc_FindPhoto(interp, argv[2]);
    if (srcPhoto == NULL) {
        Tcl_AppendResult(interp, "source image \"", argv[2], "\" doesn't",
                         " exist or is not a photo image", (char *)NULL);
        return TCL_ERROR;
    }
    destPhoto = Rbc_FindPhoto(interp, argv[3]);
    if (destPhoto == NULL) {
        Tcl_AppendResult(interp, "destination image \"", argv[3], "\" doesn't",
                         " exist or is not a photo image", (char *)NULL);
        return TCL_ERROR;
    }
    if (Tcl_SplitList(interp, argv[4], &nValues, &valueArr) != TCL_OK) {
        return TCL_ERROR;
    }
    kernel = NULL;
    if (nValues == 0) {
        Tcl_AppendResult(interp, "empty kernel", (char *)NULL);
        goto error;
    }
    dim = (int)sqrt((double)nValues);
    if ((dim * dim) != nValues) {
        Tcl_AppendResult(interp, "kernel must be square", (char *)NULL);
        goto error;
    }
    kernel = (double *)ckalloc(sizeof(double) * nValues);
    sum = 0.0;
    for (i = 0; i < nValues; i++) {
        if (Tcl_GetDouble(interp, valueArr[i], &value) != TCL_OK) {
            goto error;
        }
        kernel[i] = value;
        sum += value;
    }
    filter.kernel = kernel;
    filter.support = dim * 0.5;
    filter.sum = (sum == 0.0) ? 1.0 : sum;
    filter.scale = 1.0 / nValues;

    srcImage = Rbc_PhotoToColorImage(srcPhoto);
    destImage = Rbc_ConvolveColorImage(srcImage, &filter);
    Rbc_FreeColorImage(srcImage);
    Rbc_ColorImageToPhoto(interp, destImage, destPhoto);
    Rbc_FreeColorImage(destImage);
    result = TCL_OK;
error:
    if (valueArr != NULL) {
        ckfree((char *)valueArr);
    }
    if (kernel != NULL) {
        ckfree((char *)kernel);
    }
    return result;
}

/*
 *--------------------------------------------------------------
 *
 * QuantizeOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
QuantizeOp(clientData, interp, argc, argv)
    ClientData clientData; /* Not used. */
    Tcl_Interp *interp;
    int argc; /* Not used. */
    char **argv;
{
    Tk_PhotoHandle srcPhoto, destPhoto;
    Tk_PhotoImageBlock src, dest;
    Rbc_ColorImage srcImage, destImage;
    int nColors;
    int result;

    srcPhoto = Rbc_FindPhoto(interp, argv[2]);
    if (srcPhoto == NULL) {
        Tcl_AppendResult(interp, "source image \"", argv[2], "\" doesn't",
                         " exist or is not a photo image", (char *)NULL);
        return TCL_ERROR;
    }
    Tk_PhotoGetImage(srcPhoto, &src);
    if ((src.width <= 1) || (src.height <= 1)) {
        Tcl_AppendResult(interp, "source image \"", argv[2], "\" is empty",
                         (char *)NULL);
        return TCL_ERROR;
    }
    destPhoto = Rbc_FindPhoto(interp, argv[3]);
    if (destPhoto == NULL) {
        Tcl_AppendResult(interp, "destination image \"", argv[3], "\" doesn't",
                         " exist or is not a photo image", (char *)NULL);
        return TCL_ERROR;
    }
    Tk_PhotoGetImage(destPhoto, &dest);
    if ((dest.width != src.width) || (dest.height != src.height)) {
        Tk_PhotoSetSize(destPhoto, src.width, src.height);
    }
    if (Tcl_GetInt(interp, argv[4], &nColors) != TCL_OK) {
        return TCL_ERROR;
    }
    srcImage = Rbc_PhotoToColorImage(srcPhoto);
    destImage = Rbc_PhotoToColorImage(destPhoto);
    result = Rbc_QuantizeColorImage(srcImage, destImage, nColors);
    if (result == TCL_OK) {
        Rbc_ColorImageToPhoto(interp, destImage, destPhoto);
    }
    Rbc_FreeColorImage(srcImage);
    Rbc_FreeColorImage(destImage);
    return result;
}

/*
 *--------------------------------------------------------------
 *
 * ReadJPEGOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
ReadJPEGOp(clientData, interp, argc, argv)
    ClientData clientData; /* Not used. */
    Tcl_Interp *interp;
    int argc; /* Not used. */
    char **argv;
{
#if HAVE_JPEGLIB_H
    Tk_PhotoHandle photo;	/* The photo image to write into. */

    photo = Rbc_FindPhoto(interp, argv[3]);
    if (photo == NULL) {
        Tcl_AppendResult(interp, "image \"", argv[3], "\" doesn't",
                         " exist or is not a photo image", (char *)NULL);
        return TCL_ERROR;
    }
    return Rbc_JPEGToPhoto(interp, argv[2], photo);
#else
    Tcl_AppendResult(interp, "JPEG support not compiled", (char *)NULL);
    return TCL_ERROR;
#endif
}

/*
 *--------------------------------------------------------------
 *
 * GradientOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
GradientOp(clientData, interp, argc, argv)
    ClientData clientData; /* Not used. */
    Tcl_Interp *interp;
    int argc; /* Not used. */
    char **argv;
{
    Tk_PhotoHandle photo;
    Tk_PhotoImageBlock src;
    XColor *leftPtr, *rightPtr;
    Tk_Window tkwin;
    double range[3];
    double left[3];
    Pix32 *destPtr;
    Rbc_ColorImage destImage;

    tkwin = Tk_MainWindow(interp);
    photo = Rbc_FindPhoto(interp, argv[2]);
    if (photo == NULL) {
        Tcl_AppendResult(interp, "source image \"", argv[2], "\" doesn't",
                         " exist or is not a photo image", (char *)NULL);
        return TCL_ERROR;
    }
    Tk_PhotoGetImage(photo, &src);
    leftPtr = Tk_GetColor(interp, tkwin, Tk_GetUid(argv[3]));
    if (leftPtr == NULL) {
        return TCL_ERROR;
    }
    rightPtr = Tk_GetColor(interp, tkwin, Tk_GetUid(argv[4]));
    if (leftPtr == NULL) {
        return TCL_ERROR;
    }
    left[0] = (double)(leftPtr->red >> 8);
    left[1] = (double)(leftPtr->green >> 8);
    left[2] = (double)(leftPtr->blue >> 8);
    range[0] = (double)((rightPtr->red - leftPtr->red) / 257.0);
    range[1] = (double)((rightPtr->green - leftPtr->green) / 257.0);
    range[2] = (double)((rightPtr->blue - leftPtr->blue) / 257.0);

    destImage = Rbc_CreateColorImage(src.width, src.height);
    destPtr = Rbc_ColorImageBits(destImage);
#define CLAMP(c)	((((c) < 0.0) ? 0.0 : ((c) > 1.0) ? 1.0 : (c)))
    if (strcmp(argv[5], "linear") == 0) {
        register int x, y;
        double t;

        for (y = 0; y < src.height; y++) {
            for (x = 0; x < src.width; x++) {
                t = (double)x * (drand48() * 0.10 - 0.05);
                t = CLAMP(t);
                destPtr->Red = (unsigned char)(left[0] + t * range[0]);
                destPtr->Green = (unsigned char)(left[1] + t * range[1]);
                destPtr->Blue = (unsigned char)(left[2] + t * range[2]);
                destPtr->Alpha = (unsigned char)-1;
                destPtr++;
            }
        }
    } else if (strcmp(argv[5], "radial") == 0) {
        register int x, y;
        register double dx, dy;
        double dy2;
        double t;
        double midX, midY;

        midX = midY = 0.5;
        for (y = 0; y < src.height; y++) {
            dy = (y / (double)src.height) - midY;
            dy2 = dy * dy;
            for (x = 0; x < src.width; x++) {
                dx = (x / (double)src.width) - midX;
                t = 1.0  - (double)sqrt(dx * dx + dy2);
                t += t * (drand48() * 0.10 - 0.05);
                t = CLAMP(t);
                destPtr->Red = (unsigned char)(left[0] + t * range[0]);
                destPtr->Green = (unsigned char)(left[1] + t * range[1]);
                destPtr->Blue = (unsigned char)(left[2] + t * range[2]);
                destPtr->Alpha = (unsigned char)-1;
                destPtr++;
            }
        }
    } else if (strcmp(argv[5], "rectangular") == 0) {
        register int x, y;
        register double dx, dy;
        double t, px, py;
        double midX, midY;
        double cosTheta, sinTheta;
        double angle;

        angle = M_PI_2 * -0.3;
        cosTheta = cos(angle);
        sinTheta = sin(angle);

        midX = 0.5, midY = 0.5;
        for (y = 0; y < src.height; y++) {
            dy = (y / (double)src.height) - midY;
            for (x = 0; x < src.width; x++) {
                dx = (x / (double)src.width) - midX;
                px = dx * cosTheta - dy * sinTheta;
                py = dx * sinTheta + dy * cosTheta;
                t = FABS(px) + FABS(py);
                t += t * (drand48() * 0.10 - 0.05);
                t = CLAMP(t);
                destPtr->Red = (unsigned char)(left[0] + t * range[0]);
                destPtr->Green = (unsigned char)(left[1] + t * range[1]);
                destPtr->Blue = (unsigned char)(left[2] + t * range[2]);
                destPtr->Alpha = (unsigned char)-1;
                destPtr++;
            }
        }
    } else if (strcmp(argv[5], "blank") == 0) {
        register int x, y;

        for (y = 0; y < src.height; y++) {
            for (x = 0; x < src.width; x++) {
                destPtr->Red = (unsigned char)0xFF;
                destPtr->Green = (unsigned char)0xFF;
                destPtr->Blue = (unsigned char)0xFF;
                destPtr->Alpha = (unsigned char)-1;
                destPtr++;
            }
        }
    }
    Rbc_ColorImageToPhoto(interp, destImage, photo);
    return TCL_OK;
}

/*
 *--------------------------------------------------------------
 *
 * ResampleOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
ResampleOp(clientData, interp, argc, argv)
    ClientData clientData; /* Not used. */
    Tcl_Interp *interp;
    int argc; /* Not used. */
    char **argv;
{
    Tk_PhotoHandle srcPhoto, destPhoto;
    Tk_PhotoImageBlock src, dest;
    ResampleFilter *filterPtr, *vertFilterPtr, *horzFilterPtr;
    char *filterName;

    srcPhoto = Rbc_FindPhoto(interp, argv[2]);
    if (srcPhoto == NULL) {
        Tcl_AppendResult(interp, "source image \"", argv[2], "\" doesn't",
                         " exist or is not a photo image", (char *)NULL);
        return TCL_ERROR;
    }
    destPhoto = Rbc_FindPhoto(interp, argv[3]);
    if (destPhoto == NULL) {
        Tcl_AppendResult(interp, "destination image \"", argv[3], "\" doesn't",
                         " exist or is not a photo image", (char *)NULL);
        return TCL_ERROR;
    }
    filterName = (argc > 4) ? argv[4] : "none";
    if (Rbc_GetResampleFilter(interp, filterName, &filterPtr) != TCL_OK) {
        return TCL_ERROR;
    }
    vertFilterPtr = horzFilterPtr = filterPtr;
    if ((filterPtr != NULL) && (argc > 5)) {
        if (Rbc_GetResampleFilter(interp, argv[5], &filterPtr) != TCL_OK) {
            return TCL_ERROR;
        }
        vertFilterPtr = filterPtr;
    }
    Tk_PhotoGetImage(srcPhoto, &src);
    if ((src.width <= 1) || (src.height <= 1)) {
        Tcl_AppendResult(interp, "source image \"", argv[2], "\" is empty",
                         (char *)NULL);
        return TCL_ERROR;
    }
    Tk_PhotoGetImage(destPhoto, &dest);
    if ((dest.width <= 1) || (dest.height <= 1)) {
        Tk_PhotoSetSize(destPhoto, src.width, src.height);
        goto copyImage;
    }
    if ((src.width == dest.width) && (src.height == dest.height)) {
copyImage:
        /* Source and destination image sizes are the same. Don't
         * resample. Simply make copy of image */
        dest.width = src.width;
        dest.height = src.height;
        dest.pixelPtr = src.pixelPtr;
        dest.pixelSize = src.pixelSize;
        dest.pitch = src.pitch;
        dest.offset[0] = src.offset[0];
        dest.offset[1] = src.offset[1];
        dest.offset[2] = src.offset[2];
        Tk_PhotoPutBlock(destPhoto, &dest, 0, 0, dest.width, dest.height);
        return TCL_OK;
    }
    if (filterPtr == NULL) {
        Rbc_ResizePhoto(interp, srcPhoto, 0, 0, src.width, src.height, destPhoto);
    } else {
        Rbc_ResamplePhoto(interp, srcPhoto, 0, 0, src.width, src.height, destPhoto, horzFilterPtr, vertFilterPtr);
    }
    return TCL_OK;
}

/*
 *--------------------------------------------------------------
 *
 * RotateOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
RotateOp(clientData, interp, argc, argv)
    ClientData clientData; /* Not used. */
    Tcl_Interp *interp;
    int argc; /* Not used. */
    char **argv;
{
    Tk_PhotoHandle srcPhoto, destPhoto;
    Rbc_ColorImage srcImage, destImage;
    double theta;

    srcPhoto = Rbc_FindPhoto(interp, argv[2]);
    if (srcPhoto == NULL) {
        Tcl_AppendResult(interp, "image \"", argv[2], "\" doesn't",
                         " exist or is not a photo image", (char *)NULL);
        return TCL_ERROR;
    }
    destPhoto = Rbc_FindPhoto(interp, argv[3]);
    if (destPhoto == NULL) {
        Tcl_AppendResult(interp, "destination image \"", argv[3], "\" doesn't",
                         " exist or is not a photo image", (char *)NULL);
        return TCL_ERROR;
    }
    if (Tcl_ExprDouble(interp, argv[4], &theta) != TCL_OK) {
        return TCL_ERROR;
    }
    srcImage = Rbc_PhotoToColorImage(srcPhoto);
    destImage = Rbc_RotateColorImage(srcImage, theta);

    Rbc_ColorImageToPhoto(interp, destImage, destPhoto);
    Rbc_FreeColorImage(srcImage);
    Rbc_FreeColorImage(destImage);
    return TCL_OK;
}

/*
 *--------------------------------------------------------------
 *
 * SnapOp --
 *
 *      Snaps a picture of a window and stores it in a
 *      designated photo image.  The window must be completely
 *      visible or the snap will fail.
 *
 * Results:
 *      Returns a standard Tcl result.  interp->result contains
 *      the list of the graph coordinates. If an error occurred
 *      while parsing the window positions, TCL_ERROR is
 *      returned, then interp->result will contain an error
 *      message.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
SnapOp(clientData, interp, argc, argv)
    ClientData clientData;
    Tcl_Interp *interp;
    int argc; /* Not used. */
    char **argv;
{
    Tk_Window tkwin;
    int width, height, destWidth, destHeight;
    Window window;

    tkwin = Tk_MainWindow(interp);
    window = StringToWindow(interp, argv[2]);
    if (window == None) {
        return TCL_ERROR;
    }
    if (GetWindowSize(interp, window, &width, &height) != TCL_OK) {
        Tcl_AppendResult(interp, "can't get window geometry of \"", argv[2],
                         "\"", (char *)NULL);
        return TCL_ERROR;
    }
    destWidth = width, destHeight = height;
    if ((argc > 4) && (Rbc_GetPixels(interp, tkwin, argv[4], PIXELS_POSITIVE,
                                     &destWidth) != TCL_OK)) {
        return TCL_ERROR;
    }
    if ((argc > 5) && (Rbc_GetPixels(interp, tkwin, argv[5], PIXELS_POSITIVE,
                                     &destHeight) != TCL_OK)) {
        return TCL_ERROR;
    }
    return Rbc_SnapPhoto(interp, tkwin, window, 0, 0, width, height, destWidth,
                         destHeight, argv[3], GAMMA);
}

/*
 *--------------------------------------------------------------
 *
 * SubsampleOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
SubsampleOp(clientData, interp, argc, argv)
    ClientData clientData; /* Main window of the interpreter. */
    Tcl_Interp *interp;
    int argc;  /* Not used. */
    char **argv;
{
    Tk_Window tkwin;
    Tk_PhotoHandle srcPhoto, destPhoto;
    Tk_PhotoImageBlock src, dest;
    ResampleFilter *filterPtr, *vertFilterPtr, *horzFilterPtr;
    char *filterName;
    int flag;
    int x, y;
    int width, height;

    srcPhoto = Rbc_FindPhoto(interp, argv[2]);
    if (srcPhoto == NULL) {
        Tcl_AppendResult(interp, "source image \"", argv[2], "\" doesn't",
                         " exist or is not a photo image", (char *)NULL);
        return TCL_ERROR;
    }
    destPhoto = Rbc_FindPhoto(interp, argv[3]);
    if (destPhoto == NULL) {
        Tcl_AppendResult(interp, "destination image \"", argv[3], "\" doesn't",
                         " exist or is not a photo image", (char *)NULL);
        return TCL_ERROR;
    }
    tkwin = (Tk_Window)clientData;
    flag = PIXELS_NONNEGATIVE;
    if (Rbc_GetPixels(interp, tkwin, argv[4], flag, &x) != TCL_OK) {
        return TCL_ERROR;
    }
    if (Rbc_GetPixels(interp, tkwin, argv[5], flag, &y) != TCL_OK) {
        return TCL_ERROR;
    }
    flag = PIXELS_POSITIVE;
    if (Rbc_GetPixels(interp, tkwin, argv[6], flag, &width) != TCL_OK) {
        return TCL_ERROR;
    }
    if (Rbc_GetPixels(interp, tkwin, argv[7], flag, &height) != TCL_OK) {
        return TCL_ERROR;
    }
    filterName = (argc > 8) ? argv[8] : "box";
    if (Rbc_GetResampleFilter(interp, filterName, &filterPtr) != TCL_OK) {
        return TCL_ERROR;
    }
    vertFilterPtr = horzFilterPtr = filterPtr;
    if ((filterPtr != NULL) && (argc > 9)) {
        if (Rbc_GetResampleFilter(interp, argv[9], &filterPtr) != TCL_OK) {
            return TCL_ERROR;
        }
        vertFilterPtr = filterPtr;
    }
    Tk_PhotoGetImage(srcPhoto, &src);
    Tk_PhotoGetImage(destPhoto, &dest);
    if ((src.width <= 1) || (src.height <= 1)) {
        Tcl_AppendResult(interp, "source image \"", argv[2], "\" is empty",
                         (char *)NULL);
        return TCL_ERROR;
    }
    if (((x + width) > src.width) || ((y + height) > src.height)) {
        Tcl_AppendResult(interp, "nonsensical dimensions for subregion: x=",
                         argv[4], " y=", argv[5], " width=", argv[6], " height=",
                         argv[7], (char *)NULL);
        return TCL_ERROR;
    }
    if ((dest.width <= 1) || (dest.height <= 1)) {
        Tk_PhotoSetSize(destPhoto, width, height);
    }
    if (filterPtr == NULL) {
        Rbc_ResizePhoto(interp, srcPhoto, x, y, width, height, destPhoto);
    } else {
        Rbc_ResamplePhoto(interp, srcPhoto, x, y, width, height, destPhoto,
                          horzFilterPtr, vertFilterPtr);
    }
    return TCL_OK;
}

static Rbc_OpSpec imageOps[] = {
    {"convolve", 1, (Rbc_Op)ConvolveOp, 6, 6,
        "srcPhoto destPhoto filter",},
    {"gradient", 1, (Rbc_Op)GradientOp, 7, 7, "photo left right type",},
    {"readjpeg", 3, (Rbc_Op)ReadJPEGOp, 5, 5, "fileName photoName",},
    {"resample", 3, (Rbc_Op)ResampleOp, 5, 7,
     "srcPhoto destPhoto ?horzFilter vertFilter?",},
    {"rotate", 2, (Rbc_Op)RotateOp, 6, 6, "srcPhoto destPhoto angle",},
    {"snap", 2, (Rbc_Op)SnapOp, 5, 7, "window photoName ?width height?",},
    {"subsample", 2, (Rbc_Op)SubsampleOp, 9, 11,
     "srcPhoto destPhoto x y width height ?horzFilter? ?vertFilter?",},
};

static int nImageOps = sizeof(imageOps) / sizeof(Rbc_OpSpec);

/*
 *--------------------------------------------------------------
 *
 * ImageOp --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
ImageOp(clientData, interp, argc, argv)
    ClientData clientData; /* Main window of interpreter. */
    Tcl_Interp *interp; /* Current interpreter. */
    int argc; /* Number of arguments. */
    char **argv; /* Argument strings. */
{
    Rbc_Op proc;
    int result;

    proc = Rbc_GetOp(interp, nImageOps, imageOps, RBC_OP_ARG2, argc, argv, 0);
    if (proc == NULL) {
        return TCL_ERROR;
    }
    clientData = (ClientData)Tk_MainWindow(interp);
    result = (*proc) (clientData, interp, argc - 1, argv + 1);
    return result;
}

static Rbc_OpSpec winOps[] = {
    {"changes", 3, (Rbc_Op)ChangesOp, 3, 3, "window",},
#ifndef WIN32
    {"colormap", 3, (Rbc_Op)ColormapOp, 3, 3, "window",},
#endif
    {"convolve", 3, (Rbc_Op)ConvolveOp, 5, 5,
     "srcPhoto destPhoto filter",},
    {"image", 1, (Rbc_Op)ImageOp, 2, 0, "args",},
    {"lower", 1, (Rbc_Op)LowerOp, 2, 0, "window ?window?...",},
    {"map", 2, (Rbc_Op)MapOp, 2, 0, "window ?window?...",},
    {"move", 2, (Rbc_Op)MoveOp, 5, 5, "window x y",},
    {"quantize", 3, (Rbc_Op)QuantizeOp, 4, 5, "srcPhoto destPhoto ?nColors?",},
    {"query", 3, (Rbc_Op)QueryOp, 2, 2, "",},
    {"raise", 2, (Rbc_Op)RaiseOp, 2, 0, "window ?window?...",},
    {"readjpeg", 3, (Rbc_Op)ReadJPEGOp, 4, 4, "fileName photoName",},
#ifdef notdef
    {"reparent", 3, (Rbc_Op)ReparentOp, 3, 4, "window ?parent?",},
#endif
    {"resample", 3, (Rbc_Op)ResampleOp, 4, 6,
     "srcPhoto destPhoto ?horzFilter vertFilter?",},
    {"snap", 2, (Rbc_Op)SnapOp, 4, 6,
     "window photoName ?width height?",},
    {"subsample", 2, (Rbc_Op)SubsampleOp, 8, 10,
     "srcPhoto destPhoto x y width height ?horzFilter? ?vertFilter?",},
    {"unmap", 1, (Rbc_Op)UnmapOp, 2, 0, "window ?window?...",},
    {"warpto", 1, (Rbc_Op)WarpToOp, 2, 5, "?window?",},
};

static int nWinOps = sizeof(winOps) / sizeof(Rbc_OpSpec);

/*
 *--------------------------------------------------------------
 *
 * WinopCmd --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static int
WinopCmd(clientData, interp, argc, argv)
    ClientData clientData; /* Main window of interpreter. */
    Tcl_Interp *interp; /* Current interpreter. */
    int argc; /* Number of arguments. */
    char **argv; /* Argument strings. */
{
    Rbc_Op proc;
    int result;

    proc = Rbc_GetOp(interp, nWinOps, winOps, RBC_OP_ARG1,  argc, argv, 0);
    if (proc == NULL) {
        return TCL_ERROR;
    }
    clientData = (ClientData)Tk_MainWindow(interp);
    result = (*proc) (clientData, interp, argc, argv);
    return result;
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_WinopInit --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
int
Rbc_WinopInit(interp)
    Tcl_Interp *interp;
{
    Tcl_CreateCommand(interp, "rbc::winop", WinopCmd, (ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);
    return TCL_OK;
}

#endif /* NO_WINOP */
