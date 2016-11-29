/*
 * rbcInt.h --
 *
 *      This file constructs the basic functionality of the
 *      rbc commands.
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#ifndef _RBCINT
#define _RBCINT

#ifdef WIN32
#define STRICT
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#undef STRICT
#undef WIN32_LEAN_AND_MEAN
#include <windowsx.h>
#endif /* WIN32 */

#define USE_NON_CONST
#include <tcl.h>

/* Backwards Compatiablitity with previous Tk versions */
#define USE_OLD_CANVAS
#define USE_COMPOSITELESS_PHOTO_PUT_BLOCK

#include <tk.h>

#define MIN_VERSION "8.4"

#include "rbcTkInt.h"

#include <stdio.h>
#include <assert.h>

#if defined(WIN32)
#include "rbcWinConfig.h"
#else
#include "rbcConfig.h"
#endif

#ifdef WIN32
#ifndef EXPORT
#if defined(_MSC_VER) || defined(__BORLANDC__)
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif /* _MSC_VER || __BORLANDC__ */
#endif /* EXPORT */

/* Misc. definitions */
#define	NO_CUTBUFFER	1
#define NO_TILESCROLLBAR	1
#define NO_DND		1

#ifndef __GNUC__
#ifdef O_NONBLOCK
#define O_NONBLOCK	1
#endif
#endif /* __GNUC__ */
#endif /* WIN32 */

#include "rbc.h"

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif /* HAVE_STDLIB_H */

#ifdef HAVE_STRING_H
#include <string.h>
#endif /* HAVE_STRING_H */

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif /* HAVE_ERRNO_H */

#ifdef HAVE_CTYPE_H
#include <ctype.h>
#endif /* HAVE_CTYPE_H */

#ifdef HAVE_MEMORY_H
#include <memory.h>
#endif /* HAVE_MEMORY_H */

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif /* HAVE_UNISTD_H */

#ifdef HAVE_LIMITS_H
#include <limits.h>
#endif

#include "rbcMath.h"

#undef INLINE
#ifdef __GNUC__
#define INLINE inline
#else
#define INLINE
#endif
#undef EXPORT
#define EXPORT

#undef VARARGS
#ifdef __cplusplus
#define ANYARGS (...)
#define VARARGS(first)  (first, ...)
#define VARARGS2(first, second)  (first, second, ...)
#else
#define ANYARGS ()
#define VARARGS(first) ()
#define VARARGS2(first, second) ()
#endif /* __cplusplus */

#undef MIN
#define MIN(a,b)	(((a)<(b))?(a):(b))

#undef MAX
#define MAX(a,b)	(((a)>(b))?(a):(b))

#undef MIN3
#define MIN3(a,b,c)	(((a)<(b))?(((a)<(c))?(a):(c)):(((b)<(c))?(b):(c)))

#undef MAX3
#define MAX3(a,b,c)	(((a)>(b))?(((a)>(c))?(a):(c)):(((b)>(c))?(b):(c)))

#define TRUE 	1
#define FALSE 	0

/*
 * The macro below is used to modify a "char" value (e.g. by casting
 * it to an unsigned character) so that it can be used safely with
 * macros such as isspace.
 */
#define UCHAR(c) ((unsigned char) (c))

/*
 * ----------------------------------------------------------------------
 *
 * Rbc_Op --
 *
 * 	Generic function prototype of CmdOptions.
 *
 * ----------------------------------------------------------------------
 */
typedef int (*Rbc_Op) _ANSI_ARGS_(ANYARGS);

/*
 * ----------------------------------------------------------------------
 *
 * Rbc_OpSpec --
 *
 * 	Structure to specify a set of operations for a Tcl command.
 *      This is passed to the Rbc_GetOp procedure to look
 *      for a function pointer associated with the operation name.
 *
 * ----------------------------------------------------------------------
 */
typedef struct {
    char *name;			/* Name of operation */
    int minChars;		/* Minimum # characters to disambiguate */
    Rbc_Op proc;
    int minArgs;		/* Minimum # args required */
    int maxArgs;		/* Maximum # args required */
    char *usage;		/* Usage message */

} Rbc_OpSpec;

