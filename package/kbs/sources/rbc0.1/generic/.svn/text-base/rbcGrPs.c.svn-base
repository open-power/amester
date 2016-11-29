/*
 * rbcGrPs.c --
 *
 *      This module implements the "postscript" operation for rbc
 *      graph widget.
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#include "rbcGraph.h"
#include <X11/Xutil.h>
#include <stdarg.h>

#define PS_PREVIEW_EPSI	0
#define PS_PREVIEW_WMF	1
#define PS_PREVIEW_TIFF	2

static Tk_OptionParseProc StringToColorMode;
static Tk_OptionPrintProc ColorModeToString;
static Tk_CustomOption colorModeOption = {
    StringToColorMode, ColorModeToString, (ClientData)0,
};
static Tk_OptionParseProc StringToFormat;
static Tk_OptionPrintProc FormatToString;
static Tk_CustomOption formatOption = {
    StringToFormat, FormatToString, (ClientData)0,
};
extern Tk_CustomOption rbcDistanceOption;
extern Tk_CustomOption rbcPositiveDistanceOption;
extern Tk_CustomOption rbcPadOption;

#define DEF_PS_CENTER		"yes"
#define DEF_PS_COLOR_MAP	(char *)NULL
#define DEF_PS_COLOR_MODE	"color"
#define DEF_PS_DECORATIONS	"yes"
#define DEF_PS_FONT_MAP		(char *)NULL
#define DEF_PS_FOOTER		"no"
#define DEF_PS_HEIGHT		"0"
#define DEF_PS_LANDSCAPE	"no"
#define DEF_PS_MAXPECT		"no"
#define DEF_PS_PADX		"1.0i"
#define DEF_PS_PADY		"1.0i"
#define DEF_PS_PAPERHEIGHT	"11.0i"
#define DEF_PS_PAPERWIDTH	"8.5i"
#define DEF_PS_PREVIEW		"no"
#define DEF_PS_PREVIEW_FORMAT   "epsi"
#define DEF_PS_WIDTH		"0"

static Tk_ConfigSpec configSpecs[] = {
    {TK_CONFIG_BOOLEAN, "-center", "center", "Center",
        DEF_PS_CENTER, Tk_Offset(PostScript, center),
        TK_CONFIG_DONT_SET_DEFAULT},
    {TK_CONFIG_STRING, "-colormap", "colorMap", "ColorMap",
     DEF_PS_COLOR_MAP, Tk_Offset(PostScript, colorVarName),
     TK_CONFIG_NULL_OK},
    {TK_CONFIG_CUSTOM, "-colormode", "colorMode", "ColorMode",
     DEF_PS_COLOR_MODE, Tk_Offset(PostScript, colorMode),
     TK_CONFIG_DONT_SET_DEFAULT, &colorModeOption},
    {TK_CONFIG_BOOLEAN, "-decorations", "decorations", "Decorations",
     DEF_PS_DECORATIONS, Tk_Offset(PostScript, decorations),
     TK_CONFIG_DONT_SET_DEFAULT},
    {TK_CONFIG_STRING, "-fontmap", "fontMap", "FontMap",
     DEF_PS_FONT_MAP, Tk_Offset(PostScript, fontVarName),
     TK_CONFIG_NULL_OK},
    {TK_CONFIG_BOOLEAN, "-footer", "footer", "Footer",
     DEF_PS_FOOTER, Tk_Offset(PostScript, footer),
     TK_CONFIG_DONT_SET_DEFAULT},
    {TK_CONFIG_CUSTOM, "-height", "height", "Height",
     DEF_PS_HEIGHT, Tk_Offset(PostScript, reqHeight),
     TK_CONFIG_DONT_SET_DEFAULT, &rbcDistanceOption},
    {TK_CONFIG_BOOLEAN, "-landscape", "landscape", "Landscape",
     DEF_PS_LANDSCAPE, Tk_Offset(PostScript, landscape),
     TK_CONFIG_DONT_SET_DEFAULT},
    {TK_CONFIG_BOOLEAN, "-maxpect", "maxpect", "Maxpect",
     DEF_PS_MAXPECT, Tk_Offset(PostScript, maxpect),
     TK_CONFIG_DONT_SET_DEFAULT},
    {TK_CONFIG_CUSTOM, "-padx", "padX", "PadX",
     DEF_PS_PADX, Tk_Offset(PostScript, padX), 0, &rbcPadOption},
    {TK_CONFIG_CUSTOM, "-pady", "padY", "PadY",
     DEF_PS_PADY, Tk_Offset(PostScript, padY), 0, &rbcPadOption},
    {TK_CONFIG_CUSTOM, "-paperheight", "paperHeight", "PaperHeight",
     DEF_PS_PAPERHEIGHT, Tk_Offset(PostScript, reqPaperHeight),
     0, &rbcPositiveDistanceOption},
    {TK_CONFIG_CUSTOM, "-paperwidth", "paperWidth", "PaperWidth",
     DEF_PS_PAPERWIDTH, Tk_Offset(PostScript, reqPaperWidth),
     0, &rbcPositiveDistanceOption},
    {TK_CONFIG_BOOLEAN, "-preview", "preview", "Preview",
     DEF_PS_PREVIEW, Tk_Offset(PostScript, addPreview),
     TK_CONFIG_DONT_SET_DEFAULT},
    {TK_CONFIG_CUSTOM, "-previewformat", "previewFormat", "PreviewFormat",
     DEF_PS_PREVIEW_FORMAT, Tk_Offset(PostScript, previewFormat),
     TK_CONFIG_DONT_SET_DEFAULT, &formatOption},
    {TK_CONFIG_CUSTOM, "-width", "width", "Width",
     DEF_PS_WIDTH, Tk_Offset(PostScript, reqWidth),
     TK_CONFIG_DONT_SET_DEFAULT, &rbcDistanceOption},
    {TK_CONFIG_END, NULL, NULL, NULL, NULL, 0, 0}
};

/* TODO: These do not belong here */
extern void Rbc_MarkersToPostScript _ANSI_ARGS_((Graph *graphPtr, PsToken psToken, int under));
extern void Rbc_ElementsToPostScript _ANSI_ARGS_((Graph *graphPtr, PsToken psToken));
extern void Rbc_ActiveElementsToPostScript _ANSI_ARGS_((Graph *graphPtr, PsToken psToken));
extern void Rbc_LegendToPostScript _ANSI_ARGS_((Legend *legendPtr, PsToken psToken));
extern void Rbc_GridToPostScript _ANSI_ARGS_((Graph *graphPtr, PsToken psToken));
extern void Rbc_AxesToPostScript _ANSI_ARGS_((Graph *graphPtr, PsToken psToken));
extern void Rbc_AxisLimitsToPostScript _ANSI_ARGS_((Graph *graphPtr, PsToken psToken));

