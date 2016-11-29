/*
 * rbcImage.h --
 *
 *      TODO: Description
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#include <X11/Xutil.h>
#ifndef WIN32
#include <X11/Xproto.h>
#endif

#ifndef _RBCIMAGE
#define _RBCIMAGE

#define DIV255(i) ((((i) + 1) + (((i) + 1) >> 8) ) >> 8)

#define GAMMA	(1.0)

#define ROTATE_0	0
#define ROTATE_90	1
#define ROTATE_180	2
#define ROTATE_270	3

/*
 *----------------------------------------------------------------------
 *
 * Pix32 --
 *
 *      A union representing either a pixel as a RGB triplet or a
 *	single word value.
 *
 *----------------------------------------------------------------------
 */
typedef union {
    unsigned int value;		/* Lookup table address */
    struct RGBA {
        unsigned char red;	/* Red intensity 0..255 */
        unsigned char green;	/* Green intensity 0.255 */
        unsigned char blue;	/* Blue intensity 0..255 */
        unsigned char alpha;	/* Alpha-channel for compositing. 0..255 */
    } rgba;
    unsigned char channel[4];
} Pix32;

#define Red	rgba.red
#define Blue	rgba.blue
#define Green	rgba.green
#define Alpha	rgba.alpha


typedef struct {
    XColor exact, best;
    double error;
    unsigned int freq;
    int allocated;
    int index;
} ColorInfo;


/*
 *----------------------------------------------------------------------
 *
 * ColorTable --
 *
 *	For colormap-ed visuals, this structure contains color lookup
 *	information needed to translate RGB triplets to pixel indices.
 *
 *	This structure isn't needed for TrueColor or Monochrome visuals.
 *
 *	DirectColor:
 *		Pixel values for each color channel
 *	StaticColor, PsuedoColor, StaticGray, and GrayScale:
 *		Red represents the 8-bit color. Green and Blue pixel
 *		values are unused.
 *
 *----------------------------------------------------------------------
 */
typedef struct ColorTableStruct {
    double outputGamma;		/* Gamma correction value */
    Display *display;		/* Display of colortable. Used to free
				 * colors allocated. */
    XVisualInfo visualInfo;	/* Visual information for window displaying
				 * the image. */
    Colormap colorMap;		/* Colormap used.  This may be the default
				 * colormap, or an allocated private map. */
    int flags;
    unsigned int red[256], green[256], blue[256];

    /* Array of allocated pixels in colormap */
    ColorInfo colorInfo[256];
    ColorInfo *sortedColors[256];

    int nUsedColors, nFreeColors;
    int nPixels;		/* Number of colors in the quantized image */
    unsigned long int pixelValues[256];

    unsigned int *lut;		/* Color lookup table. Used to collect
				 * frequencies of colors and later
				 * colormap indices */
} *ColorTable;

#define PRIVATE_COLORMAP	1
#define RGBIndex(r,g,b) (((r)<<10) + ((r)<<6) + (r) + ((g) << 5) + (g) + (b))

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ColorImage --
 *
 *      The structure below represents a color image.  Each pixel
 *	occupies a 32-bit word of memory: one byte for each of the
 *	red, green, and blue color intensities, and another for
 *	alpha-channel image compositing (e.g. transparency).
 *
 *----------------------------------------------------------------------
 */
typedef struct ColorImage {
    int width, height;		/* Dimensions of the image */
    Pix32 *bits;		/* Array of pixels representing the image. */
} *Rbc_ColorImage;

/*
 * Rbc_ColorImage is supposed to be an opaque type.
 * Use the macros below to access its members.
 */
#define Rbc_ColorImageHeight(c)	((c)->height)
#define Rbc_ColorImageWidth(c)	((c)->width)
#define Rbc_ColorImageBits(c)	((c)->bits)
#define Rbc_ColorImagePixel(c, x, y) ((c)->bits + ((c)->width * (y)) + (x))

/*
 *----------------------------------------------------------------------
 *
 * ResampleFilterProc --
 *
 *      A function implementing a 1-D filter.
 *
 *----------------------------------------------------------------------
 */
typedef double (ResampleFilterProc) _ANSI_ARGS_((double value));

/*
 *----------------------------------------------------------------------
 *
 * ResampleFilter --
 *
 *      Contains information about a 1-D filter (its support and
 *	the procedure implementing the filter).
 *
 *----------------------------------------------------------------------
 */
typedef struct {
    char *name;			/* Name of the filter */
    ResampleFilterProc *proc;	/* 1-D filter procedure. */
    double support;		/* Width of 1-D filter */
} ResampleFilter;

extern ResampleFilter *rbcBoxFilterPtr; /* The ubiquitous box filter */

/*
 *----------------------------------------------------------------------
 *
 * Filter2D --
 *
 *      Defines a convolution mask for a 2-D filter.  Used to smooth or
 *	enhance images.
 *
 *----------------------------------------------------------------------
 */
typedef struct {
    double support;		/* Radius of filter */
    double sum, scale;		/* Sum of kernel */
    double *kernel;		/* Array of values (malloc-ed) representing
				 * the discrete 2-D filter. */
} Filter2D;

/* Prototypes of image routines */

void Rbc_ColorImageToGreyscale _ANSI_ARGS_((Rbc_ColorImage image));

void Rbc_ColorImageToPhoto _ANSI_ARGS_((Tcl_Interp *interp, Rbc_ColorImage image,
                                        Tk_PhotoHandle photo));

Pixmap Rbc_ColorImageToPixmap _ANSI_ARGS_((Tcl_Interp *interp,
        Tk_Window tkwin, Rbc_ColorImage image, ColorTable *colorTablePtr));