typedef enum {
    RBC_OP_ARG0,		/* Op is the first argument. */
    RBC_OP_ARG1,		/* Op is the second argument. */
    RBC_OP_ARG2,		/* Op is the third argument. */
    RBC_OP_ARG3,		/* Op is the fourth argument. */
    RBC_OP_ARG4			/* Op is the fifth argument. */

} Rbc_OpIndex;

#define RBC_OP_LINEAR_SEARCH	1
#define RBC_OP_BINARY_SEARCH	0

Rbc_Op Rbc_GetOp _ANSI_ARGS_((Tcl_Interp *interp, int nSpecs,
                              Rbc_OpSpec *specArr, int operPos, int argc, char **argv, int flags));

Rbc_Op Rbc_GetOpFromObj _ANSI_ARGS_((Tcl_Interp *interp,
                                     int nSpecs, Rbc_OpSpec *specArr, int operPos, int objc,
                                     Tcl_Obj *CONST *objv, int flags));

void Rbc_Draw3DRectangle _ANSI_ARGS_((Tk_Window tkwin, Drawable drawable,
                                      Tk_3DBorder border, int x, int y, int width, int height,
                                      int borderWidth, int relief));
void Rbc_Fill3DRectangle _ANSI_ARGS_((Tk_Window tkwin, Drawable drawable,
                                      Tk_3DBorder border, int x, int y, int width, int height,
                                      int borderWidth, int relief));

#ifdef notdef
#define Rbc_Fill3DRectangle	Tk_Fill3DRectangle
#define Rbc_Draw3DRectangle	Tk_Draw3DRectangle
#endif

/* ---------------------------------------------------------------- */

#define PIXELS_NONNEGATIVE	0
#define PIXELS_POSITIVE		1
#define PIXELS_ANY		2

#define COUNT_NONNEGATIVE	0
#define COUNT_POSITIVE		1
#define COUNT_ANY		2

#define RBC_SCROLL_MODE_CANVAS	(1<<0)
#define RBC_SCROLL_MODE_LISTBOX	(1<<1)
#define RBC_SCROLL_MODE_HIERBOX	(1<<2)

#define RGB_ANTIQUEWHITE1	"#ffefdb"
#define RGB_BISQUE1		"#ffe4c4"
#define RGB_BISQUE2		"#eed5b7"
#define RGB_BISQUE3		"#cdb79e"
#define RGB_BLACK		"#000000"
#define RGB_BLUE		"#0000ff"
#define RGB_GREEN		"#00ff00"
#define RGB_GREY		"#b0b0b0"
#define RGB_GREY15		"#262626"
#define RGB_GREY50		"#7f7f7f"
#define RGB_GREY64		"#a3a3a3"
#define RGB_GREY70		"#b3b3b3"
#define RGB_GREY75		"#bfbfbf"
#define RGB_GREY77		"#c3c3c3"
#define RGB_GREY82		"#d1d1d1"
#define RGB_GREY85		"#d9d9d9"
#define RGB_GREY90		"#e5e5e5"
#define RGB_GREY95		"#f2f2f2"
#define RGB_LIGHTBLUE0		"#e4f7ff"
#define RGB_LIGHTBLUE1		"#bfefff"
#define RGB_LIGHTBLUE2		"#b2dfee"
#define RGB_LIGHTSKYBLUE1	"#b0e2ff"
#define RGB_MAROON		"#b03060"
#define RGB_NAVYBLUE		"#000080"
#define RGB_PINK		"#ffc0cb"
#define RGB_BISQUE1		"#ffe4c4"
#define RGB_RED			"#ff0000"
#define RGB_WHITE		"#ffffff"
#define RGB_YELLOW		"#ffff00"

#ifdef OLD_TK_COLORS
#define STD_NORMAL_BACKGROUND	RGB_BISQUE1
#define STD_ACTIVE_BACKGROUND	RGB_BISQUE2
#define STD_SELECT_BACKGROUND	RGB_LIGHTBLUE1
#define STD_DISABLE_FOREGROUND	RGB_GREY64
#else
#define STD_NORMAL_BACKGROUND	RGB_GREY85
#define STD_ACTIVE_BACKGROUND	RGB_GREY64
#define STD_SELECT_BACKGROUND	RGB_LIGHTBLUE1
#define STD_DISABLE_FOREGROUND	RGB_GREY64
#endif /* OLD_TK_COLORS */