static char *NameOfColorMode _ANSI_ARGS_((PsColorMode colorMode));
static int CgetOp _ANSI_ARGS_((Graph *graphPtr, Tcl_Interp *interp, int argc, char *argv[]));
static int ConfigureOp _ANSI_ARGS_((Graph *graphPtr, Tcl_Interp *interp, int argc, char **argv));
static int OutputOp _ANSI_ARGS_((Graph *graphPtr, Tcl_Interp *interp, int argc, char **argv));
static int ComputeBoundingBox _ANSI_ARGS_((Graph *graphPtr, PostScript *psPtr));
static void PreviewImage _ANSI_ARGS_((Graph *graphPtr, PsToken psToken));
static int PostScriptPreamble _ANSI_ARGS_((Graph *graphPtr, char *fileName, PsToken psToken));
static void MarginsToPostScript _ANSI_ARGS_((Graph *graphPtr, PsToken psToken));
static int GraphToPostScript _ANSI_ARGS_((Graph *graphPtr, char *ident, PsToken psToken));

#ifdef WIN32
static int CreateWindowsEPS _ANSI_ARGS_((Graph *graphPtr, PsToken psToken, FILE *f));
#endif

/*
 *----------------------------------------------------------------------
 *
 * StringToColorMode --
 *
 *      Convert the string representation of a PostScript color mode
 *      into the enumerated type representing the color level:
 *
 *          PS_MODE_COLOR 	- Full color
 *          PS_MODE_GREYSCALE  	- Color converted to greyscale
 *          PS_MODE_MONOCHROME 	- Only black and white
 *
 * Results:
 *      A standard Tcl result.  The color level is written into the
 *      page layout information structure.
 *
 * Side Effects:
 *      Future invocations of the "postscript" option will use this
 *      variable to determine how color information will be displayed
 *      in the PostScript output it produces.
 *
 *----------------------------------------------------------------------
 */
static int
StringToColorMode(clientData, interp, tkwin, string, widgRec, offset)
    ClientData clientData; /* Not used. */
    Tcl_Interp *interp; /* Interpreter to send results back to */
    Tk_Window tkwin; /* Not used. */
    CONST84 char *string; /* New value. */
    char *widgRec; /* Widget record */
    int offset; /* Offset of field in record */
{
    PsColorMode *modePtr = (PsColorMode *) (widgRec + offset);
    unsigned int length;
    char c;

    c = string[0];
    length = strlen(string);
    if ((c == 'c') && (strncmp(string, "color", length) == 0)) {
        *modePtr = PS_MODE_COLOR;
    } else if ((c == 'g') && (strncmp(string, "grayscale", length) == 0)) {
        *modePtr = PS_MODE_GREYSCALE;
    } else if ((c == 'g') && (strncmp(string, "greyscale", length) == 0)) {
        *modePtr = PS_MODE_GREYSCALE;
    } else if ((c == 'm') && (strncmp(string, "monochrome", length) == 0)) {
        *modePtr = PS_MODE_MONOCHROME;
    } else {
        Tcl_AppendResult(interp, "bad color mode \"", string, "\": should be \
\"color\", \"greyscale\", or \"monochrome\"", (char *)NULL);
        return TCL_ERROR;
    }
    return TCL_OK;
}

/*
 *----------------------------------------------------------------------
 *
 * NameOfColorMode --
 *
 *      Convert the PostScript mode value into the string representing
 *      a valid color mode.
 *
 * Results:
 *      The static string representing the color mode is returned.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
static char *
NameOfColorMode(colorMode)
    PsColorMode colorMode;
{
    switch (colorMode) {
        case PS_MODE_COLOR:
            return "color";
        case PS_MODE_GREYSCALE:
            return "greyscale";
        case PS_MODE_MONOCHROME:
            return "monochrome";
        default:
            return "unknown color mode";
    }
}

/*
 *----------------------------------------------------------------------
 *
 * ColorModeToString --
 *
 *      Convert the current color mode into the string representing a
 *      valid color mode.
 *
 * Results:
 *      The string representing the color mode is returned.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
static char *
ColorModeToString(clientData, tkwin, widgRec, offset, freeProcPtr)
    ClientData clientData; /* Not used. */
    Tk_Window tkwin; /* Not used. */
    char *widgRec; /* Widget record. */
    int offset; /* field of colorMode in record */
    Tcl_FreeProc **freeProcPtr; /* Not used. */
{
    PsColorMode mode = *(PsColorMode *) (widgRec + offset);

    return NameOfColorMode(mode);
}

/*
 *----------------------------------------------------------------------
 *
 * StringToFormat --
 *
 *      Convert the string of the PostScript preview format into
 *      an enumerated type representing the desired format.  The
 *      available formats are:
 *
 *        PS_PREVIEW_WMF 	- Windows Metafile.
 *        PS_PREVIEW_TIFF  	- TIFF bitmap image.
 *        PS_PREVIEW_EPSI 	- Device independent ASCII preview
 *
 * Results:
 *      A standard Tcl result.  The format is written into the
 *      page layout information structure.
 *
 * Side Effects:
 *      Future invocations of the "postscript" option will use this
 *      variable to determine how to format a preview image (if one
 *      is selected) when the PostScript output is produced.
 *
 *----------------------------------------------------------------------
 */
