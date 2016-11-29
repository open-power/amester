/*
 * rbcText.h --
 *
 *      TODO: Description
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#ifndef _RBCTEXT
#define _RBCTEXT

#define DEF_TEXT_FLAGS (TK_PARTIAL_OK | TK_IGNORE_NEWLINES)



/*
 * ----------------------------------------------------------------------
 *
 * TextFragment --
 *
 * ----------------------------------------------------------------------
 */
typedef struct {
    char *text;			/* Text to be displayed */

    short int x, y;		/* X-Y offset of the baseline from the
				 * upper-left corner of the bbox. */

    short int sx, sy;		/* See rbcWinUtil.c */

    short int count;		/* Number of bytes in text. The actual
				 * character count may differ because of
				 * multi-byte UTF encodings. */

    short int width;		/* Width of segment in pixels. This
				 * information is used to draw
				 * PostScript strings the same width
				 * as X. */
} TextFragment;

/*
 * ----------------------------------------------------------------------
 *
 * TextLayout --
 *
 * ----------------------------------------------------------------------
 */
typedef struct {
    int nFrags;			/* # fragments of text */
    short int width, height;	/* Dimensions of text bounding box */
    TextFragment fragArr[1];	/* Information about each fragment of text */
} TextLayout;

typedef struct {
    XColor *color;
    int offset;
} Shadow;

/*
 * ----------------------------------------------------------------------
 *
 * TextStyle --
 *
 * 	Represents a convenient structure to hold text attributes
 *	which determine how a text string is to be displayed on the
 *	window, or drawn with PostScript commands.  The alternative
 *	is to pass lots of parameters to the drawing and printing
 *	routines. This seems like a more efficient and less cumbersome
 *	way of passing parameters.
 *
 * ----------------------------------------------------------------------
 */
typedef struct {
    unsigned int state;		/* If non-zero, indicates to draw text
				 * in the active color */
    short int width, height;	/* Extents of text */

    XColor *color;		/* Normal color */
    XColor *activeColor;	/* Active color */
    Tk_Font font;		/* Font to use to draw text */
    Tk_3DBorder border;		/* Background color of text.  This is also
				 * used for drawing disabled text. */
    Shadow shadow;		/* Drop shadow color and offset */
    Tk_Justify justify;		/* Justification of the text string. This
				 * only matters if the text is composed
				 * of multiple lines. */
    GC gc;			/* GC used to draw the text */
    double theta;		/* Rotation of text in degrees. */
    Tk_Anchor anchor;		/* Indicates how the text is anchored around
				 * its x and y coordinates. */
    Rbc_Pad padX, padY;		/* # pixels padding of around text region */
    short int leader;		/* # pixels spacing between lines of text */

} TextStyle;


TextLayout *Rbc_GetTextLayout _ANSI_ARGS_((char *string, TextStyle *stylePtr));

void Rbc_GetTextExtents _ANSI_ARGS_((TextStyle *stylePtr,
                                     char *text, int *widthPtr, int *heightPtr));

void Rbc_InitTextStyle _ANSI_ARGS_((TextStyle *stylePtr));

void Rbc_ResetTextStyle _ANSI_ARGS_((Tk_Window tkwin,
                                     TextStyle *stylePtr));

void Rbc_FreeTextStyle _ANSI_ARGS_((Display *display,
                                    TextStyle *stylePtr));

void Rbc_SetDrawTextStyle _ANSI_ARGS_((TextStyle *stylePtr,
                                       Tk_Font font, GC gc, XColor *normalColor, XColor *activeColor,
                                       XColor *shadowColor, double theta, Tk_Anchor anchor, Tk_Justify justify,
                                       int leader, int shadowOffset));

void Rbc_SetPrintTextStyle _ANSI_ARGS_((TextStyle *stylePtr,
                                        Tk_Font font, XColor *fgColor, XColor *bgColor, XColor *shadowColor,
                                        double theta, Tk_Anchor anchor, Tk_Justify justify, int leader,
                                        int shadowOffset));

void Rbc_DrawText _ANSI_ARGS_((Tk_Window tkwin, Drawable drawable,
                               char *string, TextStyle *stylePtr, int x, int y));

void Rbc_DrawTextLayout _ANSI_ARGS_((Tk_Window tkwin,
                                     Drawable drawable, TextLayout *textPtr, TextStyle *stylePtr,
                                     int x, int y));

void Rbc_DrawText2 _ANSI_ARGS_((Tk_Window tkwin, Drawable drawable,
                                char *string, TextStyle *stylePtr, int x, int y,
                                Dim2D * dimPtr));

Pixmap Rbc_CreateTextBitmap _ANSI_ARGS_((Tk_Window tkwin,
                                        TextLayout *textPtr, TextStyle *stylePtr, int *widthPtr,
                                        int *heightPtr));

int Rbc_DrawRotatedText _ANSI_ARGS_((Display *display,
                                     Drawable drawable, int x, int y, double theta,
                                     TextStyle *stylePtr, TextLayout *textPtr));

#endif /* _RBCTEXT */