#define STD_ACTIVE_BG_MONO	RGB_BLACK
#define STD_ACTIVE_FOREGROUND	RGB_BLACK
#define STD_ACTIVE_FG_MONO	RGB_WHITE
#define STD_BORDERWIDTH 	"2"
#define STD_FONT		"*-Helvetica-Medium-R-Normal-*-12-120-*"
#define STD_FONT_HUGE		"*-Helvetica-Medium-R-Normal-*-18-180-*"
#define STD_FONT_LARGE		"*-Helvetica-Medium-R-Normal-*-14-140-*"
#define STD_FONT_SMALL		"*-Helvetica-Medium-R-Normal-*-10-100-*"
#define STD_INDICATOR_COLOR	RGB_MAROON
#define STD_NORMAL_BG_MONO	RGB_WHITE
#define STD_NORMAL_FOREGROUND	RGB_BLACK
#define STD_NORMAL_FG_MONO	RGB_BLACK
#define STD_SELECT_BG_MONO	RGB_BLACK
#define STD_SELECT_BORDERWIDTH	"2"
#define STD_SELECT_FOREGROUND	RGB_BLACK
#define STD_SELECT_FG_MONO	RGB_WHITE
#define STD_SHADOW_COLOR	RGB_GREY64
#define STD_SHADOW_MONO		RGB_BLACK

#define LineWidth(w)	(((w) > 1) ? (w) : 0)

typedef char *DestroyData;


#ifndef TK_RELIEF_SOLID
#define TK_RELIEF_SOLID		TK_RELIEF_FLAT
#endif

#define NO_FLAGS			0
#define Rbc_FindPhoto(interp, name)	Tk_FindPhoto(interp, name)

typedef int (QSortCompareProc) _ANSI_ARGS_((const void *, const void *));

/*
 * ----------------------------------------------------------------------
 *
 * Rbc_Pad --
 *
 * 	Specifies vertical and horizontal padding.
 *
 *	Padding can be specified on a per side basis.  The fields
 *	side1 and side2 refer to the opposite sides, either
 *	horizontally or vertically.
 *
 *		side1	side2
 *              -----   -----
 *      x | left    right
 *	    y | top     bottom
 *
 * ----------------------------------------------------------------------
 */
typedef struct {
    short int side1, side2;
} Rbc_Pad;

#define padLeft  	padX.side1
#define padRight  	padX.side2
#define padTop		padY.side1
#define padBottom	padY.side2
#define PADDING(x)	((x).side1 + (x).side2)

/*
 * ----------------------------------------------------------------------
 *
 * The following enumerated values are used as bit flags.
 *	FILL_NONE		Neither coordinate plane is specified
 *	FILL_X			Horizontal plane.
 *	FILL_Y			Vertical plane.
 *	FILL_BOTH		Both vertical and horizontal planes.
 *
 * ----------------------------------------------------------------------
 */
#define FILL_NONE	0
#define FILL_X		1
#define FILL_Y		2
#define FILL_BOTH	3

/*
 * ----------------------------------------------------------------------
 *
 * Rbc_Dashes --
 *
 * 	List of dash values (maximum 11 based upon PostScript limit).
 *
 * ----------------------------------------------------------------------
 */
typedef struct {
    unsigned char values[12];
    int offset;
} Rbc_Dashes;

#define LineIsDashed(d) ((d).values[0] != 0)

void Rbc_SetDashes _ANSI_ARGS_((Display *display, GC gc, Rbc_Dashes *dashesPtr));
Rbc_Dashes *Rbc_GetDashes _ANSI_ARGS_((GC gc));

/*
 * -------------------------------------------------------------------
 *
 * Point2D --
 *
 *	2-D coordinate.
 *
 * -------------------------------------------------------------------
 */
typedef struct {
    double x, y;
} Point2D;

/*
 * -------------------------------------------------------------------
 *
 * Point3D --
 *
 *	3-D coordinate.
 *
 * -------------------------------------------------------------------
 */