static int
StringToFormat(clientData, interp, tkwin, string, widgRec, offset)
    ClientData clientData; /* Not used. */
    Tcl_Interp *interp; /* Interpreter to send results back to */
    Tk_Window tkwin; /* Not used. */
    CONST84 char *string; /* New value. */
    char *widgRec; /* Widget record */
    int offset; /* Offset of field in record */
{
    int *formatPtr = (int *) (widgRec + offset);
    unsigned int length;
    char c;

    c = string[0];
    length = strlen(string);
    if ((c == 'c') && (strncmp(string, "epsi", length) == 0)) {
        *formatPtr = PS_PREVIEW_EPSI;
#ifdef WIN32
#ifdef HAVE_TIFF_H
    } else if ((c == 't') && (strncmp(string, "tiff", length) == 0)) {
        *formatPtr = PS_PREVIEW_TIFF;
#endif /* HAVE_TIFF_H */
    } else if ((c == 'w') && (strncmp(string, "wmf", length) == 0)) {
        *formatPtr = PS_PREVIEW_WMF;
#endif /* WIN32 */
    } else {
        Tcl_AppendResult(interp, "bad format \"", string, "\": should be ",
#ifdef WIN32
#ifdef HAVE_TIFF_H
                         "\"tiff\" or ",
#endif /* HAVE_TIFF_H */
                         "\"wmf\" or ",
#endif /* WIN32 */
                         "\"epsi\"", (char *)NULL);
        return TCL_ERROR;
    }
    return TCL_OK;
}

