/*
 * rbcPs.c --
 *
 *      This module implements general PostScript conversion routines.
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#include "rbcInt.h"
#include "rbcPs.h"

#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <stdarg.h>

#define PS_MAXPATH	1500	/* Maximum number of components in a PostScript
                             * (level 1) path. */

static void XColorToPostScript _ANSI_ARGS_((struct PsTokenStruct *tokenPtr, XColor *colorPtr));
INLINE static unsigned char ReverseBits _ANSI_ARGS_((register unsigned char byte));
INLINE static void ByteToHex _ANSI_ARGS_((register unsigned char byte, char *string));
static char *NameOfAtom _ANSI_ARGS_((Tk_Window tkwin, Atom atom));
static void TextLayoutToPostScript _ANSI_ARGS_((struct PsTokenStruct *tokenPtr, int x, int y, TextLayout *textPtr));

/*
 *--------------------------------------------------------------
 *
 * Rbc_GetPsToken --
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
PsToken
Rbc_GetPsToken(interp, tkwin)
    Tcl_Interp *interp;
    Tk_Window tkwin;
{
    struct PsTokenStruct *tokenPtr;

    tokenPtr = (struct PsTokenStruct *)ckalloc(sizeof(struct PsTokenStruct));
    assert(tokenPtr);

    tokenPtr->fontVarName = tokenPtr->colorVarName = NULL;
    tokenPtr->interp = interp;
    tokenPtr->tkwin = tkwin;
    tokenPtr->colorMode = PS_MODE_COLOR;
    Tcl_DStringInit(&(tokenPtr->dString));
    return tokenPtr;
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_ReleasePsToken --
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
Rbc_ReleasePsToken(tokenPtr)
    struct PsTokenStruct *tokenPtr;
{
    Tcl_DStringFree(&(tokenPtr->dString));
    ckfree((char *)tokenPtr);
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_PostScriptFromToken --
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
char *
Rbc_PostScriptFromToken(tokenPtr)
    struct PsTokenStruct *tokenPtr;
{
    return Tcl_DStringValue(&(tokenPtr->dString));
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_ScratchBufferFromToken --
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
char *
Rbc_ScratchBufferFromToken(tokenPtr)
    struct PsTokenStruct *tokenPtr;
{
    return tokenPtr->scratchArr;
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_AppendToPostScript --
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
Rbc_AppendToPostScript TCL_VARARGS_DEF(PsToken, arg1)
{
    va_list argList;
    struct PsTokenStruct *tokenPtr;
    char *string;

    tokenPtr = TCL_VARARGS_START(struct PsTokenStruct, arg1, argList);
    for (;;) {
        string = va_arg(argList, char *);
        if (string == NULL) {
            break;
        }
        Tcl_DStringAppend(&(tokenPtr->dString), string, -1);
    }
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_FormatToPostScript --
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
Rbc_FormatToPostScript TCL_VARARGS_DEF(PsToken, arg1)
{
    va_list argList;
    struct PsTokenStruct *tokenPtr;
    char *fmt;

    tokenPtr = TCL_VARARGS_START(struct PsTokenStruct, arg1, argList);
    fmt = va_arg(argList, char *);
    vsprintf(tokenPtr->scratchArr, fmt, argList);
    va_end(argList);
    Tcl_DStringAppend(&(tokenPtr->dString), tokenPtr->scratchArr, -1);
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_FileToPostScript --
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
Rbc_FileToPostScript(tokenPtr, fileName)
    struct PsTokenStruct *tokenPtr;
    char *fileName;
{
    Tcl_Channel channel;
    Tcl_DString dString;
    Tcl_Interp *interp;
    char *buf;
    char *libDir;
    int nBytes;

    interp = tokenPtr->interp;
    buf = tokenPtr->scratchArr;

    /*
     * Read in a standard prolog file from file and append it to the
     * PostScript output stored in the Tcl_DString in tokenPtr.
     */

    libDir = (char *)Tcl_GetVar(interp, "rbc::library", TCL_GLOBAL_ONLY);
    if (libDir == NULL) {
        Tcl_AppendResult(interp, "couldn't find rbc script library:",
                         "global variable \"rbc::library\" doesn't exist", (char *)NULL);
        return TCL_ERROR;
    }
    Tcl_DStringInit(&dString);
    Tcl_DStringAppend(&dString, libDir, -1);
    Tcl_DStringAppend(&dString, "/", -1);
    Tcl_DStringAppend(&dString, fileName, -1);
    fileName = Tcl_DStringValue(&dString);
    Rbc_AppendToPostScript(tokenPtr, "\n% including file \"", fileName,
                           "\"\n\n", (char *)NULL);
    channel = Tcl_OpenFileChannel(interp, fileName, "r", 0);
    if (channel == NULL) {
        Tcl_AppendResult(interp, "couldn't open prologue file \"", fileName,
                         "\": ", Tcl_PosixError(interp), (char *)NULL);
        return TCL_ERROR;
    }
    for (;;) {
        nBytes = Tcl_Read(channel, buf, PSTOKEN_BUFSIZ);
        if (nBytes < 0) {
            Tcl_AppendResult(interp, "error reading prologue file \"",
                             fileName, "\": ", Tcl_PosixError(interp),
                             (char *)NULL);
            Tcl_Close(interp, channel);
            Tcl_DStringFree(&dString);
            return TCL_ERROR;
        }
        if (nBytes == 0) {
            break;
        }
        buf[nBytes] = '\0';
        Rbc_AppendToPostScript(tokenPtr, buf, (char *)NULL);
    }
    Tcl_DStringFree(&dString);
    Tcl_Close(interp, channel);
    return TCL_OK;
}
/*
 *----------------------------------------------------------------------
 *
 * XColorToPostScript --
 *
 *      Convert the a XColor (from its RGB values) to a PostScript
 *      command.  If a Tk color map variable exists, it will be
 *      consulted for a PostScript translation based upon the color
 *      name.
 *
 *      Maps an X color intensity (0 to 2^16-1) to a floating point
 *      value [0..1].  Many versions of Tk don't properly handle the
 *      the lower 8 bits of the color intensity, so we can only
 *      consider the upper 8 bits.
 *
 * Results:
 *      The string representing the color mode is returned.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
static void
XColorToPostScript(tokenPtr, colorPtr)
    struct PsTokenStruct *tokenPtr;
    XColor *colorPtr; /* Color value to be converted */
{
    /*
     * Shift off the lower byte before dividing because some versions
     * of Tk don't fill the lower byte correctly.
     */
    Rbc_FormatToPostScript(tokenPtr, "%g %g %g",
                           ((double)(colorPtr->red >> 8) / 255.0),
                           ((double)(colorPtr->green >> 8) / 255.0),
                           ((double)(colorPtr->blue >> 8) / 255.0));
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_BackgroundToPostScript --
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
Rbc_BackgroundToPostScript(tokenPtr, colorPtr)
    struct PsTokenStruct *tokenPtr;
    XColor *colorPtr;
{
    /* If the color name exists in Tcl array variable, use that translation */
    if (tokenPtr->colorVarName != NULL) {
        CONST char *psColor;

        psColor = Tcl_GetVar2(tokenPtr->interp, tokenPtr->colorVarName,
                              Tk_NameOfColor(colorPtr), 0);
        if (psColor != NULL) {
            Rbc_AppendToPostScript(tokenPtr, " ", psColor, "\n", (char *)NULL);
            return;
        }
    }
    XColorToPostScript(tokenPtr, colorPtr);
    Rbc_AppendToPostScript(tokenPtr, " SetBgColor\n", (char *)NULL);
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_ForegroundToPostScript --
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
Rbc_ForegroundToPostScript(tokenPtr, colorPtr)
    struct PsTokenStruct *tokenPtr;
    XColor *colorPtr;
{
    /* If the color name exists in Tcl array variable, use that translation */
    if (tokenPtr->colorVarName != NULL) {
        CONST char *psColor;

        psColor = Tcl_GetVar2(tokenPtr->interp, tokenPtr->colorVarName,
                              Tk_NameOfColor(colorPtr), 0);
        if (psColor != NULL) {
            Rbc_AppendToPostScript(tokenPtr, " ", psColor, "\n", (char *)NULL);
            return;
        }
    }
    XColorToPostScript(tokenPtr, colorPtr);
    Rbc_AppendToPostScript(tokenPtr, " SetFgColor\n", (char *)NULL);
}

/*
 *----------------------------------------------------------------------
 *
 * ReverseBits --
 *
 *      Convert a byte from a X image into PostScript image order.
 *      This requires not only the nybbles to be reversed but also
 *      their bit values.
 *
 * Results:
 *      The converted byte is returned.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
INLINE static unsigned char
ReverseBits(byte)
    register unsigned char byte;
{
    byte = ((byte >> 1) & 0x55) | ((byte << 1) & 0xaa);
    byte = ((byte >> 2) & 0x33) | ((byte << 2) & 0xcc);
    byte = ((byte >> 4) & 0x0f) | ((byte << 4) & 0xf0);
    return byte;
}

/*
 *----------------------------------------------------------------------
 *
 * ByteToHex --
 *
 *      Convert a byte to its ASCII hexidecimal equivalent.
 *
 * Results:
 *      The converted 2 ASCII character string is returned.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
INLINE static void
ByteToHex(byte, string)
    register unsigned char byte;
    char *string;
{
    static char hexDigits[] = "0123456789ABCDEF";

    string[0] = hexDigits[byte >> 4];
    string[1] = hexDigits[byte & 0x0F];
}

#ifdef WIN32
/*
 * -------------------------------------------------------------------------
 *
 * Rbc_BitmapDataToPostScript --
 *
 *      Output a PostScript image string of the given bitmap image.
 *      It is assumed the image is one bit deep and a zero value
 *      indicates an off-pixel.  To convert to PostScript, the bits
 *      need to be reversed from the X11 image order.
 *
 * Results:
 *      None.
 *
 * Side Effects:
 *      The PostScript image string is appended.
 *
 * -------------------------------------------------------------------------
 */
void
Rbc_BitmapDataToPostScript(
    struct PsTokenStruct *tokenPtr,
    Display *display,
    Pixmap bitmap,
    int width, int height)
{
    register unsigned char byte;
    register int x, y, bitPos;
    unsigned long pixel;
    int byteCount;
    char string[10];
    unsigned char *srcBits, *srcPtr;
    int bytesPerRow;

    srcBits = Rbc_GetBitmapData(display, bitmap, width, height, &bytesPerRow);
    if (srcBits == NULL) {
        OutputDebugString("Can't get bitmap data");
        return;
    }
    Rbc_AppendToPostScript(tokenPtr, "\t<", (char *)NULL);
    byteCount = bitPos = 0;	/* Suppress compiler warning */
    for (y = height - 1; y >= 0; y--) {
        srcPtr = srcBits + (bytesPerRow * y);
        byte = 0;
        for (x = 0; x < width; x++) {
            bitPos = x % 8;
            pixel = (*srcPtr & (0x80 >> bitPos));
            if (pixel) {
                byte |= (unsigned char)(1 << bitPos);
            }
            if (bitPos == 7) {
                byte = ReverseBits(byte);
                ByteToHex(byte, string);
                string[2] = '\0';
                byteCount++;
                srcPtr++;
                byte = 0;
                if (byteCount >= 30) {
                    string[2] = '\n';
                    string[3] = '\t';
                    string[4] = '\0';
                    byteCount = 0;
                }
                Rbc_AppendToPostScript(tokenPtr, string, (char *)NULL);
            }
        }			/* x */
        if (bitPos != 7) {
            byte = ReverseBits(byte);
            ByteToHex(byte, string);
            string[2] = '\0';
            Rbc_AppendToPostScript(tokenPtr, string, (char *)NULL);
            byteCount++;
        }
    }				/* y */
    ckfree((char *)srcBits);
    Rbc_AppendToPostScript(tokenPtr, ">\n", (char *)NULL);
}

#else

/*
 * -------------------------------------------------------------------------
 *
 * Rbc_BitmapDataToPostScript --
 *
 *      Output a PostScript image string of the given bitmap image.
 *      It is assumed the image is one bit deep and a zero value
 *      indicates an off-pixel.  To convert to PostScript, the bits
 *      need to be reversed from the X11 image order.
 *
 * Results:
 *      None.
 *
 * Side Effects:
 *      The PostScript image string is appended to interp->result.
 *
 * -------------------------------------------------------------------------
 */
void
Rbc_BitmapDataToPostScript(tokenPtr, display, bitmap, width, height)
    struct PsTokenStruct *tokenPtr;
    Display *display;
    Pixmap bitmap;
    int width, height;
{
    register unsigned char byte = 0;
    register int x, y, bitPos;
    unsigned long pixel;
    XImage *imagePtr;
    int byteCount;
    char string[10];

    imagePtr = XGetImage(display, bitmap, 0, 0, width, height, 1, ZPixmap);
    Rbc_AppendToPostScript(tokenPtr, "\t<", (char *)NULL);
    byteCount = bitPos = 0;	/* Suppress compiler warning */
    for (y = 0; y < height; y++) {
        byte = 0;
        for (x = 0; x < width; x++) {
            pixel = XGetPixel(imagePtr, x, y);
            bitPos = x % 8;
            byte |= (unsigned char)(pixel << bitPos);
            if (bitPos == 7) {
                byte = ReverseBits(byte);
                ByteToHex(byte, string);
                string[2] = '\0';
                byteCount++;
                byte = 0;
                if (byteCount >= 30) {
                    string[2] = '\n';
                    string[3] = '\t';
                    string[4] = '\0';
                    byteCount = 0;
                }
                Rbc_AppendToPostScript(tokenPtr, string, (char *)NULL);
            }
        }			/* x */
        if (bitPos != 7) {
            byte = ReverseBits(byte);
            ByteToHex(byte, string);
            string[2] = '\0';
            Rbc_AppendToPostScript(tokenPtr, string, (char *)NULL);
            byteCount++;
        }
    }				/* y */
    Rbc_AppendToPostScript(tokenPtr, ">\n", (char *)NULL);
    XDestroyImage(imagePtr);
}

#endif /* WIN32 */

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ColorImageToPsData --
 *
 *      Converts a color image to PostScript RGB (3 components)
 *      or Greyscale (1 component) output.  With 3 components, we
 *      assume the "colorimage" operator is available.
 *
 *      Note that the image converted from bottom to top, to conform
 *      to the PostScript coordinate system.
 *
 * Results:
 *      The PostScript data comprising the color image is written
 *      into the dynamic string.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
int
Rbc_ColorImageToPsData(image, nComponents, resultPtr, prefix)
    Rbc_ColorImage image;
    int nComponents;
    Tcl_DString *resultPtr;
    char *prefix;
{
    char string[10];
    register int count;
    register int x, y;
    register Pix32 *pixelPtr;
    unsigned char byte;
    int width, height;
    int offset;
    int nLines;
    width = Rbc_ColorImageWidth(image);
    height = Rbc_ColorImageHeight(image);

    nLines = 0;
    count = 0;
    offset = (height - 1) * width;
    if (nComponents == 3) {
        for (y = (height - 1); y >= 0; y--) {
            pixelPtr = Rbc_ColorImageBits(image) + offset;
            for (x = 0; x < width; x++, pixelPtr++) {
                if (count == 0) {
                    Tcl_DStringAppend(resultPtr, prefix, -1);
                    Tcl_DStringAppend(resultPtr, " ", -1);
                }
                count += 6;
                ByteToHex(pixelPtr->Red, string);
                ByteToHex(pixelPtr->Green, string + 2);
                ByteToHex(pixelPtr->Blue, string + 4);
                string[6] = '\0';
                if (count >= 60) {
                    string[6] = '\n';
                    string[7] = '\0';
                    count = 0;
                    nLines++;
                }
                Tcl_DStringAppend(resultPtr, string, -1);
            }
            offset -= width;
        }
    } else if (nComponents == 1) {
        for (y = (height - 1); y >= 0; y--) {
            pixelPtr = Rbc_ColorImageBits(image) + offset;
            for (x = 0; x < width; x++, pixelPtr++) {
                if (count == 0) {
                    Tcl_DStringAppend(resultPtr, prefix, -1);
                    Tcl_DStringAppend(resultPtr, " ", -1);
                }
                count += 2;
                byte = ~(pixelPtr->Red);
                ByteToHex(byte, string);
                string[2] = '\0';
                if (count >= 60) {
                    string[2] = '\n';
                    string[3] = '\0';
                    count = 0;
                    nLines++;
                }
                Tcl_DStringAppend(resultPtr, string, -1);
            }
            offset -= width;
        }
    }
    if (count != 0) {
        Tcl_DStringAppend(resultPtr, "\n", -1);
        nLines++;
    }
    return nLines;
}

/*
 *----------------------------------------------------------------------
 *
 * NameOfAtom --
 *
 *      Wrapper routine for Tk_GetAtomName.  Returns NULL instead of
 *      "?bad atom?" if the atom can't be found.
 *
 * Results:
 *      The name of the atom is returned if found. Otherwise NULL.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
static char *
NameOfAtom(tkwin, atom)
    Tk_Window tkwin;
    Atom atom;
{
    char *result;

    result = Tk_GetAtomName(tkwin, atom);
    if ((result[0] == '?') && (strcmp(result, "?bad atom?") == 0)) {
        return NULL;
    }
    return result;
}


typedef struct {
    char *alias;
    char *fontName;
} FontMap;

static FontMap psFontMap[] = {
    {"Arial", "Helvetica",},
    {"AvantGarde", "AvantGarde",},
    {"Courier New", "Courier",},
    {"Courier", "Courier",},
    {"Geneva", "Helvetica",},
    {"Helvetica", "Helvetica",},
    {"Monaco", "Courier",},
    {"New Century Schoolbook", "NewCenturySchlbk",},
    {"New York", "Times",},
    {"Palatino", "Palatino",},
    {"Symbol", "Symbol",},
    {"Times New Roman", "Times",},
    {"Times Roman", "Times",},
    {"Times", "Times",},
    {"Utopia", "Utopia",},
    {"ZapfChancery", "ZapfChancery",},
    {"ZapfDingbats", "ZapfDingbats",},
};

static int nFontNames = (sizeof(psFontMap) / sizeof(FontMap));

#ifndef  WIN32
/*
 * -----------------------------------------------------------------
 *
 * XFontStructToPostScript --
 *
 *      Map X11 font to a PostScript font. Currently, only fonts whose
 *      FOUNDRY property are "Adobe" are converted. Simply gets the
 *      XA_FULL_NAME and XA_FAMILY properties and pieces together a
 *      PostScript fontname.
 *
 * Results:
 *      Returns the mapped PostScript font name if one is possible.
 *      Otherwise returns NULL.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 * -----------------------------------------------------------------
 */
static char *
XFontStructToPostScript(tkwin, fontPtr)
    Tk_Window tkwin; /* Window to query for atoms */
    XFontStruct *fontPtr; /* Font structure to map to name */
{
    Atom atom;
    char *fullName, *family, *foundry;
    register char *src, *dest;
    int familyLen;
    char *start;
    static char string[200];      /* What size? */

    if (XGetFontProperty(fontPtr, XA_FULL_NAME, &atom) == False) {
        return NULL;
    }
    fullName = NameOfAtom(tkwin, atom);
    if (fullName == NULL) {
        return NULL;
    }
    family = foundry = NULL;
    if (XGetFontProperty(fontPtr, Tk_InternAtom(tkwin, "FOUNDRY"), &atom)) {
        foundry = NameOfAtom(tkwin, atom);
    }
    if (XGetFontProperty(fontPtr, XA_FAMILY_NAME, &atom)) {
        family = NameOfAtom(tkwin, atom);
    }
    /*
     * Try to map the font only if the foundry is Adobe
     */
    if ((foundry == NULL) || (family == NULL)) {
        return NULL;
    }
    src = NULL;
    familyLen = strlen(family);
    if (strncasecmp(fullName, family, familyLen) == 0) {
        src = fullName + familyLen;
    }
    if (strcmp(foundry, "Adobe") != 0) {
        register int i;

        if (strncasecmp(family, "itc ", 4) == 0) {
            family += 4;	/* Throw out the "itc" prefix */
        }
        for (i = 0; i < nFontNames; i++) {
            if (strcasecmp(family, psFontMap[i].alias) == 0) {
                family = psFontMap[i].fontName;
            }
        }
        if (i == nFontNames) {
            family = "Helvetica";	/* Default to a known font */
        }
    }
    /*
     * PostScript font name is in the form <family>-<type face>
     */
    sprintf(string, "%s-", family);
    dest = start = string + strlen(string);

    /*
     * Append the type face (part of the full name trailing the family name)
     * to the the PostScript font name, removing any spaces or dashes
     *
     * ex. " Bold Italic" ==> "BoldItalic"
     */
    if (src != NULL) {
        while (*src != '\0') {
            if ((*src != ' ') && (*src != '-')) {
                *dest++ = *src;
            }
            src++;
        }
    }
    if (dest == start) {
        --dest;			/* Remove '-' to leave just the family name */
    }
    *dest = '\0';		/* Make a valid string */
    return string;
}

#endif /* !WIN32 */


/*
 * -------------------------------------------------------------------
 * Routines to convert X drawing functions to PostScript commands.
 * -------------------------------------------------------------------
 */

/*
 *--------------------------------------------------------------
 *
 * Rbc_ClearBackgroundToPostScript --
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
Rbc_ClearBackgroundToPostScript(tokenPtr)
    struct PsTokenStruct *tokenPtr;
{
    Rbc_AppendToPostScript(tokenPtr,
                           " 1.0 1.0 1.0 SetBgColor\n",
                           (char *)NULL);
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_CapStyleToPostScript --
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
Rbc_CapStyleToPostScript(tokenPtr, capStyle)
    struct PsTokenStruct *tokenPtr;
    int capStyle;
{
    /*
     * X11:not last = 0, butt = 1, round = 2, projecting = 3
     * PS: butt = 0, round = 1, projecting = 2
     */
    if (capStyle > 0) {
        capStyle--;
    }
    Rbc_FormatToPostScript(tokenPtr,
                           "%d setlinecap\n",
                           capStyle);
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_JoinStyleToPostScript --
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
Rbc_JoinStyleToPostScript(tokenPtr, joinStyle)
    struct PsTokenStruct *tokenPtr;
    int joinStyle;
{
    /*
     * miter = 0, round = 1, bevel = 2
     */
    Rbc_FormatToPostScript(tokenPtr,
                           "%d setlinejoin\n",
                           joinStyle);
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_LineWidthToPostScript --
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
Rbc_LineWidthToPostScript(tokenPtr, lineWidth)
    struct PsTokenStruct *tokenPtr;
    int lineWidth;
{
    if (lineWidth < 1) {
        lineWidth = 1;
    }
    Rbc_FormatToPostScript(tokenPtr,
                           "%d setlinewidth\n",
                           lineWidth);
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_LineDashesToPostScript --
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
Rbc_LineDashesToPostScript(tokenPtr, dashesPtr)
    struct PsTokenStruct *tokenPtr;
    Rbc_Dashes *dashesPtr;
{

    Rbc_AppendToPostScript(tokenPtr, "[ ", (char *)NULL);
    if (dashesPtr != NULL) {
        unsigned char *p;

        for (p = dashesPtr->values; *p != 0; p++) {
            Rbc_FormatToPostScript(tokenPtr, " %d", *p);
        }
    }
    Rbc_AppendToPostScript(tokenPtr, "] 0 setdash\n", (char *)NULL);
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_LineAttributesToPostScript --
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
Rbc_LineAttributesToPostScript(tokenPtr, colorPtr, lineWidth, dashesPtr,
                               capStyle, joinStyle)
    struct PsTokenStruct *tokenPtr;
    XColor *colorPtr;
    int lineWidth;
    Rbc_Dashes *dashesPtr;
    int capStyle, joinStyle;
{
    Rbc_JoinStyleToPostScript(tokenPtr, joinStyle);
    Rbc_CapStyleToPostScript(tokenPtr, capStyle);
    Rbc_ForegroundToPostScript(tokenPtr, colorPtr);
    Rbc_LineWidthToPostScript(tokenPtr, lineWidth);
    Rbc_LineDashesToPostScript(tokenPtr, dashesPtr);
    Rbc_AppendToPostScript(tokenPtr, "/DashesProc {} def\n", (char *)NULL);
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_RectangleToPostScript --
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
Rbc_RectangleToPostScript(tokenPtr, x, y, width, height)
    struct PsTokenStruct *tokenPtr;
    double x, y;
    int width, height;
{
    Rbc_FormatToPostScript(tokenPtr,
                           "%g %g %d %d Box fill\n\n",
                           x, y, width, height);
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_RegionToPostScript --
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
Rbc_RegionToPostScript(tokenPtr, x, y, width, height)
    struct PsTokenStruct *tokenPtr;
    double x, y;
    int width, height;
{
    Rbc_FormatToPostScript(tokenPtr, "%g %g %d %d Box\n\n",
                           x, y, width, height);
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_PathToPostScript --
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
Rbc_PathToPostScript(tokenPtr, screenPts, nScreenPts)
    struct PsTokenStruct *tokenPtr;
    register Point2D *screenPts;
    int nScreenPts;
{
    register Point2D *pointPtr, *endPtr;

    pointPtr = screenPts;
    Rbc_FormatToPostScript(tokenPtr, "newpath %g %g moveto\n",
                           pointPtr->x, pointPtr->y);
    pointPtr++;
    endPtr = screenPts + nScreenPts;
    while (pointPtr < endPtr) {
        Rbc_FormatToPostScript(tokenPtr, "%g %g lineto\n",
                               pointPtr->x, pointPtr->y);
        pointPtr++;
    }
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_PolygonToPostScript --
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
Rbc_PolygonToPostScript(tokenPtr, screenPts, nScreenPts)
    struct PsTokenStruct *tokenPtr;
    Point2D *screenPts;
    int nScreenPts;
{
    Rbc_PathToPostScript(tokenPtr, screenPts, nScreenPts);
    Rbc_FormatToPostScript(tokenPtr, "%g %g ", screenPts[0].x, screenPts[0].y);
    Rbc_AppendToPostScript(tokenPtr, " lineto closepath Fill\n", (char *)NULL);
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_SegmentsToPostScript --
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
Rbc_SegmentsToPostScript(tokenPtr, segPtr, nSegments)
    struct PsTokenStruct *tokenPtr;
    register XSegment *segPtr;
    int nSegments;
{
    register int i;

    for (i = 0; i < nSegments; i++, segPtr++) {
        Rbc_FormatToPostScript(tokenPtr, "%d %d moveto\n",
                               segPtr->x1, segPtr->y1);
        Rbc_FormatToPostScript(tokenPtr, " %d %d lineto\n",
                               segPtr->x2, segPtr->y2);
        Rbc_AppendToPostScript(tokenPtr, "DashesProc stroke\n", (char *)NULL);
    }
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_RectanglesToPostScript --
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
Rbc_RectanglesToPostScript(tokenPtr, rectArr, nRects)
    struct PsTokenStruct *tokenPtr;
    XRectangle rectArr[];
    int nRects;
{
    register int i;

    for (i = 0; i < nRects; i++) {
        Rbc_RectangleToPostScript(tokenPtr,
                                  (double)rectArr[i].x, (double)rectArr[i].y,
                                  (int)rectArr[i].width, (int)rectArr[i].height);
    }
}

#ifndef TK_RELIEF_SOLID
#define TK_RELIEF_SOLID		-1	/* Set the an impossible value. */
#endif /* TK_RELIEF_SOLID */

/*
 *--------------------------------------------------------------
 *
 * Rbc_Draw3DRectangleToPostScript --
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
Rbc_Draw3DRectangleToPostScript(tokenPtr, border, x, y, width, height,
                                borderWidth, relief)
    struct PsTokenStruct *tokenPtr;
    Tk_3DBorder border; /* Token for border to draw. */
    double x, y; /* Coordinates of rectangle */
    int width, height; /* Region to be drawn. */
    int borderWidth; /* Desired width for border, in pixels. */
    int relief; /* Should be either TK_RELIEF_RAISED or
                 * TK_RELIEF_SUNKEN;  indicates position of
                 * interior of window relative to exterior. */
{
    TkBorder *borderPtr = (TkBorder *) border;
    XColor lightColor, darkColor;
    XColor *lightColorPtr, *darkColorPtr;
    XColor *topColor, *bottomColor;
    Point2D points[7];
    int twiceWidth = (borderWidth * 2);

    if ((width < twiceWidth) || (height < twiceWidth)) {
        return;
    }
    if ((relief == TK_RELIEF_SOLID) ||
            (borderPtr->lightColor == NULL) || (borderPtr->darkColor == NULL)) {
        if (relief == TK_RELIEF_SOLID) {
            darkColor.red = darkColor.blue = darkColor.green = 0x00;
            lightColor.red = lightColor.blue = lightColor.green = 0x00;
            relief = TK_RELIEF_SUNKEN;
        } else {
            Screen *screenPtr;

            lightColor = *borderPtr->bgColor;
            screenPtr = Tk_Screen(tokenPtr->tkwin);
            if (lightColor.pixel == WhitePixelOfScreen(screenPtr)) {
                darkColor.red = darkColor.blue = darkColor.green = 0x00;
            } else {
                darkColor.red = darkColor.blue = darkColor.green = 0xFF;
            }
        }
        lightColorPtr = &lightColor;
        darkColorPtr = &darkColor;
    } else {
        lightColorPtr = borderPtr->lightColor;
        darkColorPtr = borderPtr->darkColor;
    }


    /*
     * Handle grooves and ridges with recursive calls.
     */

    if ((relief == TK_RELIEF_GROOVE) || (relief == TK_RELIEF_RIDGE)) {
        int halfWidth, insideOffset;

        halfWidth = borderWidth / 2;
        insideOffset = borderWidth - halfWidth;
        Rbc_Draw3DRectangleToPostScript(tokenPtr, border, (double)x, (double)y,
                                        width, height, halfWidth,
                                        (relief == TK_RELIEF_GROOVE) ? TK_RELIEF_SUNKEN : TK_RELIEF_RAISED);
        Rbc_Draw3DRectangleToPostScript(tokenPtr, border,
                                        (double)(x + insideOffset), (double)(y + insideOffset),
                                        width - insideOffset * 2, height - insideOffset * 2, halfWidth,
                                        (relief == TK_RELIEF_GROOVE) ? TK_RELIEF_RAISED : TK_RELIEF_SUNKEN);
        return;
    }
    if (relief == TK_RELIEF_RAISED) {
        topColor = lightColorPtr;
        bottomColor = darkColorPtr;
    } else if (relief == TK_RELIEF_SUNKEN) {
        topColor = darkColorPtr;
        bottomColor = lightColorPtr;
    } else {
        topColor = bottomColor = borderPtr->bgColor;
    }
    Rbc_BackgroundToPostScript(tokenPtr, bottomColor);
    Rbc_RectangleToPostScript(tokenPtr, x, y + height - borderWidth, width,
                              borderWidth);
    Rbc_RectangleToPostScript(tokenPtr, x + width - borderWidth, y,
                              borderWidth, height);
    points[0].x = points[1].x = points[6].x = x;
    points[0].y = points[6].y = y + height;
    points[1].y = points[2].y = y;
    points[2].x = x + width;
    points[3].x = x + width - borderWidth;
    points[3].y = points[4].y = y + borderWidth;
    points[4].x = points[5].x = x + borderWidth;
    points[5].y = y + height - borderWidth;
    if (relief != TK_RELIEF_FLAT) {
        Rbc_BackgroundToPostScript(tokenPtr, topColor);
    }
    Rbc_PolygonToPostScript(tokenPtr, points, 7);
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_Fill3DRectangleToPostScript --
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
Rbc_Fill3DRectangleToPostScript(tokenPtr, border, x, y, width, height,
                                borderWidth, relief)
    struct PsTokenStruct *tokenPtr;
    Tk_3DBorder border; /* Token for border to draw. */
    double x, y; /* Coordinates of top-left of border area */
    int width, height; /* Dimension of border to be drawn. */
    int borderWidth; /* Desired width for border, in pixels. */
    int relief; /* Should be either TK_RELIEF_RAISED or
                 * TK_RELIEF_SUNKEN;  indicates position of
                 * interior of window relative to exterior. */
{
    TkBorder *borderPtr = (TkBorder *) border;

    /*
     * I'm assuming that the rectangle is to be drawn as a background.
     * Setting the pen color as foreground or background only affects
     * the plot when the colormode option is "monochrome".
     */
    Rbc_BackgroundToPostScript(tokenPtr, borderPtr->bgColor);
    Rbc_RectangleToPostScript(tokenPtr, x, y, width, height);
    Rbc_Draw3DRectangleToPostScript(tokenPtr, border, x, y, width, height,
                                    borderWidth, relief);
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_StippleToPostScript --
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
Rbc_StippleToPostScript(tokenPtr, display, bitmap)
    struct PsTokenStruct *tokenPtr;
    Display *display;
    Pixmap bitmap;
{
    int width, height;

    Tk_SizeOfBitmap(display, bitmap, &width, &height);
    Rbc_FormatToPostScript(tokenPtr,
                           "gsave\n  clip\n  %d %d\n",
                           width, height);
    Rbc_BitmapDataToPostScript(tokenPtr, display, bitmap, width, height);
    Rbc_AppendToPostScript(tokenPtr,
                           "  StippleFill\ngrestore\n",
                           (char *)NULL);
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ColorImageToPostScript --
 *
 *      Translates a color image into 3 component RGB PostScript output.
 *      Uses PS Language Level 2 operator "colorimage".
 *
 * Results:
 *      The dynamic string will contain the PostScript output.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_ColorImageToPostScript(tokenPtr, image, x, y)
    struct PsTokenStruct *tokenPtr;
    Rbc_ColorImage image;
    double x, y;
{
    int width, height;
    int tmpSize;

    width = Rbc_ColorImageWidth(image);
    height = Rbc_ColorImageHeight(image);

    tmpSize = width;
    if (tokenPtr->colorMode == PS_MODE_COLOR) {
        tmpSize *= 3;
    }
    Rbc_FormatToPostScript(tokenPtr, "\n/tmpStr %d string def\n", tmpSize);
    Rbc_AppendToPostScript(tokenPtr, "gsave\n", (char *)NULL);
    Rbc_FormatToPostScript(tokenPtr, "  %g %g translate\n", x, y);
    Rbc_FormatToPostScript(tokenPtr, "  %d %d scale\n", width, height);
    Rbc_FormatToPostScript(tokenPtr, "  %d %d 8\n", width, height);
    Rbc_FormatToPostScript(tokenPtr, "  [%d 0 0 %d 0 %d] ", width, -height,
                           height);
    Rbc_AppendToPostScript(tokenPtr,
                           "{\n    currentfile tmpStr readhexstring pop\n  } ",
                           (char *)NULL);
    if (tokenPtr->colorMode != PS_MODE_COLOR) {
        Rbc_AppendToPostScript(tokenPtr, "image\n", (char *)NULL);
        Rbc_ColorImageToGreyscale(image);
        Rbc_ColorImageToPsData(image, 1, &(tokenPtr->dString), " ");
    } else {
        Rbc_AppendToPostScript(tokenPtr,
                               "false 3 colorimage\n",
                               (char *)NULL);
        Rbc_ColorImageToPsData(image, 3, &(tokenPtr->dString), " ");
    }
    Rbc_AppendToPostScript(tokenPtr,
                           "\ngrestore\n\n",
                           (char *)NULL);
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_WindowToPostScript --
 *
 *      Converts a Tk window to PostScript.  If the window could not
 *      be "snapped", then a grey rectangle is drawn in its place.
 *
 * Results:
 *      None.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_WindowToPostScript(tokenPtr, tkwin, x, y)
    struct PsTokenStruct *tokenPtr;
    Tk_Window tkwin;
    double x, y;
{
    Rbc_ColorImage image;
    int width, height;

    width = Tk_Width(tkwin);
    height = Tk_Height(tkwin);
    image = Rbc_DrawableToColorImage(tkwin, Tk_WindowId(tkwin), 0, 0, width, height, GAMMA);
    if (image == NULL) {
        /* Can't grab window image so paint the window area grey */
        Rbc_AppendToPostScript(tokenPtr, "% Can't grab window \"",
                               Tk_PathName(tkwin), "\"\n", (char *)NULL);
        Rbc_AppendToPostScript(tokenPtr, "0.5 0.5 0.5 SetBgColor\n",
                               (char *)NULL);
        Rbc_RectangleToPostScript(tokenPtr, x, y, width, height);
        return;
    }
    Rbc_ColorImageToPostScript(tokenPtr, image, x, y);
    Rbc_FreeColorImage(image);
}

/*
 * -------------------------------------------------------------------------
 *
 * Rbc_PhotoToPostScript --
 *
 *      Output a PostScript image string of the given photo image.
 *      The photo is first converted into a color image and then
 *      translated into PostScript.
 *
 * Results:
 *      None.
 *
 * Side Effects:
 *      The PostScript output representing the photo is appended to
 *      the tokenPtr's dynamic string.
 *
 * -------------------------------------------------------------------------
 */
void
Rbc_PhotoToPostScript(tokenPtr, photo, x, y)
    struct PsTokenStruct *tokenPtr;
    Tk_PhotoHandle photo;
    double x, y; /* Origin of photo image */
{
    Rbc_ColorImage image;

    image = Rbc_PhotoToColorImage(photo);
    Rbc_ColorImageToPostScript(tokenPtr, image, x, y);
    Rbc_FreeColorImage(image);
}

/*
 * -----------------------------------------------------------------
 *
 * Rbc_FontToPostScript --
 *
 *      Map the Tk font to a PostScript font and point size.
 *
 *      If a Tcl array variable was specified, each element should be
 *      indexed by the X11 font name and contain a list of 1-2
 *      elements; the PostScript font name and the desired point size.
 *      The point size may be omitted and the X font point size will
 *      be used.
 *
 *      Otherwise, if the foundry is "Adobe", we try to do a plausible
 *      mapping looking at the full name of the font and building a
 *      string in the form of "Family-TypeFace".
 *
 * Returns:
 *      None.
 *
 * Side Effects:
 *      PostScript commands are output to change the type and the
 *      point size of the current font.
 *
 * -----------------------------------------------------------------
 */
void
Rbc_FontToPostScript(tokenPtr, font)
    struct PsTokenStruct *tokenPtr;
    Tk_Font font; /* Tk font to query about */
{
    XFontStruct *fontPtr = (XFontStruct *)font;
    Tcl_Interp *interp = tokenPtr->interp;
    char *fontName;
    double pointSize;
#if (TK_MAJOR_VERSION > 4)
    Tk_Uid family;
    register int i;
#endif /* TK_MAJOR_VERSION > 4 */

    fontName = Tk_NameOfFont(font);
    pointSize = 12.0;
    /*
     * Use the font variable information if it exists.
     */
    if (tokenPtr->fontVarName != NULL) {
        char *fontInfo;

        fontInfo = (char *)Tcl_GetVar2(interp, tokenPtr->fontVarName, fontName,
                                       0);
        if (fontInfo != NULL) {
            int nProps;
            char **propArr = NULL;

            if (Tcl_SplitList(interp, fontInfo, &nProps, &propArr) == TCL_OK) {
                int newSize;

                fontName = propArr[0];
                if ((nProps == 2) &&
                        (Tcl_GetInt(interp, propArr[1], &newSize) == TCL_OK)) {
                    pointSize = (double)newSize;
                }
            }
            Rbc_FormatToPostScript(tokenPtr,
                                   "%g /%s SetFont\n",
                                   pointSize, fontName);
            if (propArr != (char **)NULL) {
                ckfree((char *)propArr);
            }
            return;
        }
    }
#if (TK_MAJOR_VERSION > 4)

    /*
     * Otherwise do a quick test to see if it's a PostScript font.
     * Tk_PostScriptFontName will silently generate a bogus PostScript
     * font description, so we have to check to see if this is really a
     * PostScript font.
     */
    family = ((TkFont *) fontPtr)->fa.family;
    for (i = 0; i < nFontNames; i++) {
        if (strncasecmp(psFontMap[i].alias, family, strlen(psFontMap[i].alias))
                == 0) {
            Tcl_DString dString;

            Tcl_DStringInit(&dString);
            pointSize = (double)Tk_PostscriptFontName(font, &dString);
            fontName = Tcl_DStringValue(&dString);
            Rbc_FormatToPostScript(tokenPtr, "%g /%s SetFont\n", pointSize,
                                   fontName);
            Tcl_DStringFree(&dString);
            return;
        }
    }

#endif /* TK_MAJOR_VERSION > 4 */

    /*
     * Can't find it. Try to use the current point size.
     */
    fontName = NULL;
    pointSize = 12.0;

#ifndef  WIN32
#if (TK_MAJOR_VERSION > 4)
    /* Can you believe what I have to go through to get an XFontStruct? */
    fontPtr = XLoadQueryFont(Tk_Display(tokenPtr->tkwin), Tk_NameOfFont(font));
#endif
    if (fontPtr != NULL) {
        unsigned long fontProp;

        if (XGetFontProperty(fontPtr, XA_POINT_SIZE, &fontProp) != False) {
            pointSize = (double)fontProp / 10.0;
        }
        fontName = XFontStructToPostScript(tokenPtr->tkwin, fontPtr);
#if (TK_MAJOR_VERSION > 4)
        XFreeFont(Tk_Display(tokenPtr->tkwin), fontPtr);
#endif /* TK_MAJOR_VERSION > 4 */
    }
#endif /* !WIN32 */
    if ((fontName == NULL) || (fontName[0] == '\0')) {
        fontName = "Helvetica-Bold";	/* Defaulting to a known PS font */
    }
    Rbc_FormatToPostScript(tokenPtr, "%g /%s SetFont\n", pointSize, fontName);
}

/*
 *--------------------------------------------------------------
 *
 * TextLayoutToPostScript --
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
TextLayoutToPostScript(tokenPtr, x, y, textPtr)
    struct PsTokenStruct *tokenPtr;
    int x, y;
    TextLayout *textPtr;
{
    char *src, *dst, *end;
    int count;			/* Counts the # of bytes written to
				 * the intermediate scratch buffer. */
    TextFragment *fragPtr;
    int i;
    unsigned char c;
#if HAVE_UTF
    Tcl_UniChar ch;
#endif
    int limit;

    limit = PSTOKEN_BUFSIZ - 4; /* High water mark for the scratch
				   * buffer. */
    fragPtr = textPtr->fragArr;
    for (i = 0; i < textPtr->nFrags; i++, fragPtr++) {
        if (fragPtr->count < 1) {
            continue;
        }
        Rbc_AppendToPostScript(tokenPtr, "(", (char *)NULL);
        count = 0;
        dst = tokenPtr->scratchArr;
        src = fragPtr->text;
        end = fragPtr->text + fragPtr->count;
        while (src < end) {
            if (count > limit) {
                /* Don't let the scatch buffer overflow */
                dst = tokenPtr->scratchArr;
                dst[count] = '\0';
                Rbc_AppendToPostScript(tokenPtr, dst, (char *)NULL);
                count = 0;
            }
#if HAVE_UTF
            /*
             * INTL: For now we just treat the characters as binary
             * data and display the lower byte.  Eventually this should
             * be revised to handle international postscript fonts.
             */
            src += Tcl_UtfToUniChar(src, &ch);
            c = (unsigned char)(ch & 0xff);
#else
            c = *src++;
#endif

            if ((c == '\\') || (c == '(') || (c == ')')) {
                /*
                 * If special PostScript characters characters "\", "(",
                 * and ")" are contained in the text string, prepend
                 * backslashes to them.
                 */
                *dst++ = '\\';
                *dst++ = c;
                count += 2;
            } else if ((c < ' ') || (c > '~')) {
                /*
                 * Present non-printable characters in their octal
                 * representation.
                 */
                sprintf(dst, "\\%03o", c);
                dst += 4;
                count += 4;
            } else {
                *dst++ = c;
                count++;
            }
        }
        tokenPtr->scratchArr[count] = '\0';
        Rbc_AppendToPostScript(tokenPtr, tokenPtr->scratchArr, (char *)NULL);
        Rbc_FormatToPostScript(tokenPtr, ") %d %d %d DrawAdjText\n",
                               fragPtr->width, x + fragPtr->x, y + fragPtr->y);
    }
}

/*
 * -----------------------------------------------------------------
 *
 * Rbc_TextToPostScript --
 *
 *      Output PostScript commands to print a text string. The string
 *      may be rotated at any arbitrary angle, and placed according
 *      the anchor type given. The anchor indicates how to interpret
 *      the window coordinates as an anchor for the text bounding box.
 *
 * Results:
 *      None.
 *
 * Side Effects:
 *      Text string is drawn using the given font and GC on the graph
 *      window at the given coordinates, anchor, and rotation
 *
 * -----------------------------------------------------------------
 */
void
Rbc_TextToPostScript(tokenPtr, string, tsPtr, x, y)
    struct PsTokenStruct *tokenPtr;
    char *string; /* String to convert to PostScript */
    TextStyle *tsPtr; /* Text attribute information */
    double x, y; /* Window coordinates where to print text */
{
    double theta;
    double rotWidth, rotHeight;
    TextLayout *textPtr;
    Point2D anchorPos;

    if ((string == NULL) || (*string == '\0')) { /* Empty string, do nothing */
        return;
    }
    theta = FMOD(tsPtr->theta, (double)360.0);
    textPtr = Rbc_GetTextLayout(string, tsPtr);
    Rbc_GetBoundingBox(textPtr->width, textPtr->height, theta, &rotWidth,
                       &rotHeight, (Point2D *)NULL);
    /*
     * Find the center of the bounding box
     */
    anchorPos.x = x, anchorPos.y = y;
    anchorPos = Rbc_TranslatePoint(&anchorPos, ROUND(rotWidth), ROUND(rotHeight), tsPtr->anchor);
    anchorPos.x += (rotWidth * 0.5);
    anchorPos.y += (rotHeight * 0.5);

    /* Initialize text (sets translation and rotation) */
    Rbc_FormatToPostScript(tokenPtr, "%d %d %g %g %g BeginText\n",
                           textPtr->width, textPtr->height, tsPtr->theta, anchorPos.x,
                           anchorPos.y);

    Rbc_FontToPostScript(tokenPtr, tsPtr->font);

    /* All coordinates are now relative to what was set by BeginText */
    if ((tsPtr->shadow.offset > 0) && (tsPtr->shadow.color != NULL)) {
        Rbc_ForegroundToPostScript(tokenPtr, tsPtr->shadow.color);
        TextLayoutToPostScript(tokenPtr, tsPtr->shadow.offset,
                               tsPtr->shadow.offset, textPtr);
    }
    Rbc_ForegroundToPostScript(tokenPtr, (tsPtr->state & STATE_ACTIVE) ? tsPtr->activeColor : tsPtr->color);
    TextLayoutToPostScript(tokenPtr, 0, 0, textPtr);
    ckfree((char *)textPtr);
    Rbc_AppendToPostScript(tokenPtr, "EndText\n", (char *)NULL);
}

/*
 * -----------------------------------------------------------------
 *
 * Rbc_LineToPostScript --
 *
 *      Outputs PostScript commands to print a multi-segmented line.
 *      It assumes a procedure DashesProc was previously defined.
 *
 * Results:
 *      None.
 *
 * Side Effects:
 *      Segmented line is printed.
 *
 * -----------------------------------------------------------------
 */
void
Rbc_LineToPostScript(tokenPtr, pointPtr, nPoints)
    struct PsTokenStruct *tokenPtr;
    register XPoint *pointPtr;
    int nPoints;
{
    register int i;

    if (nPoints <= 0) {
        return;
    }
    Rbc_FormatToPostScript(tokenPtr, " newpath %d %d moveto\n",
                           pointPtr->x, pointPtr->y);
    pointPtr++;
    for (i = 1; i < (nPoints - 1); i++, pointPtr++) {
        Rbc_FormatToPostScript(tokenPtr, " %d %d lineto\n",
                               pointPtr->x, pointPtr->y);
        if ((i % PS_MAXPATH) == 0) {
            Rbc_FormatToPostScript(tokenPtr,
                                   "DashesProc stroke\n newpath  %d %d moveto\n",
                                   pointPtr->x, pointPtr->y);
        }
    }
    Rbc_FormatToPostScript(tokenPtr, " %d %d lineto\n",
                           pointPtr->x, pointPtr->y);
    Rbc_AppendToPostScript(tokenPtr, "DashesProc stroke\n", (char *)NULL);
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_BitmapToPostScript --
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
Rbc_BitmapToPostScript(tokenPtr, display, bitmap, scaleX, scaleY)
    struct PsTokenStruct *tokenPtr;
    Display *display;
    Pixmap bitmap; /* Bitmap to be converted to PostScript */
    double scaleX, scaleY;
{
    int width, height;
    double scaledWidth, scaledHeight;

    Tk_SizeOfBitmap(display, bitmap, &width, &height);
    scaledWidth = (double)width * scaleX;
    scaledHeight = (double)height * scaleY;
    Rbc_AppendToPostScript(tokenPtr, "  gsave\n", (char *)NULL);
    Rbc_FormatToPostScript(tokenPtr, "    %g %g translate\n",
                           scaledWidth * -0.5, scaledHeight * 0.5);
    Rbc_FormatToPostScript(tokenPtr, "    %g %g scale\n",
                           scaledWidth, -scaledHeight);
    Rbc_FormatToPostScript(tokenPtr, "    %d %d true [%d 0 0 %d 0 %d] {",
                           width, height, width, -height, height);
    Rbc_BitmapDataToPostScript(tokenPtr, display, bitmap, width, height);
    Rbc_AppendToPostScript(tokenPtr, "    } imagemask\n  grestore\n",
                           (char *)NULL);
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_2DSegmentsToPostScript --
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
Rbc_2DSegmentsToPostScript(psToken, segPtr, nSegments)
    PsToken psToken;
    register Segment2D *segPtr;
    int nSegments;
{
    register Segment2D *endPtr;

    for (endPtr = segPtr + nSegments; segPtr < endPtr; segPtr++) {
        Rbc_FormatToPostScript(psToken, "%g %g moveto\n",
                               segPtr->p.x, segPtr->p.y);
        Rbc_FormatToPostScript(psToken, " %g %g lineto\n",
                               segPtr->q.x, segPtr->q.y);
        Rbc_AppendToPostScript(psToken, "DashesProc stroke\n", (char *)NULL);
    }
}