typedef struct {
    double x, y, z;
} Point3D;

/*
 * -------------------------------------------------------------------
 *
 * Segment2D --
 *
 *	2-D line segment.
 *
 * -------------------------------------------------------------------
 */
typedef struct {
    Point2D p, q;		/* The two end points of the segment. */
} Segment2D;

/*
 * -------------------------------------------------------------------
 *
 * Dim2D --
 *
 *	2-D dimension.
 *
 * -------------------------------------------------------------------
 */
typedef struct {
    short int width, height;
} Dim2D;

/*
 *----------------------------------------------------------------------
 *
 * Region2D --
 *
 *      2-D region.  Used to copy parts of images.
 *
 *----------------------------------------------------------------------
 */
typedef struct {
    int left, right, top, bottom;
} Region2D;

#define RegionWidth(r)		((r)->right - (r)->left + 1)
#define RegionHeight(r)		((r)->bottom - (r)->top + 1)

typedef struct {
    double left, right, top, bottom;
} Extents2D;

typedef struct {
    double left, right, top, bottom, front, back;
} Extents3D;

#define PointInRegion(e,x,y) \
	(((x) <= (e)->right) && ((x) >= (e)->left) && \
	 ((y) <= (e)->bottom) && ((y) >= (e)->top))

#define PointInRectangle(r,x0,y0) \
	(((x0) <= (int)((r)->x + (r)->width - 1)) && ((x0) >= (int)(r)->x) && \
	 ((y0) <= (int)((r)->y + (r)->height - 1)) && ((y0) >= (int)(r)->y))


/* -------------------------------------------------------------------
 *
 * ColorPair --
 *
 *	Holds a pair of foreground, background colors.
 *
 * -------------------------------------------------------------------
 */
typedef struct {
    XColor *fgColor, *bgColor;
} ColorPair;

#define COLOR_NONE		(XColor *)0
#define COLOR_DEFAULT		(XColor *)1
#define COLOR_ALLOW_DEFAULTS	1

void Rbc_FreeColorPair _ANSI_ARGS_((ColorPair *pairPtr));

#define STATE_NORMAL	0
#define STATE_ACTIVE	(1<<0)
#define STATE_DISABLED	(1<<1)
#define STATE_EMPHASIS	(1<<2)


#define ARROW_LEFT		(0)
#define ARROW_UP		(1)
#define ARROW_RIGHT		(2)
#define ARROW_DOWN		(3)
#define ARROW_OFFSET		4
#define STD_ARROW_HEIGHT	3
#define STD_ARROW_WIDTH		((2 * (ARROW_OFFSET - 1)) + 1)

#include "rbcText.h"

/*
 * ----------------------------------------------------------------------
 *
 * 	X11/Xosdefs.h requires XNOSTDHDRS be set for some systems.
 *	This is a guess.  If I can't find STDC headers or unistd.h,
 *	assume that this is non-POSIX and non-STDC environment.
 *	(needed for Encore Umax 3.4 ?)
 *
 * ----------------------------------------------------------------------
 */
#if !defined(STDC_HEADERS) && !defined(HAVE_UNISTD_H)
#define XNOSTDHDRS 	1
#endif

char *Rbc_Itoa _ANSI_ARGS_((int value));
char *Rbc_Utoa _ANSI_ARGS_((unsigned int value));
char *Rbc_Dtoa _ANSI_ARGS_((Tcl_Interp *interp, double value));


int Rbc_NaturalSpline _ANSI_ARGS_((Point2D *origPts, int nOrigPts,
                                   Point2D *intpPts, int nIntpPts));

int Rbc_QuadraticSpline _ANSI_ARGS_((Point2D *origPts, int nOrigPts,
                                     Point2D *intpPts, int nIntpPts));

int Rbc_SimplifyLine _ANSI_ARGS_((Point2D *origPts, int low, int high,
                                  double tolerance, int indices[]));

int Rbc_NaturalParametricSpline _ANSI_ARGS_((Point2D *origPts,
        int nOrigPts, Extents2D *extsPtr, int isClosed, Point2D *intpPts,
        int nIntpPts));

int Rbc_CatromParametricSpline _ANSI_ARGS_((Point2D *origPts,
        int nOrigPts, Point2D *intpPts, int nIntpPts));