/*
 *----------------------------------------------------------------------
 *
 * FormatToString --
 *
 *      Convert the preview format into the string representing its
 *      type.
 *
 * Results:
 *      The string representing the preview format is returned.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
static char *
FormatToString(clientData, tkwin, widgRec, offset, freeProcPtr)
    ClientData clientData; /* Not used. */
    Tk_Window tkwin; /* Not used. */
    char *widgRec; /* PostScript structure record */
    int offset; /* field of colorMode in record */
    Tcl_FreeProc **freeProcPtr; /* Not used. */
{
    int format = *(int *)(widgRec + offset);

    switch (format) {
        case PS_PREVIEW_EPSI:
            return "epsi";
        case PS_PREVIEW_WMF:
            return "wmf";
        case PS_PREVIEW_TIFF:
            return "tiff";
    }
    return "?unknown preview format?";
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_DestroyPostScript --
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
void
Rbc_DestroyPostScript(graphPtr)
    Graph *graphPtr;
{
    Tk_FreeOptions(configSpecs, (char *)graphPtr->postscript,
                   graphPtr->display, 0);
    ckfree((char *)graphPtr->postscript);
}

/*
 *--------------------------------------------------------------
 *
 * CgetOp --
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
CgetOp(graphPtr, interp, argc, argv)
    Graph *graphPtr;
    Tcl_Interp *interp;
    int argc;
    char *argv[];
{
    PostScript *psPtr = (PostScript *)graphPtr->postscript;

    if (Tk_ConfigureValue(interp, graphPtr->tkwin, configSpecs, (char *)psPtr,
                          argv[3], 0) != TCL_OK) {
        return TCL_ERROR;
    }
    return TCL_OK;
}

/*
 * ----------------------------------------------------------------------
 *
 * ConfigureOp --
 *
 *      This procedure is invoked to print the graph in a file.
 *
 * Results:
 *      A standard TCL result.
 *
 * Side effects:
 *      A new PostScript file is created.
 *
 * ----------------------------------------------------------------------
 */
static int
ConfigureOp(graphPtr, interp, argc, argv)
    Graph *graphPtr;
    Tcl_Interp *interp;
    int argc; /* Number of options in argv vector */
    char **argv; /* Option vector */
{
    int flags = TK_CONFIG_ARGV_ONLY;
    PostScript *psPtr = (PostScript *)graphPtr->postscript;

    if (argc == 3) {
        return Tk_ConfigureInfo(interp, graphPtr->tkwin, configSpecs,
                                (char *)psPtr, (char *)NULL, flags);
    } else if (argc == 4) {
        return Tk_ConfigureInfo(interp, graphPtr->tkwin, configSpecs,
                                (char *)psPtr, argv[3], flags);
    }
    if (Tk_ConfigureWidget(interp, graphPtr->tkwin, configSpecs, argc - 3, argv + 3, (char *)psPtr, flags) != TCL_OK) {
        return TCL_ERROR;
    }
    return TCL_OK;
}

/*
 * --------------------------------------------------------------------------
 *
 * ComputeBoundingBox --
 *
 *      Computes the bounding box for the PostScript plot.  First get
 *      the size of the plot (by default, it's the size of graph's X
 *      window).  If the plot plus the page border is bigger than the
 *      designated paper size, or if the "-maxpect" option is turned
 *      on, scale the plot to the page.
 *
 *      Note: All coordinates/sizes are in screen coordinates, not
 *            PostScript coordinates.  This includes the computed
 *            bounding box and paper size.  They will be scaled to
 *            printer points later.
 *
 * Results:
 *      Returns the height of the paper in screen coordinates.
 *
 * Side Effects:
 *      The graph dimensions (width and height) are changed to the
 *      requested PostScript plot size.
 *
 * --------------------------------------------------------------------------
 */
static int
ComputeBoundingBox(graphPtr, psPtr)
    Graph *graphPtr;
    PostScript *psPtr;
{
    int paperWidth, paperHeight;
    int x, y, hSize, vSize, hBorder, vBorder;
    double hScale, vScale, scale;

    x = psPtr->padLeft;
    y = psPtr->padTop;
    hBorder = PADDING(psPtr->padX);
    vBorder = PADDING(psPtr->padY);

    if (psPtr->reqWidth > 0) {
        graphPtr->width = psPtr->reqWidth;
    }
    if (psPtr->reqHeight > 0) {
        graphPtr->height = psPtr->reqHeight;
    }
    if (psPtr->landscape) {
        hSize = graphPtr->height;
        vSize = graphPtr->width;
    } else {
        hSize = graphPtr->width;
        vSize = graphPtr->height;
    }
    /*
     * If the paper size wasn't specified, set it to the graph size plus
     * the paper border.
     */
    paperWidth = psPtr->reqPaperWidth;
    paperHeight = psPtr->reqPaperHeight;
    if (paperWidth < 1) {
        paperWidth = hSize + hBorder;
    }
    if (paperHeight < 1) {
        paperHeight = vSize + vBorder;
    }
    hScale = vScale = 1.0;
    /*
     * Scale the plot size (the graph itself doesn't change size) if
     * it's bigger than the paper or if -maxpect was set.
     */
    if ((psPtr->maxpect) || ((hSize + hBorder) > paperWidth)) {
        hScale = (double)(paperWidth - hBorder) / (double)hSize;
    }
    if ((psPtr->maxpect) || ((vSize + vBorder) > paperHeight)) {
        vScale = (double)(paperHeight - vBorder) / (double)vSize;
    }
    scale = MIN(hScale, vScale);
    if (scale != 1.0) {
        hSize = (int)((hSize * scale) + 0.5);
        vSize = (int)((vSize * scale) + 0.5);
    }
    psPtr->pageScale = scale;
    if (psPtr->center) {
        if (paperWidth > hSize) {
            x = (paperWidth - hSize) / 2;
        }
        if (paperHeight > vSize) {
            y = (paperHeight - vSize) / 2;
        }
    }
    psPtr->left = x;
    psPtr->bottom = y;
    psPtr->right = x + hSize - 1;
    psPtr->top = y + vSize - 1;

    graphPtr->flags |= LAYOUT_NEEDED | MAP_WORLD;
    Rbc_LayoutGraph(graphPtr);
    return paperHeight;
}

/*
 * --------------------------------------------------------------------------
 *
 * PreviewImage --
 *
 *      Generates a EPSI thumbnail of the graph.  The thumbnail is
 *      restricted to a certain size.  This is to keep the size of the
 *      PostScript file small and the processing time low.
 *
 *      The graph is drawn into a pixmap.  We then take a snapshot
 *      of that pixmap, and rescale it to a smaller image.  Finally,
 *       the image is dumped to PostScript.
 *
 * Results:
 *      None.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 * --------------------------------------------------------------------------
 */
static void
PreviewImage(graphPtr, psToken)
    Graph *graphPtr;
    PsToken psToken;
{
    PostScript *psPtr = (PostScript *)graphPtr->postscript;
    int noBackingStore = 0;
    Pixmap drawable;
    Rbc_ColorImage image;
    int nLines;
    Tcl_DString dString;

    /* Create a pixmap and draw the graph into it. */

    drawable = Tk_GetPixmap(graphPtr->display, Tk_WindowId(graphPtr->tkwin),
                            graphPtr->width, graphPtr->height, Tk_Depth(graphPtr->tkwin));
    Rbc_DrawGraph(graphPtr, drawable, noBackingStore);

    /* Get a color image from the pixmap */
    image = Rbc_DrawableToColorImage(graphPtr->tkwin, drawable, 0, 0, graphPtr->width, graphPtr->height, 1.0);
    Tk_FreePixmap(graphPtr->display, drawable);
    if (image == NULL) {
        return;			/* Can't grab pixmap? */
    }
#ifdef THUMBNAIL_PREVIEW
    {
        double scale, xScale, yScale;
        int width, height;
        Rbc_ColorImage destImage;

        /* Scale the source image into a size appropriate for a thumbnail. */
#define PS_MAX_PREVIEW_WIDTH	300.0
#define PS_MAX_PREVIEW_HEIGHT	300.0
        xScale = PS_MAX_PREVIEW_WIDTH / (double)graphPtr->width;
        yScale = PS_MAX_PREVIEW_HEIGHT / (double)graphPtr->height;
        scale = MIN(xScale, yScale);

        width = (int)(scale * graphPtr->width + 0.5);
        height = (int)(scale * graphPtr->height + 0.5);
        destImage = Rbc_ResampleColorImage(image, width, height,
                                           rbcBoxFilterPtr, rbcBoxFilterPtr);
        Rbc_FreeColorImage(image);
        image = destImage;
    }
#endif /* THUMBNAIL_PREVIEW */
    Rbc_ColorImageToGreyscale(image);
    if (psPtr->landscape) {
        Rbc_ColorImage oldImage;

        oldImage = image;
        image = Rbc_RotateColorImage(image, 90.0);
        Rbc_FreeColorImage(oldImage);
    }
    Tcl_DStringInit(&dString);
    /* Finally, we can generate PostScript for the image */
    nLines = Rbc_ColorImageToPsData(image, 1, &dString, "%");

    Rbc_AppendToPostScript(psToken, "%%BeginPreview: ", (char *)NULL);
    Rbc_FormatToPostScript(psToken, "%d %d 8 %d\n", Rbc_ColorImageWidth(image),
                           Rbc_ColorImageHeight(image), nLines);
    Rbc_AppendToPostScript(psToken, Tcl_DStringValue(&dString), (char *)NULL);
    Rbc_AppendToPostScript(psToken, "%%EndPreview\n\n", (char *)NULL);
    Tcl_DStringFree(&dString);
    Rbc_FreeColorImage(image);
}

#ifdef TIME_WITH_SYS_TIME
#include <sys/time.h>
#include <time.h>
#else
#ifdef HAVE_SYS_TIME_H
#include <sys/time.h>
#else
#include <time.h>
#endif /* HAVE_SYS_TIME_H */
#endif /* TIME_WITH_SYS_TIME */

/*
 *--------------------------------------------------------------
 *
 * PostScriptPreamble --
 *
 *      The PostScript preamble calculates the needed
 *      translation and scaling to make X11 coordinates
 *      compatible with PostScript.
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
PostScriptPreamble(graphPtr, fileName, psToken)
    Graph *graphPtr;
    char *fileName;
    PsToken psToken;
{
    PostScript *psPtr = (PostScript *)graphPtr->postscript;
    time_t ticks;
    char date[200];		/* Hold the date string from ctime() */
    CONST char *version;
    double dpiX, dpiY;
    double xPixelsToPica, yPixelsToPica; /* Scales to convert pixels to pica */
    Screen *screenPtr;
    char *nl;
    int paperHeightPixels;

    paperHeightPixels = ComputeBoundingBox(graphPtr, psPtr);
    if (fileName == NULL) {
        fileName = Tk_PathName(graphPtr->tkwin);
    }
    Rbc_AppendToPostScript(psToken, "%!PS-Adobe-3.0 EPSF-3.0\n",
                           (char *)NULL);

    /*
     * Compute the scale factors to convert PostScript to X11 coordinates.
     * Round the pixels per inch (dpi) to an integral value before computing
     * the scale.
     */
#define MM_INCH		25.4
#define PICA_INCH	72.0
    screenPtr = Tk_Screen(graphPtr->tkwin);
    dpiX = (WidthOfScreen(screenPtr) * MM_INCH) / WidthMMOfScreen(screenPtr);
    xPixelsToPica = PICA_INCH / dpiX;
    dpiY = (HeightOfScreen(screenPtr) * MM_INCH) / HeightMMOfScreen(screenPtr);
    yPixelsToPica = PICA_INCH / dpiY;

    /*
     * The "BoundingBox" comment is required for EPS files. The box
     * coordinates are integers, so we need round away from the
     * center of the box.
     */
    Rbc_FormatToPostScript(psToken, "%%%%BoundingBox: %d %d %d %d\n",
                           (int)floor(psPtr->left * xPixelsToPica),
                           (int)floor((paperHeightPixels - psPtr->top) * yPixelsToPica),
                           (int)ceil(psPtr->right * xPixelsToPica),
                           (int)ceil((paperHeightPixels - psPtr->bottom) * yPixelsToPica));

    Rbc_AppendToPostScript(psToken, "%%Pages: 0\n", (char *)NULL);

    version = Tcl_GetVar(graphPtr->interp, "rbc_version", TCL_GLOBAL_ONLY);
    if (version == NULL) {
        version = "???";
    }
    Rbc_FormatToPostScript(psToken, "%%%%Creator: (Rbc %s %s)\n", version,
                           Tk_Class(graphPtr->tkwin));

    ticks = time((time_t *) NULL);
    strcpy(date, ctime(&ticks));
    nl = date + strlen(date) - 1;
    if (*nl == '\n') {
        *nl = '\0';
    }
    Rbc_FormatToPostScript(psToken, "%%%%CreationDate: (%s)\n", date);
    Rbc_FormatToPostScript(psToken, "%%%%Title: (%s)\n", fileName);
    Rbc_AppendToPostScript(psToken, "%%DocumentData: Clean7Bit\n",
                           (char *)NULL);
    if (psPtr->landscape) {
        Rbc_AppendToPostScript(psToken, "%%Orientation: Landscape\n",
                               (char *)NULL);
    } else {
        Rbc_AppendToPostScript(psToken, "%%Orientation: Portrait\n",
                               (char *)NULL);
    }
    Rbc_AppendToPostScript(psToken,
                           "%%DocumentNeededResources: font Helvetica Courier\n", (char *)NULL);
    Rbc_AppendToPostScript(psToken, "%%EndComments\n\n", (char *)NULL);
    if ((psPtr->addPreview) && (psPtr->previewFormat == PS_PREVIEW_EPSI)) {
        PreviewImage(graphPtr, psToken);
    }
    if (Rbc_FileToPostScript(psToken, "rbcGraph.pro") != TCL_OK) {
        return TCL_ERROR;
    }
    if (psPtr->footer) {
        char *who;

        who = getenv("LOGNAME");
        if (who == NULL) {
            who = "???";
        }
        Rbc_AppendToPostScript(psToken,
                               "8 /Helvetica SetFont\n",
                               "10 30 moveto\n",
                               "(Date: ", date, ") show\n",
                               "10 20 moveto\n",
                               "(File: ", fileName, ") show\n",
                               "10 10 moveto\n",
                               "(Created by: ", who, "@", Tcl_GetHostName(), ") show\n",
                               "0 0 moveto\n",
                               (char *)NULL);
    }
    /*
     * Set the conversion from PostScript to X11 coordinates.  Scale
     * pica to pixels and flip the y-axis (the origin is the upperleft
     * corner).
     */
    Rbc_AppendToPostScript(psToken,
                           "% Transform coordinate system to use X11 coordinates\n\n",
                           "% 1. Flip y-axis over by reversing the scale,\n",
                           "% 2. Translate the origin to the other side of the page,\n",
                           "%    making the origin the upper left corner\n", (char *)NULL);
    Rbc_FormatToPostScript(psToken, "%g -%g scale\n", xPixelsToPica,
                           yPixelsToPica);
    /* Papersize is in pixels.  Translate the new origin *after*
     * changing the scale. */
    Rbc_FormatToPostScript(psToken, "0 %d translate\n\n",
                           -paperHeightPixels);
    Rbc_AppendToPostScript(psToken, "% User defined page layout\n\n",
                           "% Set color level\n", (char *)NULL);
    Rbc_FormatToPostScript(psToken, "/CL %d def\n\n", psPtr->colorMode);
    Rbc_FormatToPostScript(psToken, "%% Set origin\n%d %d translate\n\n",
                           psPtr->left, psPtr->bottom);
    if (psPtr->landscape) {
        Rbc_FormatToPostScript(psToken,
                               "%% Landscape orientation\n0 %g translate\n-90 rotate\n",
                               ((double)graphPtr->width * psPtr->pageScale));
    }
    if (psPtr->pageScale != 1.0) {
        Rbc_AppendToPostScript(psToken, "\n% Setting graph scale factor\n",
                               (char *)NULL);
        Rbc_FormatToPostScript(psToken, " %g %g scale\n", psPtr->pageScale,
                               psPtr->pageScale);
    }
    Rbc_AppendToPostScript(psToken, "\n%%EndSetup\n\n", (char *)NULL);
    return TCL_OK;
}