Rbc_ColorImage Rbc_ConvolveColorImage _ANSI_ARGS_((
            Rbc_ColorImage srcImage, Filter2D *filter));

Rbc_ColorImage Rbc_CreateColorImage _ANSI_ARGS_((int width,int height));

Rbc_ColorImage Rbc_DrawableToColorImage _ANSI_ARGS_((Tk_Window tkwin,
        Drawable drawable, int x, int y, int width, int height,
        double inputGamma));

int Rbc_GetResampleFilter _ANSI_ARGS_((Tcl_Interp *interp,
                                       char *filterName, ResampleFilter **filterPtrPtr));

void Rbc_FreeColorImage _ANSI_ARGS_((Rbc_ColorImage image));

#if HAVE_JPEG
Rbc_ColorImage Rbc_JPEGToColorImage _ANSI_ARGS_((Tcl_Interp *interp,
        char *fileName));
#endif

Rbc_ColorImage Rbc_PhotoToColorImage _ANSI_ARGS_((
            Tk_PhotoHandle photo));

Rbc_ColorImage Rbc_PhotoRegionToColorImage _ANSI_ARGS_((
            Tk_PhotoHandle photo, int x, int y, int width, int height));

int Rbc_QuantizeColorImage _ANSI_ARGS_((Rbc_ColorImage src,
                                        Rbc_ColorImage dest, int nColors));

Rbc_ColorImage Rbc_ResampleColorImage _ANSI_ARGS_((Rbc_ColorImage image,
        int destWidth, int destHeight, ResampleFilter *horzFilterPtr,
        ResampleFilter *vertFilterPtr));

void Rbc_ResamplePhoto _ANSI_ARGS_((Tcl_Interp *interp, Tk_PhotoHandle srcPhoto,
                                    int x, int y, int width, int height, Tk_PhotoHandle destPhoto,
                                    ResampleFilter *horzFilterPtr, ResampleFilter *vertFilterPtr));

Rbc_ColorImage Rbc_ResizeColorImage _ANSI_ARGS_((Rbc_ColorImage src,
        int x, int y, int width, int height, int destWidth, int destHeight));

Rbc_ColorImage Rbc_ResizeColorSubimage _ANSI_ARGS_((Rbc_ColorImage src,
        int x, int y, int width, int height, int destWidth, int destHeight));

Rbc_ColorImage Rbc_RotateColorImage _ANSI_ARGS_((Rbc_ColorImage image,
        double theta));

void Rbc_ResizePhoto _ANSI_ARGS_((Tcl_Interp *interp, Tk_PhotoHandle srcPhoto, int x, int y,
                                  int width, int height, Tk_PhotoHandle destPhoto));

int Rbc_SnapPhoto _ANSI_ARGS_((Tcl_Interp *interp, Tk_Window tkwin,
                               Drawable drawable, int x, int y, int width, int height, int destWidth,
                               int destHeight, char *photoName, double inputGamma));

Region2D *Rbc_SetRegion _ANSI_ARGS_((int x, int y, int width,
                                     int height, Region2D *regionPtr));

ColorTable Rbc_CreateColorTable _ANSI_ARGS_((Tk_Window tkwin));

ColorTable Rbc_DirectColorTable _ANSI_ARGS_((Tcl_Interp *interp,
        Tk_Window tkwin, Rbc_ColorImage image));

ColorTable Rbc_PseudoColorTable _ANSI_ARGS_((Tcl_Interp *interp,
        Tk_Window tkwin, Rbc_ColorImage image));

void Rbc_FreeColorTable _ANSI_ARGS_((ColorTable colorTable));

/* Missing routines from the Tk photo C API */

int Tk_ImageIsDeleted _ANSI_ARGS_((Tk_Image tkImage));
Tk_ImageMaster Tk_ImageGetMaster _ANSI_ARGS_((Tk_Image tkImage));
Tk_ImageType *Tk_ImageGetType _ANSI_ARGS_((Tk_Image tkImage));
Pixmap Tk_ImageGetPhotoPixmap _ANSI_ARGS_((Tk_Image photoImage));
GC Tk_ImageGetPhotoGC _ANSI_ARGS_((Tk_Image photoImage));

char *Rbc_NameOfImage _ANSI_ARGS_((Tk_Image tkImage));
Tk_Image Rbc_CreateTemporaryImage _ANSI_ARGS_((Tcl_Interp *interp,
        Tk_Window tkwin, ClientData clientData));
int Rbc_DestroyTemporaryImage _ANSI_ARGS_((Tcl_Interp *interp,
        Tk_Image tkImage));

GC Rbc_GetBitmapGC _ANSI_ARGS_((Tk_Window tkwin));
Pixmap Rbc_PhotoImageMask _ANSI_ARGS_((Tk_Window tkwin,
                                       Tk_PhotoImageBlock src));

Pixmap Rbc_RotateBitmap _ANSI_ARGS_((Tk_Window tkwin, Pixmap bitmap,
                                     int width, int height, double theta, int *widthPtr, int *heightPtr));

Pixmap Rbc_ScaleBitmap _ANSI_ARGS_((Tk_Window tkwin, Pixmap srcBitmap,
                                    int srcWidth, int srcHeight, int scaledWidth, int scaledHeight));

Pixmap Rbc_ScaleRotateBitmapRegion _ANSI_ARGS_((Tk_Window tkwin,
        Pixmap srcBitmap, unsigned int srcWidth, unsigned int srcHeight,
        int regionX, int regionY, unsigned int regionWidth,
        unsigned int regionHeight, unsigned int virtWidth,
        unsigned int virtHeight, double theta));

#endif /* _RBCIMAGE */