int Rbc_StringToFlag _ANSI_ARGS_((ClientData clientData,
                                  Tcl_Interp *interp, Tk_Window tkwin, char *string, char *widgRec,
                                  int flags));
char *Rbc_FlagToString _ANSI_ARGS_((ClientData clientData,
                                    Tk_Window tkwin, char *string, int offset, Tcl_FreeProc **freeProc));

void Rbc_InitHexTable _ANSI_ARGS_((char *table));

GC Rbc_GetPrivateGC _ANSI_ARGS_((Tk_Window tkwin, unsigned long gcMask,
                                 XGCValues *valuePtr));

GC Rbc_GetPrivateGCFromDrawable _ANSI_ARGS_((Display *display,
        Drawable drawable, unsigned long gcMask, XGCValues *valuePtr));

void Rbc_FreePrivateGC _ANSI_ARGS_((Display *display, GC gc));

Tk_Window Rbc_FindChild _ANSI_ARGS_((Tk_Window parent, char *name));

Tk_Window Rbc_FirstChild _ANSI_ARGS_((Tk_Window parent));

Tk_Window Rbc_NextChild _ANSI_ARGS_((Tk_Window tkwin));

void Rbc_RelinkWindow _ANSI_ARGS_((Tk_Window tkwin, Tk_Window newParent,
                                   int x, int y));

Tk_Window Rbc_Toplevel _ANSI_ARGS_((Tk_Window tkwin));

int Rbc_GetPixels _ANSI_ARGS_((Tcl_Interp *interp, Tk_Window tkwin,
                               char *string, int check, int *valuePtr));
int Rbc_GetPosition _ANSI_ARGS_((Tcl_Interp *interp, char *string,
                                 int *indexPtr));

char *Rbc_NameOfFill _ANSI_ARGS_((int fill));

int Rbc_GetXY _ANSI_ARGS_((Tcl_Interp *interp, Tk_Window tkwin,
                           char *string, int *x, int *y));

Point2D Rbc_GetProjection _ANSI_ARGS_((int x, int y, Point2D *p,
                                       Point2D *q));

void Rbc_DrawArrow _ANSI_ARGS_((Display *display, Drawable drawable,
                                GC gc, int x, int y, int arrowHeight, int orientation));

Tk_OptionParseProc Rbc_StringToEnum;
Tk_OptionPrintProc Rbc_EnumToString;

int Rbc_ConfigModified _ANSI_ARGS_(TCL_VARARGS(Tk_ConfigSpec *, specs));

void Rbc_DStringAppendElements _ANSI_ARGS_(TCL_VARARGS(Tcl_DString *, args));

void Rbc_MakeTransparentWindowExist _ANSI_ARGS_((Tk_Window tkwin,
        Window parent, int isBusy));

Window Rbc_GetParent _ANSI_ARGS_((Display *display, Window tkwin));

void Rbc_GetBoundingBox _ANSI_ARGS_((int width, int height,
                                     double theta, double *widthPtr, double *heightPtr, Point2D *points));

void Rbc_InitEpsCanvasItem _ANSI_ARGS_((Tcl_Interp *interp));

void Rbc_TranslateAnchor _ANSI_ARGS_((int x, int y, int width,
                                      int height, Tk_Anchor anchor, int *transXPtr, int *transYPtr));

Point2D Rbc_TranslatePoint _ANSI_ARGS_((Point2D *pointPtr, int width,
                                        int height, Tk_Anchor anchor));

int Rbc_ConfigureWidgetComponent _ANSI_ARGS_((Tcl_Interp *interp,
        Tk_Window tkwin, char *name, char *class, Tk_ConfigSpec *specs,
        int argc, char **argv, char *widgRec, int flags));

int Rbc_MaxRequestSize _ANSI_ARGS_((Display *display,
                                    unsigned int elemSize));

Window Rbc_GetRealWindowId _ANSI_ARGS_((Tk_Window tkwin));
int Rbc_RootX _ANSI_ARGS_((Tk_Window tkwin));
int Rbc_RootY _ANSI_ARGS_((Tk_Window tkwin));
void Rbc_RootCoordinates _ANSI_ARGS_((Tk_Window tkwin, int x, int y,
                                      int *rootXPtr, int *rootYPtr));