/*
 *--------------------------------------------------------------
 *
 * MarginsToPostScript --
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
static void
MarginsToPostScript(graphPtr, psToken)
    Graph *graphPtr;
    PsToken psToken;
{
    PostScript *psPtr = (PostScript *)graphPtr->postscript;
    XRectangle margin[4];

    margin[0].x = margin[0].y = margin[3].x = margin[1].x = 0;
    margin[0].width = margin[3].width = graphPtr->width;
    margin[0].height = graphPtr->top;
    margin[3].y = graphPtr->bottom;
    margin[3].height = graphPtr->height - graphPtr->bottom;
    margin[2].y = margin[1].y = graphPtr->top;
    margin[1].width = graphPtr->left;
    margin[2].height = margin[1].height = graphPtr->bottom - graphPtr->top;
    margin[2].x = graphPtr->right;
    margin[2].width = graphPtr->width - graphPtr->right;

    /* Clear the surrounding margins and clip the plotting surface */
    if (psPtr->decorations) {
        Rbc_BackgroundToPostScript(psToken,
                                   Tk_3DBorderColor(graphPtr->border));
    } else {
        Rbc_ClearBackgroundToPostScript(psToken);
    }
    Rbc_RectanglesToPostScript(psToken, margin, 4);

    /* Interior 3D border */
    if ((psPtr->decorations) && (graphPtr->plotBorderWidth > 0)) {
        int x, y, width, height;

        x = graphPtr->left - graphPtr->plotBorderWidth;
        y = graphPtr->top - graphPtr->plotBorderWidth;
        width = (graphPtr->right - graphPtr->left) +
                (2 * graphPtr->plotBorderWidth);
        height = (graphPtr->bottom - graphPtr->top) +
                 (2 * graphPtr->plotBorderWidth);
        Rbc_Draw3DRectangleToPostScript(psToken, graphPtr->border,
                                        (double)x, (double)y, width, height, graphPtr->plotBorderWidth,
                                        graphPtr->plotRelief);
    }
    if (Rbc_LegendSite(graphPtr->legend) & LEGEND_IN_MARGIN) {
        /*
         * Print the legend if we're using a site which lies in one
         * of the margins (left, right, top, or bottom) of the graph.
         */
        Rbc_LegendToPostScript(graphPtr->legend, psToken);
    }
    if (graphPtr->title != NULL) {
        Rbc_TextToPostScript(psToken, graphPtr->title,
                             &graphPtr->titleTextStyle, (double)graphPtr->titleX,
                             (double)graphPtr->titleY);
    }
    Rbc_AxesToPostScript(graphPtr, psToken);
}

/*
 *--------------------------------------------------------------
 *
 * GraphToPostScript --
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
GraphToPostScript(graphPtr, ident, psToken)
    Graph *graphPtr;
    char *ident; /* Identifier string (usually the filename) */
    PsToken psToken;
{
    int x, y, width, height;
    int result;

    /*
     * We need to know how big a graph to print.  If the graph hasn't
     * been drawn yet, the width and height will be 1.  Instead use
     * the requested size of the widget.  The user can still override
     * this with the -width and -height postscript options.
     */
    if (graphPtr->height <= 1) {
        graphPtr->height = Tk_ReqHeight(graphPtr->tkwin);
    }
    if (graphPtr->width <= 1) {
        graphPtr->width = Tk_ReqWidth(graphPtr->tkwin);
    }
    result = PostScriptPreamble(graphPtr, ident, psToken);
    if (result != TCL_OK) {
        goto error;
    }
    /*
     * Determine rectangle of the plotting area for the graph window
     */
    x = graphPtr->left - graphPtr->plotBorderWidth;
    y = graphPtr->top - graphPtr->plotBorderWidth;

    width = (graphPtr->right - graphPtr->left + 1) +
            (2 * graphPtr->plotBorderWidth);
    height = (graphPtr->bottom - graphPtr->top + 1) +
             (2 * graphPtr->plotBorderWidth);

    Rbc_FontToPostScript(psToken, graphPtr->titleTextStyle.font);
    Rbc_RegionToPostScript(psToken, (double)x, (double)y, width, height);
    if (graphPtr->postscript->decorations) {
        Rbc_BackgroundToPostScript(psToken, graphPtr->plotBg);
    } else {
        Rbc_ClearBackgroundToPostScript(psToken);
    }
    Rbc_AppendToPostScript(psToken, "Fill\n", (char *)NULL);
    Rbc_AppendToPostScript(psToken, "gsave clip\n\n", (char *)NULL);
    /* Draw the grid, elements, and markers in the plotting area. */
    if (!graphPtr->gridPtr->hidden) {
        Rbc_GridToPostScript(graphPtr, psToken);
    }
    Rbc_MarkersToPostScript(graphPtr, psToken, TRUE);
    if ((Rbc_LegendSite(graphPtr->legend) & LEGEND_IN_PLOT) &&
            (!Rbc_LegendIsRaised(graphPtr->legend))) {
        /* Print legend underneath elements and markers */
        Rbc_LegendToPostScript(graphPtr->legend, psToken);
    }
    Rbc_AxisLimitsToPostScript(graphPtr, psToken);
    Rbc_ElementsToPostScript(graphPtr, psToken);
    if ((Rbc_LegendSite(graphPtr->legend) & LEGEND_IN_PLOT) &&
            (Rbc_LegendIsRaised(graphPtr->legend))) {
        /* Print legend above elements (but not markers) */
        Rbc_LegendToPostScript(graphPtr->legend, psToken);
    }
    Rbc_MarkersToPostScript(graphPtr, psToken, FALSE);
    Rbc_ActiveElementsToPostScript(graphPtr, psToken);
    Rbc_AppendToPostScript(psToken, "\n",
                           "% Unset clipping\n",
                           "grestore\n\n", (char *)NULL);
    MarginsToPostScript(graphPtr, psToken);
    Rbc_AppendToPostScript(psToken,
                           "showpage\n",
                           "%Trailer\n",
                           "grestore\n",
                           "end\n",
                           "%EOF\n", (char *)NULL);
error:
    /* Reset height and width of graph window */
    graphPtr->width = Tk_Width(graphPtr->tkwin);
    graphPtr->height = Tk_Height(graphPtr->tkwin);
    graphPtr->flags = MAP_WORLD;

    /*
     * Redraw the graph in order to re-calculate the layout as soon as
     * possible. This is in the case the crosshairs are active.
     */
    Rbc_EventuallyRedrawGraph(graphPtr);
    return result;
}