void Rbc_MapToplevel _ANSI_ARGS_((Tk_Window tkwin));
void Rbc_UnmapToplevel _ANSI_ARGS_((Tk_Window tkwin));
void Rbc_RaiseToplevel _ANSI_ARGS_((Tk_Window tkwin));
void Rbc_LowerToplevel _ANSI_ARGS_((Tk_Window tkwin));
void Rbc_ResizeToplevel _ANSI_ARGS_((Tk_Window tkwin,
                                     int width, int height));
void Rbc_MoveToplevel _ANSI_ARGS_((Tk_Window tkwin, int x, int y));
void Rbc_MoveResizeToplevel _ANSI_ARGS_((Tk_Window tkwin,
                                        int x, int y, int width, int height));
ClientData Rbc_GetWindowInstanceData _ANSI_ARGS_((Tk_Window tkwin));

void Rbc_SetWindowInstanceData _ANSI_ARGS_((Tk_Window tkwin,
        ClientData instanceData));

void Rbc_DeleteWindowInstanceData _ANSI_ARGS_((Tk_Window tkwin));

int Rbc_AdjustViewport _ANSI_ARGS_((int offset, int worldSize,
                                    int windowSize, int scrollUnits, int scrollMode));

int Rbc_GetScrollInfo _ANSI_ARGS_((Tcl_Interp *interp, int argc,
                                   char **argv, int *offsetPtr, int worldSize, int windowSize,
                                   int scrollUnits, int scrollMode));

int Rbc_GetScrollInfoFromObj _ANSI_ARGS_((Tcl_Interp *interp, int objc,
        Tcl_Obj *CONST *objv, int *offsetPtr, int worldSize, int windowSize,
        int scrollUnits, int scrollMode));

void Rbc_UpdateScrollbar _ANSI_ARGS_((Tcl_Interp *interp,
                                      char *scrollCmd, double firstFract, double lastFract));

int Rbc_ReparentWindow _ANSI_ARGS_((Display *display, Window window,
                                    Window newParent, int x, int y));

#if defined(HAVE_JPEGLIB_H) || defined(HAVE_IJL_H)
#define HAVE_JPEG 1
int Rbc_JPEGToPhoto _ANSI_ARGS_((Tcl_Interp *interp, char *fileName,
                                 Tk_PhotoHandle photo));
#endif /* HAVE_JPEGLIB_H || HAVE_IJL_H */

#define Rbc_SetBooleanResult(i, b) \
	Tcl_SetResult((i), (b) ? "1" : "0", TCL_STATIC)

/*
 * Define this if you want to be able to tile to the main window "."
 * This will cause a conflict with Tk if you try to compile and link
 * statically.
 */
#undef TILE_MAINWINDOW

#ifdef WIN32
#if (TCL_MAJOR_VERSION == 8)  && (TCL_MINOR_VERSION == 0)
#else
#define NO_DDE		1
#endif
#else
#define NO_DDE		1
#define NO_PRINTER	1
#endif /* WIN32 */

#if (TCL_MAJOR_VERSION == 7)
#define NO_TREE		1
#define NO_ARRAY	1
#define NO_TREEVIEW	1
#endif

#ifndef NO_BUSY
Tcl_AppInitProc Rbc_BusyInit;
#endif
#ifndef NO_GRAPH
Tcl_AppInitProc Rbc_GraphInit;
#endif
#ifndef NO_VECTOR
Tcl_AppInitProc Rbc_VectorInit;
#endif
#ifndef NO_WINOP
Tcl_AppInitProc Rbc_WinopInit;
#endif
#ifndef NO_SPLINE
Tcl_AppInitProc Rbc_SplineInit;
#endif

char *RbcStrdup _ANSI_ARGS_((CONST char *ptr));
void *RbcCalloc _ANSI_ARGS_((unsigned int nElem, size_t size));

#ifdef WIN32
#include "rbcWin.h"
#endif

#ifndef WIN32
#define PurifyPrintf  printf
#endif /* WIN32 */

#endif /* _RBCINT */