#ifdef WIN32
/*
 * TODO: Determine if neccessary
 *
 *static void
 *InitAPMHeader(tkwin, width, height, headerPtr)
 *    Tk_Window tkwin;
 *    int width, height;
 *    APMHEADER *headerPtr;
 *{
 *    unsigned int *p;
 *    unsigned int sum;
 *    Screen *screen;
 *#define MM_INCH		25.4
 *    double dpiX, dpiY;
 *
 *    headerPtr->key = 0x9ac6cdd7L;
 *    headerPtr->hmf = 0;
 *    headerPtr->inch = 1440;
 *
 *    screen = Tk_Screen(tkwin);
 *    dpiX = (WidthOfScreen(screen) * MM_INCH) / WidthMMOfScreen(screen);
 *    dpiY = (HeightOfScreen(screen) * MM_INCH) / HeightMMOfScreen(screen);
 *
 *    headerPtr->bbox.Left = headerPtr->bbox.Top = 0;
 *    headerPtr->bbox.Bottom = (SHORT)((width * 1440) / dpiX);
 *    headerPtr->bbox.Right = (SHORT)((height * 1440) / dpiY);
 *    headerPtr->reserved = 0;
 *    sum = 0;
 *    for (p = (unsigned int *)headerPtr;
 *            p < (unsigned int *)&(headerPtr->checksum); p++) {
 *        sum ^= *p;
 *    }
 *    headerPtr->checksum = sum;
 *}
 */

/*
 * --------------------------------------------------------------------------
 *
 * CreateWindowEPS --
 *
 *      Generates an EPS file with a Window metafile preview.
 *
 *      Windows metafiles aren't very robust.  Including exactly the
 *      same metafile (one embedded in a DOS EPS, the other as .wmf
 *      file) will play back differently.
 *
 * Results:
 *      None.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 * --------------------------------------------------------------------------
 */
static int
CreateWindowsEPS(graphPtr, psToken, f)
    Graph *graphPtr;
    PsToken psToken;
    FILE *f;
{
    DWORD size;
    DOSEPSHEADER epsHeader;
    HANDLE hMem;
    HDC hRefDC, hDC;
    HENHMETAFILE hMetaFile;
    Tcl_DString dString;
    TkWinDC drawableDC;
    TkWinDCState state;
    int result;
    unsigned char *buffer, *psBuffer;

    Rbc_AppendToPostScript(psToken, "\n", (char *)NULL);
    psBuffer = Rbc_PostScriptFromToken(psToken);
    /*
     * Fill out as much information as we can into the DOS EPS header.
     * We won't know the start of the length of the WMF segment until
     * we create the metafile.
     */
    epsHeader.magic[0] = 0xC5;
    epsHeader.magic[1] = 0xD0;
    epsHeader.magic[2] = 0xD3;
    epsHeader.magic[3] = 0xC6;
    epsHeader.psStart = sizeof(epsHeader);
    epsHeader.psLength = strlen(psBuffer) + 1;
    epsHeader.wmfStart = epsHeader.psStart + epsHeader.psLength;
    epsHeader.wmfLength = 0L;	/* Fill in later. */
    epsHeader.tiffStart = 0L;
    epsHeader.tiffLength = 0L;
    epsHeader.checksum = 0xFFFF;

    result = TCL_ERROR;
    hRefDC = TkWinGetDrawableDC(graphPtr->display,
                                Tk_WindowId(graphPtr->tkwin), &state);

    /* Build a description string. */
    Tcl_DStringInit(&dString);
    Tcl_DStringAppend(&dString, "Rbc Graph ", -1);
    Tcl_DStringAppend(&dString, RBC_VERSION, -1);
    Tcl_DStringAppend(&dString, "\0", -1);
    Tcl_DStringAppend(&dString, Tk_PathName(graphPtr->tkwin), -1);
    Tcl_DStringAppend(&dString, "\0", -1);

    hDC = CreateEnhMetaFile(hRefDC, NULL, NULL, Tcl_DStringValue(&dString));
    Tcl_DStringFree(&dString);

    if (hDC == NULL) {
        Tcl_AppendResult(graphPtr->interp, "can't create metafile: ",
                         Rbc_LastError(), (char *)NULL);
        return TCL_ERROR;
    }
    /* Assemble a Tk drawable that points to the metafile and let the
     * graph's drawing routine draw into it. */
    drawableDC.hdc = hDC;
    drawableDC.type = TWD_WINDC;

    graphPtr->width = Tk_Width(graphPtr->tkwin);
    graphPtr->height = Tk_Height(graphPtr->tkwin);
    graphPtr->flags |= RESET_WORLD;
    Rbc_LayoutGraph(graphPtr);
    Rbc_DrawGraph(graphPtr, (Drawable)&drawableDC, FALSE);
    GdiFlush();
    hMetaFile = CloseEnhMetaFile(hDC);

    size = GetWinMetaFileBits(hMetaFile, 0, NULL, MM_ANISOTROPIC, hRefDC);
    hMem = GlobalAlloc(GHND, size);
    if (hMem == NULL) {
        Tcl_AppendResult(graphPtr->interp, "can't allocate global memory:",
                         Rbc_LastError(), (char *)NULL);
        goto error;
    }
    buffer = (LPVOID)GlobalLock(hMem);
    if (!GetWinMetaFileBits(hMetaFile, size, buffer, MM_ANISOTROPIC, hRefDC)) {
        Tcl_AppendResult(graphPtr->interp, "can't get metafile data:",
                         Rbc_LastError(), (char *)NULL);
        goto error;
    }

    /*
     * Fix up the EPS header with the correct metafile length and PS
     * offset (now that we what they are).
     */
    epsHeader.wmfLength = size;
    epsHeader.wmfStart = epsHeader.psStart + epsHeader.psLength;

    /* Write out the eps header, */
    if (fwrite(&epsHeader, 1, sizeof(epsHeader), f) != sizeof(epsHeader)) {
        Tcl_AppendResult(graphPtr->interp, "error writing eps header:",
                         Rbc_LastError(), (char *)NULL);
        goto error;
    }
    /* the PostScript, */
    if (fwrite(psBuffer, 1, epsHeader.psLength, f) != epsHeader.psLength) {
        Tcl_AppendResult(graphPtr->interp, "error writing PostScript data:",
                         Rbc_LastError(), (char *)NULL);
        goto error;
    }
    /* and finally the metadata itself. */
    if (fwrite(buffer, 1, size, f) != size) {
        Tcl_AppendResult(graphPtr->interp, "error writing metafile data:",
                         Rbc_LastError(), (char *)NULL);
        goto error;
    }
    result = TCL_OK;

error:
    DeleteEnhMetaFile(hMetaFile);
    TkWinReleaseDrawableDC(Tk_WindowId(graphPtr->tkwin), hRefDC, &state);
    fclose(f);
    if (hMem != NULL) {
        GlobalUnlock(hMem);
        GlobalFree(hMem);
    }
    graphPtr->flags = MAP_WORLD;
    Rbc_EventuallyRedrawGraph(graphPtr);
    return result;
}

#endif /*WIN32*/

/*
 *----------------------------------------------------------------------
 *
 * OutputOp --
 *
 *      This procedure is invoked to print the graph in a file.
 *
 * Results:
 *      Standard TCL result.  TCL_OK if plot was successfully printed,
 *      TCL_ERROR otherwise.
 *
 * Side effects:
 *      A new PostScript file is created.
 *
 *----------------------------------------------------------------------
 */
static int
OutputOp(graphPtr, interp, argc, argv)
    Graph *graphPtr; /* Graph widget record */
    Tcl_Interp *interp;
    int argc; /* Number of options in argv vector */
    char **argv; /* Option vector */
{
    PostScript *psPtr = (PostScript *)graphPtr->postscript;
    FILE *f = NULL;
    PsToken psToken;
    char *fileName;		/* Name of file to write PostScript output
                                 * If NULL, output is returned via
                                 * interp->result. */
    fileName = NULL;
    if (argc > 3) {
        if (argv[3][0] != '-') {
            fileName = argv[3];	/* First argument is the file name. */
            argv++, argc--;
        }
        if (Tk_ConfigureWidget(interp, graphPtr->tkwin, configSpecs, argc - 3, argv + 3, (char *)psPtr, TK_CONFIG_ARGV_ONLY) != TCL_OK) {
            return TCL_ERROR;
        }
        if (fileName != NULL) {
#ifdef WIN32
            f = fopen(fileName, "wb");
#else
            f = fopen(fileName, "w");
#endif
            if (f == NULL) {
                Tcl_AppendResult(interp, "can't create \"", fileName, "\": ",
                                 Tcl_PosixError(interp), (char *)NULL);
                return TCL_ERROR;
            }
        }
    }
    psToken = Rbc_GetPsToken(graphPtr->interp, graphPtr->tkwin);
    psToken->fontVarName = psPtr->fontVarName;
    psToken->colorVarName = psPtr->colorVarName;
    psToken->colorMode = psPtr->colorMode;

    if (GraphToPostScript(graphPtr, fileName, psToken) != TCL_OK) {
        goto error;
    }
    /*
     * If a file name was given, write the results to that file
     */
    if (f != NULL) {
#ifdef WIN32
        if ((psPtr->addPreview) && (psPtr->previewFormat != PS_PREVIEW_EPSI)) {
            if (CreateWindowsEPS(graphPtr, psToken, f)) {
                return TCL_ERROR;
            }
        } else {
            fputs(Rbc_PostScriptFromToken(psToken), f);
            if (ferror(f)) {
                Tcl_AppendResult(interp, "error writing file \"", fileName,
                                 "\": ", Tcl_PosixError(interp), (char *)NULL);
                goto error;
            }
        }
#else
        fputs(Rbc_PostScriptFromToken(psToken), f);
        if (ferror(f)) {
            Tcl_AppendResult(interp, "error writing file \"", fileName, "\": ",
                             Tcl_PosixError(interp), (char *)NULL);
            goto error;
        }
#endif /* WIN32 */
        fclose(f);
    } else {
        Tcl_SetResult(interp, Rbc_PostScriptFromToken(psToken), TCL_VOLATILE);
    }
    Rbc_ReleasePsToken(psToken);
    return TCL_OK;

error:
    if (f != NULL) {
        fclose(f);
    }
    Rbc_ReleasePsToken(psToken);
    return TCL_ERROR;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_CreatePostScript --
 *
 *      Creates a postscript structure.
 *
 * Results:
 *      Always TCL_OK.
 *
 * Side effects:
 *      A new PostScript structure is created.
 *
 *----------------------------------------------------------------------
 */
int
Rbc_CreatePostScript(graphPtr)
    Graph *graphPtr;
{
    PostScript *psPtr;

    psPtr = RbcCalloc(1, sizeof(PostScript));
    assert(psPtr);
    psPtr->colorMode = PS_MODE_COLOR;
    psPtr->center = TRUE;
    psPtr->decorations = TRUE;
    graphPtr->postscript = psPtr;

    if (Rbc_ConfigureWidgetComponent(graphPtr->interp, graphPtr->tkwin,
                                     "postscript", "Postscript", configSpecs, 0, (char **)NULL,
                                     (char *)psPtr, 0) != TCL_OK) {
        return TCL_ERROR;
    }
    return TCL_OK;
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_PostScriptOp --
 *
 *      This procedure is invoked to process the Tcl command
 *      that corresponds to a widget managed by this module.
 *      See the user documentation for details on what it does.
 *
 * Results:
 *      A standard Tcl result.
 *
 * Side effects:
 *      See the user documentation.
 *
 *--------------------------------------------------------------
 */
static Rbc_OpSpec psOps[] = {
    {"cget", 2, (Rbc_Op)CgetOp, 4, 4, "option",},
    {"configure", 2, (Rbc_Op)ConfigureOp, 3, 0, "?option value?...",},
    {"output", 1, (Rbc_Op)OutputOp, 3, 0,
     "?fileName? ?option value?...",},
};

static int nPsOps = sizeof(psOps) / sizeof(Rbc_OpSpec);

/*
 *--------------------------------------------------------------
 *
 * Rbc_PostScriptOp --
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
Rbc_PostScriptOp(graphPtr, interp, argc, argv)
    Graph *graphPtr; /* Graph widget record */
    Tcl_Interp *interp;
    int argc; /* # arguments */
    CONST84 char *argv[]; /* Argument list */
{
    Rbc_Op proc;
    int result;

    proc = Rbc_GetOp(interp, nPsOps, psOps, RBC_OP_ARG2, argc, argv, 0);
    if (proc == NULL) {
        return TCL_ERROR;
    }
    result = (*proc) (graphPtr, interp, argc, argv);
    return result;
}

