/*
 * rbcImage.c --
 *
 *      This module implements image processing procedures for the rbc
 *      toolkit.
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#include "rbcInt.h"
#include "rbcImage.h"
#include <X11/Xutil.h>
#ifndef WIN32
#include <X11/Xproto.h>
#endif

#define CLAMP(c)	((((c) < 0.0) ? 0.0 : ((c) > 255.0) ? 255.0 : (c)))

#define NC		256
enum ColorIndices { RED, GREEN, BLUE };

#define R0	(cubePtr->r0)
#define R1	(cubePtr->r1)
#define G0	(cubePtr->g0)
#define G1	(cubePtr->g1)
#define B0	(cubePtr->b0)
#define B1	(cubePtr->b1)

typedef struct {
    int r0, r1;			/* min, max values:
				 * min exclusive max inclusive */
    int g0, g1;
    int b0, b1;
    int vol;
} Cube;

/*
 *----------------------------------------------------------------------
 *
 * Histogram is in elements 1..HISTSIZE along each axis,
 * element 0 is for base or marginal value
 * NB: these must start out 0!
 *----------------------------------------------------------------------
 */
typedef struct {
    long int wt[33][33][33];	/* # pixels in voxel */
    long int mR[33][33][33];	/* Sum over voxel of red pixel values */
    long int mG[33][33][33];	/* Sum over voxel of green pixel values */
    long int mB[33][33][33];	/* Sum over voxel of blue pixel values */
    long int gm2[33][33][33];	/* Variance */
} ColorImageStatistics;

static void ZoomImageVertically _ANSI_ARGS_((Rbc_ColorImage src, Rbc_ColorImage dest, ResampleFilter *filterPtr));
static void ZoomImageHorizontally _ANSI_ARGS_((Rbc_ColorImage src, Rbc_ColorImage dest, ResampleFilter *filterPtr));
static void ShearY _ANSI_ARGS_((Rbc_ColorImage src, Rbc_ColorImage dest, int y, int offset, double frac, Pix32 bgColor));
static void ShearX _ANSI_ARGS_((Rbc_ColorImage src, Rbc_ColorImage dest, int x, int offset, double frac, Pix32 bgColor));
static Rbc_ColorImage Rotate45 _ANSI_ARGS_((Rbc_ColorImage src, double theta, Pix32 bgColor));
static Rbc_ColorImage CopyColorImage _ANSI_ARGS_((Rbc_ColorImage src));
static Rbc_ColorImage Rotate90 _ANSI_ARGS_((Rbc_ColorImage src));
static Rbc_ColorImage Rotate180 _ANSI_ARGS_((Rbc_ColorImage src));
static Rbc_ColorImage Rotate270 _ANSI_ARGS_((Rbc_ColorImage src));
static ColorImageStatistics *GetColorImageStatistics _ANSI_ARGS_((Rbc_ColorImage image));
static void M3d _ANSI_ARGS_((ColorImageStatistics *s));
static INLINE long int Volume _ANSI_ARGS_((Cube *cubePtr, long int m[33][33][33]));
static long int Bottom _ANSI_ARGS_((Cube *cubePtr, unsigned char dir, long int m[33][33][33]));
static long int Top _ANSI_ARGS_((Cube *cubePtr, unsigned char dir, int pos, long int m[33][33][33]));
static double Variance _ANSI_ARGS_((Cube *cubePtr, ColorImageStatistics *s));
static double Maximize _ANSI_ARGS_((Cube *cubePtr, unsigned char dir, int first, int last, int *cut, long int rWhole, long int gWhole, long int bWhole, long int wWhole, ColorImageStatistics *s));
static int Cut _ANSI_ARGS_((Cube *set1, Cube *set2, ColorImageStatistics *s));
static int SplitColorSpace _ANSI_ARGS_((ColorImageStatistics *s, Cube *cubes, int nColors));
static void Mark _ANSI_ARGS_((Cube *cubePtr, int label, unsigned int tag[33][33][33]));
static unsigned int *CreateColorLookupTable _ANSI_ARGS_((ColorImageStatistics *s, Cube *cubes, int nColors));
static void MapColors _ANSI_ARGS_((Rbc_ColorImage src, Rbc_ColorImage dest, unsigned int lut[33][33][33]));

ResampleFilter *rbcBoxFilterPtr; /* The ubiquitous box filter */

/*
 *----------------------------------------------------------------------
 *
 * Rbc_CreateColorImage --
 *
 *      Allocates a color image of a designated height and width.
 *
 *      This routine will be augmented with other types of information
 *      such as a color table, etc.
 *
 * Results:
 *      Returns the new color image.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
Rbc_ColorImage
Rbc_CreateColorImage(width, height)
    int width, height; /* Dimensions of new image */
{
    struct ColorImage *imagePtr;
    size_t size;

    size = width * height;
    imagePtr = (struct ColorImage *)ckalloc(sizeof(struct ColorImage));
    assert(imagePtr);
    imagePtr->bits = (Pix32 *)ckalloc(sizeof(Pix32) * size);
    assert(imagePtr->bits);

    imagePtr->width = width;
    imagePtr->height = height;
    return imagePtr;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_FreeColorImage --
 *
 *      Deallocates the given color image.
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
Rbc_FreeColorImage(imagePtr)
    struct ColorImage *imagePtr;
{
    ckfree((char *)imagePtr->bits);
    ckfree((char *)imagePtr);
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_GetPlatformId --
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
Rbc_GammaCorrectColorImage(src, newGamma)
    Rbc_ColorImage src;
    double newGamma;
{
    unsigned int nPixels;
    register Pix32 *srcPtr, *endPtr;
    register unsigned int i;
    double value;
    unsigned char lut[256];
    double invGamma;

    invGamma = 1.0 / newGamma;
    for (i = 0; i < 256; i++) {
        value = 255.0 * pow((double)i / 255.0, invGamma);
        lut[i] = (unsigned char)CLAMP(value);
    }
    nPixels = Rbc_ColorImageWidth(src) * Rbc_ColorImageHeight(src);
    srcPtr = Rbc_ColorImageBits(src);
    for (endPtr = srcPtr + nPixels; srcPtr < endPtr; srcPtr++) {
        srcPtr->Red = lut[srcPtr->Red];
        srcPtr->Green = lut[srcPtr->Green];
        srcPtr->Blue = lut[srcPtr->Blue];
    }
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ColorImageToGreyscale --
 *
 *      Converts a color image to PostScript grey scale (1 component)
 *      output.  Luminosity isn't computed using the old NTSC formula,
 *
 *        Y = 0.299 * Red + 0.587 * Green + 0.114 * Blue
 *
 *      but the following
 *
 *        Y = 0.212671 * Red + 0.715160 * Green + 0.072169 * Blue
 *
 *      which better represents contemporary monitors.
 *
 * Results:
 *      The color image is converted to greyscale.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_ColorImageToGreyscale(image)
    Rbc_ColorImage image;
{
    register Pix32 *srcPtr, *endPtr;
    double Y;
    int nPixels;
    int width, height;

    width = Rbc_ColorImageWidth(image);
    height = Rbc_ColorImageHeight(image);
    nPixels = width * height;
    srcPtr = Rbc_ColorImageBits(image);
    for (endPtr = srcPtr + nPixels; srcPtr < endPtr; srcPtr++) {
        Y = ((0.212671 * (double)srcPtr->Red) +
             (0.715160 * (double)srcPtr->Green) +
             (0.072169 * (double)srcPtr->Blue));
        srcPtr->Red = srcPtr->Green = srcPtr->Blue = (unsigned char)CLAMP(Y);
    }
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ColorImageToPhoto --
 *
 *      Translates a color image into a Tk photo.
 *
 * Results:
 *      The photo is re-written with the new color image.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_ColorImageToPhoto(interp, src, photo)
    Tcl_Interp *interp;
    Rbc_ColorImage src; /* Image to use as source */
    Tk_PhotoHandle photo; /* Photo to write color image into */
{
    Tk_PhotoImageBlock dest;
    int width, height;

    width = Rbc_ColorImageWidth(src);
    height = Rbc_ColorImageHeight(src);

    Tk_PhotoGetImage(photo, &dest);
    dest.pixelSize = sizeof(Pix32);
    dest.pitch = sizeof(Pix32) * width;
    dest.width = width;
    dest.height = height;
    dest.offset[0] = Tk_Offset(Pix32, Red);
    dest.offset[1] = Tk_Offset(Pix32, Green);
    dest.offset[2] = Tk_Offset(Pix32, Blue);
    dest.offset[3] = Tk_Offset(Pix32, Alpha);
    dest.pixelPtr = (unsigned char *)Rbc_ColorImageBits(src);
    Tk_PhotoSetSize(photo, width, height);
    Tk_PhotoPutBlock(photo, &dest, 0, 0, width, height);
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_PhotoRegionToColorImage --
 *
 *      Create a photo to a color image.
 *
 * Results:
 *      The new color image is returned.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
Rbc_ColorImage
Rbc_PhotoRegionToColorImage(photo, x, y, width, height)
    Tk_PhotoHandle photo; /* Source photo image to scale */
    int x, y;
    int width, height;
{
    Tk_PhotoImageBlock src;
    Rbc_ColorImage image;
    register Pix32 *destPtr;
    register unsigned char *srcData;
    register int offset;
    unsigned int offR, offG, offB, offA;

    Tk_PhotoGetImage(photo, &src);
    if (x < 0) {
        x = 0;
    }
    if (y < 0) {
        y = 0;
    }
    if (width < 0) {
        width = src.width;
    }
    if (height < 0) {
        height = src.height;
    }
    if ((x + width) > src.width) {
        width = src.width - x;
    }
    if ((height + y) > src.height) {
        height = src.width - y;
    }
    image = Rbc_CreateColorImage(width, height);
    destPtr = Rbc_ColorImageBits(image);

    offset = (x * src.pixelSize) + (y * src.pitch);

    offR = src.offset[0];
    offG = src.offset[1];
    offB = src.offset[2];
    offA = src.offset[3];

    if (src.pixelSize == 4) {
        for (y = 0; y < height; y++) {
            srcData = src.pixelPtr + offset;
            for (x = 0; x < width; x++) {
                destPtr->Red = srcData[offR];
                destPtr->Green = srcData[offG];
                destPtr->Blue = srcData[offB];
                destPtr->Alpha = srcData[offA];
                srcData += src.pixelSize;
                destPtr++;
            }
            offset += src.pitch;
        }
    } else if (src.pixelSize == 3) {
        for (y = 0; y < height; y++) {
            srcData = src.pixelPtr + offset;
            for (x = 0; x < width; x++) {
                destPtr->Red = srcData[offR];
                destPtr->Green = srcData[offG];
                destPtr->Blue = srcData[offB];
                /* No transparency information */
                destPtr->Alpha = (unsigned char)-1;
                srcData += src.pixelSize;
                destPtr++;
            }
            offset += src.pitch;
        }
    } else {
        for (y = 0; y < height; y++) {
            srcData = src.pixelPtr + offset;
            for (x = 0; x < width; x++) {
                destPtr->Red = destPtr->Green = destPtr->Blue = srcData[offA];
                /* No transparency information */
                destPtr->Alpha = (unsigned char)-1;
                srcData += src.pixelSize;
                destPtr++;
            }
            offset += src.pitch;
        }
    }
    return image;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_PhotoToColorImage --
 *
 *      Create a photo to a color image.
 *
 * Results:
 *      The new color image is returned.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
Rbc_ColorImage
Rbc_PhotoToColorImage(photo)
    Tk_PhotoHandle photo; /* Source photo image to scale */
{
    Rbc_ColorImage image;
    Tk_PhotoImageBlock src;
    int width, height;
    register Pix32 *destPtr;
    register int offset;
    register int x, y;
    register unsigned char *srcData;

    Tk_PhotoGetImage(photo, &src);
    width = src.width;
    height = src.height;
    image = Rbc_CreateColorImage(width, height);
    destPtr = Rbc_ColorImageBits(image);
    offset = 0;
    if (src.pixelSize == 4) {
        for (y = 0; y < height; y++) {
            srcData = src.pixelPtr + offset;
            for (x = 0; x < width; x++) {
                destPtr->Red = srcData[src.offset[0]];
                destPtr->Green = srcData[src.offset[1]];
                destPtr->Blue = srcData[src.offset[2]];
                destPtr->Alpha = srcData[src.offset[3]];
                srcData += src.pixelSize;
                destPtr++;
            }
            offset += src.pitch;
        }
    } else if (src.pixelSize == 3) {
        for (y = 0; y < height; y++) {
            srcData = src.pixelPtr + offset;
            for (x = 0; x < width; x++) {
                destPtr->Red = srcData[src.offset[0]];
                destPtr->Green = srcData[src.offset[1]];
                destPtr->Blue = srcData[src.offset[2]];
                /* No transparency information */
                destPtr->Alpha = (unsigned char)-1;
                srcData += src.pixelSize;
                destPtr++;
            }
            offset += src.pitch;
        }
    } else {
        for (y = 0; y < height; y++) {
            srcData = src.pixelPtr + offset;
            for (x = 0; x < width; x++) {
                destPtr->Red = destPtr->Green = destPtr->Blue =
                                                    srcData[src.offset[0]];
                /* No transparency information */
                destPtr->Alpha = (unsigned char)-1;
                srcData += src.pixelSize;
                destPtr++;
            }
            offset += src.pitch;
        }
    }
    return image;
}

/*
 *	filter function definitions
 */

static ResampleFilterProc DefaultFilter;
static ResampleFilterProc BellFilter;
static ResampleFilterProc BesselFilter;
static ResampleFilterProc BoxFilter;
static ResampleFilterProc BSplineFilter;
static ResampleFilterProc CatRomFilter;
static ResampleFilterProc DummyFilter;
static ResampleFilterProc GaussianFilter;
static ResampleFilterProc GiFilter;
static ResampleFilterProc Lanczos3Filter;
static ResampleFilterProc MitchellFilter;
static ResampleFilterProc SincFilter;
static ResampleFilterProc TriangleFilter;
static Tk_ImageChangedProc TempImageChangedProc;

/*
 *--------------------------------------------------------------
 *
 * DefaultFilter --
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
static double
DefaultFilter(x)
    double x;
{
    if (x < 0.0) {
        x = -x;
    }
    if (x < 1.0) {
        /* f(x) = 2x^3 - 3x^2 + 1, -1 <= x <= 1 */
        return (2.0 * x - 3.0) * x * x + 1.0;
    }
    return 0.0;
}

/*
 *--------------------------------------------------------------
 *
 * DummyFilter --
 *
 *      Just for testing...
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static double
DummyFilter(x)
    double x;
{
    return FABS(x);
}

/*
 *
 * Finite filters in increasing order:
 *
 *      Box (constant)
 *      Triangle (linear)
 *      Bell
 *      BSpline (cubic)
 *
 */

/*
 *--------------------------------------------------------------
 *
 * BoxFilter --
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
static double
BoxFilter(x)
    double x;
{
    if ((x < -0.5) || (x > 0.5)) {
        return 0.0;
    }
    return 1.0;
}

/*
 *--------------------------------------------------------------
 *
 * TriangleFilter --
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
static double
TriangleFilter(x)
    double x;
{
    if (x < 0.0) {
        x = -x;
    }
    if (x < 1.0) {
        return (1.0 - x);
    }
    return 0.0;
}

/*
 *--------------------------------------------------------------
 *
 * BellFilter --
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
static double
BellFilter(x)
    double x;
{
    if (x < 0.0) {
        x = -x;
    }
    if (x < 0.5) {
        return (0.75 - (x * x));
    }
    if (x < 1.5) {
        x = (x - 1.5);
        return (0.5 * (x * x));
    }
    return 0.0;
}

/*
 *--------------------------------------------------------------
 *
 * BSplineFilter --
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
static double
BSplineFilter(x)
    double x;
{
    double x2;

    if (x < 0.0) {
        x = -x;
    }
    if (x < 1) {
        x2 = x * x;
        return ((.5 * x2 * x) - x2 + (2.0 / 3.0));
    } else if (x < 2) {
        x = 2 - x;
        return ((x * x * x) / 6.0);
    }
    return 0.0;
}

/*
 *
 * Infinite Filters:
 *      Sinc		perfect lowpass filter
 *      Bessel		circularly symmetric 2-D filter
 *      Gaussian
 *      Lanczos3
 *      Mitchell
 */

/*
 *--------------------------------------------------------------
 *
 * SincFilter --
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
static double
SincFilter(x)
    double x;
{
    x *= M_PI;
    if (x == 0.0) {
        return 1.0;
    }
    return (sin(x) / x);
}

/*
 *--------------------------------------------------------------
 *
 * BesselFilter --
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
static double
BesselFilter(x)
    double x;
{
#ifdef NEED_DECL_J1
    double j1 _ANSI_ARGS_((double value));
#endif
    /*
     * See Pratt "Digital Image Processing" p. 97 for Bessel functions
     * zeros are at approx x=1.2197, 2.2331, 3.2383, 4.2411, 5.2428, 6.2439,
     * 7.2448, 8.2454
     */
#ifdef __BORLANDC__
    return 0.0;
#else
    return (x == 0.0) ? M_PI / 4.0 : j1(M_PI * x) / (x + x);
#endif
}

#define SQRT_2PI	0.79788456080286541	/* sqrt(2.0 / M_PI) */

/*
 *--------------------------------------------------------------
 *
 * GaussianFilter --
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
static double
GaussianFilter(x)
    double x;
{
    return exp(-2.0 * x * x) * SQRT_2PI;
}

/*
 *--------------------------------------------------------------
 *
 * Lanczos3Filter --
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
static double
Lanczos3Filter(x)
    double x;
{
    if (x < 0) {
        x = -x;
    }
    if (x < 3.0) {
        return (SincFilter(x) * SincFilter(x / 3.0));
    }
    return 0.0;
}

#define	B		0.3333333333333333	/* (1.0 / 3.0) */
#define	C		0.3333333333333333	/* (1.0 / 3.0) */

/*
 *--------------------------------------------------------------
 *
 * MitchellFilter --
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
static double
MitchellFilter(x)
    double x;
{
    double x2;

    x2 = x * x;
    if (x < 0) {
        x = -x;
    }
    if (x < 1.0) {
        x = (((12.0 - 9.0 * B - 6.0 * C) * (x * x2)) +
             ((-18.0 + 12.0 * B + 6.0 * C) * x2) + (6.0 - 2 * B));
        return (x / 6.0);
    } else if (x < 2.0) {
        x = (((-1.0 * B - 6.0 * C) * (x * x2)) + ((6.0 * B + 30.0 * C) * x2) +
             ((-12.0 * B - 48.0 * C) * x) + (8.0 * B + 24 * C));
        return (x / 6.0);
    }
    return 0.0;
}

/*
 *--------------------------------------------------------------
 *
 * CatRomFilter --
 *
 *      Catmull-Rom spline
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static double
CatRomFilter(x)
    double x;
{
    if (x < -2.) {
        return 0.0;
    }
    if (x < -1.0) {
        return 0.5 * (4.0 + x * (8.0 + x * (5.0 + x)));
    }
    if (x < 0.0) {
        return 0.5 * (2.0 + x * x * (-5.0 + x * -3.0));
    }
    if (x < 1.0) {
        return 0.5 * (2.0 + x * x * (-5.0 + x * 3.0));
    }
    if (x < 2.0) {
        return 0.5 * (4.0 + x * (-8.0 + x * (5.0 - x)));
    }
    return 0.0;
}

/*
 *--------------------------------------------------------------
 *
 * GiFilter --
 *
 *      Approximation to the gaussian integral [x, inf)
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static double
GiFilter(x)
    double x;
{
    if (x > 1.5) {
        return 0.0;
    } else if (x < -1.5) {
        return 1.0;
    } else {
#define I6 0.166666666666667
#define I4 0.25
#define I3 0.333333333333333
        double x2 = x * x;
        double x3 = x2 * x;

        if (x > 0.5) {
            return .5625  - ( x3 * I6 - 3 * x2 * I4 + 1.125 * x);
        } else if (x > -0.5) {
            return 0.5    - (0.75 * x - x3 * I3);
        } else {
            return 0.4375 + (-x3 * I6 - 3 * x2 * I4 - 1.125 * x);
        }
    }
}



static ResampleFilter filterTable[] = {
    /* name,     function,		support */
    {"bell",     BellFilter,		1.5	 },
    {"bessel",   BesselFilter,		3.2383   },
    {"box",      BoxFilter,		0.5      },
    {"bspline",  BSplineFilter,		2.0	 },
    {"catrom",   CatRomFilter,		2.0	 },
    {"default",  DefaultFilter,		1.0	 },
    {"dummy",    DummyFilter,		0.5	 },
    {"gauss8",   GaussianFilter,	8.0	 },
    {"gaussian", GaussianFilter,	1.25	 },
    {"gi",	 GiFilter,		1.25	 },
    {"lanczos3", Lanczos3Filter,	3.0	 },
    {"mitchell", MitchellFilter,	2.0	 },
    {"none",     (ResampleFilterProc *)NULL,	0.0	 },
    {"sinc",     SincFilter,		4.0	 },
    {"triangle", TriangleFilter,	1.0	 },
};

static int nFilters = sizeof(filterTable) / sizeof(ResampleFilter);

ResampleFilter *rbcBoxFilterPtr = &(filterTable[1]);


/*
 *----------------------------------------------------------------------
 *
 * Rbc_GetResampleFilter --
 *
 *      Finds a 1-D filter associated by the given filter name.
 *
 * Results:
 *      A standard Tcl result.  Returns TCL_OK is the filter was
 *      found.  The filter information (proc and support) is returned
 *      via filterPtrPtr. Otherwise TCL_ERROR is returned and an error
 *      message is left in interp->result.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
int
Rbc_GetResampleFilter(interp, name, filterPtrPtr)
    Tcl_Interp *interp;
    char *name;
    ResampleFilter **filterPtrPtr;
{
    ResampleFilter *filterPtr, *endPtr;

    endPtr = filterTable + nFilters;
    for (filterPtr = filterTable; filterPtr < endPtr; filterPtr++) {
        if (strcmp(name, filterPtr->name) == 0) {
            *filterPtrPtr = (filterPtr->proc == NULL) ? NULL : filterPtr;
            return TCL_OK;
        }
    }
    Tcl_AppendResult(interp, "can't find filter \"", name, "\"", (char *)NULL);
    return TCL_ERROR;
}


/*
 * Scaled integers are fixed point values.  The upper 18 bits is the integer
 * portion, the lower 14 bits the fractional remainder.  Must be careful
 * not to overflow the values (especially during multiplication).
 *
 * The following operations are defined:
 *
 *	S * n		Scaled integer times an integer.
 *	S1 + S2		Scaled integer plus another scaled integer.
 *
 */

#define float2si(f)	(int)((f) * 16384.0 + 0.5)
#define uchar2si(b)	(((int)(b)) << 14)
#define si2int(s)	(((s) + 8192) >> 14)

#ifdef notdef
typedef struct {
    int pixel;
    union Weight {
        int i;			/* Fixed point, scaled integer. */
        float f;
    } weight;
} Sample;

typedef struct {
    int count;			/* Number of contributors */
    Sample *samples;		/* Array of contributors */
} Contribution;

typedef struct {
    int pixel;
    union Weight {
        int i;			/* Fixed point, scaled integer. */
        float f;
    } weight;
} Sample;
#endif


typedef union {
    int i;			/* Fixed point, scaled integer. */
    float f;
} Weight;

typedef struct {
    int count;			/* Number of samples. */
    int start;
    Weight weights[1];		/* Array of weights. */
} Sample;

/*
 *--------------------------------------------------------------
 *
 * ComputeWeights --
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
static size_t
ComputeWeights(srcWidth, destWidth, filterPtr, samplePtrPtr)
    int srcWidth, destWidth;
    ResampleFilter *filterPtr;
    Sample **samplePtrPtr;
{
    Sample *samples;
    double scale;
    int filterSize;
    double center;
    register Sample *s;
    register Weight *weight;
    register int x, i;
    register int left, right;	/* filter bounds */
    double factor, sum;
    size_t size;

    /* Pre-calculate filter contributions for a row */
    scale = (double)destWidth / (double)srcWidth;

    if (scale < 1.0) {
        double radius, fscale;

        /* Downsample */

        radius = filterPtr->support / scale;
        fscale = 1.0 / scale;
        filterSize = (int)(radius * 2 + 2);

        size = sizeof(Sample) + (filterSize - 1) * sizeof(Weight);
        samples = RbcCalloc(destWidth, size);
        assert(samples);

        s = samples;
        for (x = 0; x < destWidth; x++) {
            center = (double)x * fscale;

            /* Determine bounds of filter and its density */
            left = (int)(center - radius + 0.5);
            if (left < 0) {
                left = 0;
            }
            right = (int)(center + radius + 0.5);
            if (right >= srcWidth) {
                right = srcWidth - 1;
            }
            sum = 0.0;
            s->start = left;
            for (weight = s->weights, i = left; i <= right; i++, weight++) {
                weight->f = (float)
                            (*filterPtr->proc) (((double)i + 0.5 - center) * scale);
                sum += weight->f;
            }
            s->count = right - left + 1;

            factor = (sum == 0.0) ? 1.0 : (1.0 / sum);
            for (weight = s->weights, i = left; i <= right; i++, weight++) {
                weight->f = (float)(weight->f * factor);
                weight->i = float2si(weight->f);
            }
            s = (Sample *)((char *)s + size);
        }
    } else {
        double fscale;
        /* Upsample */

        filterSize = (int)(filterPtr->support * 2 + 2);
        size = sizeof(Sample) + (filterSize - 1) * sizeof(Weight);
        samples = RbcCalloc(destWidth, size);
        assert(samples);

        fscale = 1.0 / scale;

        s = samples;
        for (x = 0; x < destWidth; x++) {
            center = (double)x * fscale;
            left = (int)(center - filterPtr->support + 0.5);
            if (left < 0) {
                left = 0;
            }
            right = (int)(center + filterPtr->support + 0.5);
            if (right >= srcWidth) {
                right = srcWidth - 1;
            }
            sum = 0.0;
            s->start = left;
            for (weight = s->weights, i = left; i <= right; i++, weight++) {
                weight->f = (float)
                            (*filterPtr->proc) ((double)i - center + 0.5);
                sum += weight->f;
            }
            s->count = right - left + 1;
            factor = (sum == 0.0) ? 1.0 : (1.0 / sum);
            for (weight = s->weights, i = left; i <= right; i++, weight++) {
                weight->f = (float)(weight->f * factor);
                weight->i = float2si(weight->f);
            }
            s = (Sample *)((char *)s + size);
        }
    }
    *samplePtrPtr = samples;
    return size;
}

/*
 * The following macro converts a fixed-point scaled integer to a
 * byte, clamping the value between 0 and 255.
 */
#define SICLAMP(s) \
    (unsigned char)(((s) < 0) ? 0 : ((s) > 4177920) ? 255 : (si2int(s)))

/*
 *--------------------------------------------------------------
 *
 * ZoomImageVertically --
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
ZoomImageVertically(src, dest, filterPtr)
    Rbc_ColorImage src, dest;
    ResampleFilter *filterPtr;
{
    Sample *samples, *s, *endPtr;
    int destWidth, destHeight;
    int red, green, blue, alpha;
    int srcWidth, srcHeight;
    register Pix32 *srcColumnPtr;
    register Pix32 *srcPtr, *destPtr;
    register Weight *weight;
    int x, i;
    size_t size;		/* Size of sample. */

    srcWidth = Rbc_ColorImageWidth(src);
    srcHeight = Rbc_ColorImageHeight(src);
    destWidth = Rbc_ColorImageWidth(dest);
    destHeight = Rbc_ColorImageHeight(dest);

    /* Pre-calculate filter contributions for a row */
    size = ComputeWeights(srcHeight, destHeight, filterPtr, &samples);
    endPtr = (Sample *)((char *)samples + (destHeight * size));

    /* Apply filter to zoom vertically from tmp to destination */
    for (x = 0; x < srcWidth; x++) {
        srcColumnPtr = Rbc_ColorImageBits(src) + x;
        destPtr = Rbc_ColorImageBits(dest) + x;
        for (s = samples; s < endPtr; s = (Sample *)((char *)s + size)) {
            red = green = blue = alpha = 0;
            srcPtr = srcColumnPtr + (s->start * srcWidth);
            for (weight = s->weights, i = 0; i < s->count; i++, weight++) {
                red += srcPtr->Red * weight->i;
                green += srcPtr->Green * weight->i;
                blue += srcPtr->Blue * weight->i;
                alpha += srcPtr->Alpha * weight->i;
                srcPtr += srcWidth;
            }
            destPtr->Red = SICLAMP(red);
            destPtr->Green = SICLAMP(green);
            destPtr->Blue = SICLAMP(blue);
            destPtr->Alpha = SICLAMP(alpha);
            destPtr += destWidth;

        }
    }
    /* Free the memory allocated for filter weights */
    ckfree((char *)samples);
}

/*
 *--------------------------------------------------------------
 *
 * ZoomImageHorizontally --
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
ZoomImageHorizontally(src, dest, filterPtr)
    Rbc_ColorImage src, dest;
    ResampleFilter *filterPtr;
{
    Sample *samples, *s, *endPtr;
    Weight *weight;
    int destWidth;
    int red, green, blue, alpha;
    int srcWidth, srcHeight;
    int y, i;
    register Pix32 *srcPtr, *destPtr;
    register Pix32 *srcRowPtr;
    size_t size;		/* Size of sample. */

    srcWidth = Rbc_ColorImageWidth(src);
    srcHeight = Rbc_ColorImageHeight(src);
    destWidth = Rbc_ColorImageWidth(dest);

    /* Pre-calculate filter contributions for a row */
    size = ComputeWeights(srcWidth, destWidth, filterPtr, &samples);
    endPtr = (Sample *)((char *)samples + (destWidth * size));

    /* Apply filter to zoom horizontally from srcPtr to tmpPixels */
    srcRowPtr = Rbc_ColorImageBits(src);
    destPtr = Rbc_ColorImageBits(dest);
    for (y = 0; y < srcHeight; y++) {
        for (s = samples; s < endPtr; s = (Sample *)((char *)s + size)) {
            red = green = blue = alpha = 0;
            srcPtr = srcRowPtr + s->start;
            for (weight = s->weights, i = 0; i < s->count; i++, weight++) {
                red += srcPtr->Red * weight->i;
                green += srcPtr->Green * weight->i;
                blue += srcPtr->Blue * weight->i;
                alpha += srcPtr->Alpha * weight->i;
                srcPtr++;
            }
            destPtr->Red = SICLAMP(red);
            destPtr->Green = SICLAMP(green);
            destPtr->Blue = SICLAMP(blue);
            destPtr->Alpha = SICLAMP(alpha);
            destPtr++;
        }
        srcRowPtr += srcWidth;
    }
    /* free the memory allocated for horizontal filter weights */
    ckfree((char *)samples);
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ResampleColorImage --
 *
 *      Resamples a given color image using 1-D filters and returns
 *      a new color image of the designated size.
 *
 * Results:
 *      Returns the resampled color image. The original color image
 *      is left intact.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
Rbc_ColorImage
Rbc_ResampleColorImage(src, width, height, horzFilterPtr, vertFilterPtr)
    Rbc_ColorImage src;
    int width, height;
    ResampleFilter *horzFilterPtr, *vertFilterPtr;
{
    Rbc_ColorImage tmp, dest;

    /*
     * It's usually faster to zoom vertically last.  This has to do
     * with the fact that images are stored in contiguous rows.
     */

    tmp = Rbc_CreateColorImage(width, Rbc_ColorImageHeight(src));
    ZoomImageHorizontally(src, tmp, horzFilterPtr);
    dest = Rbc_CreateColorImage(width, height);
    ZoomImageVertically(tmp, dest, vertFilterPtr);
    Rbc_FreeColorImage(tmp);
    return dest;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ResamplePhoto --
 *
 *      Resamples a Tk photo image using 1-D filters and writes the
 *      image into another Tk photo.  It is possible for the
 *      source and destination to be the same photo.
 *
 * Results:
 *      The designated destination photo will contain the resampled
 *      color image. The original photo is left intact.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_ResamplePhoto(interp, srcPhoto, x, y, width, height, destPhoto, horzFilterPtr, vertFilterPtr)
    Tcl_Interp *interp;
    Tk_PhotoHandle srcPhoto; /* Source photo image to scale */
    int x, y;
    int width, height;
    Tk_PhotoHandle destPhoto; /* Resulting scaled photo image */
    ResampleFilter *horzFilterPtr, *vertFilterPtr;
{
    Rbc_ColorImage srcImage, destImage;
    Tk_PhotoImageBlock dest;

    Tk_PhotoGetImage(destPhoto, &dest);
    srcImage = Rbc_PhotoRegionToColorImage(srcPhoto, x, y, width, height);
    destImage = Rbc_ResampleColorImage(srcImage, dest.width, dest.height,
                                       horzFilterPtr, vertFilterPtr);
    Rbc_FreeColorImage(srcImage);
    Rbc_ColorImageToPhoto(interp, destImage, destPhoto);
    Rbc_FreeColorImage(destImage);
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ResizePhoto --
 *
 *      Scales the region of the source image to the size of the
 *      destination image.  This routine performs raw scaling of
 *      the image and unlike Rbc_ResamplePhoto does not handle
 *      aliasing effects from subpixel sampling. It is possible
 *      for the source and destination to be the same photo.
 *
 * Results:
 *      The designated destination photo will contain the resampled
 *      color image. The original photo is left intact.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_ResizePhoto(interp, srcPhoto, x, y, width, height, destPhoto)
    Tcl_Interp *interp;
    Tk_PhotoHandle srcPhoto; /* Source photo image to scaled. */
    register int x, y; /* Region of source photo to be
                        * scaled. */
    int width, height;
    Tk_PhotoHandle destPhoto; /* (out) Resulting scaled photo image.
                               * Scaling factors are derived from
                               * the destination photo's
                               * dimensions. */
{
    double xScale, yScale;
    Rbc_ColorImage destImage;
    Pix32 *destPtr;
    Tk_PhotoImageBlock src, dest;
    unsigned char *srcPtr, *srcRowPtr;
    int *mapX, *mapY;
    register int sx, sy;
    int left, right, top, bottom;

    Tk_PhotoGetImage(srcPhoto, &src);
    Tk_PhotoGetImage(destPhoto, &dest);

    left = x, top = y, right = x + width - 1, bottom = y + height - 1;
    destImage = Rbc_CreateColorImage(dest.width, dest.height);
    xScale = (double)width / (double)dest.width;
    yScale = (double)height / (double)dest.height;
    mapX = (int *)ckalloc(sizeof(int) * dest.width);
    mapY = (int *)ckalloc(sizeof(int) * dest.height);
    for (x = 0; x < dest.width; x++) {
        sx = (int)(xScale * (double)(x + left));
        if (sx > right) {
            sx = right;
        }
        mapX[x] = sx;
    }
    for (y = 0; y < dest.height; y++) {
        sy = (int)(yScale * (double)(y + top));
        if (sy > bottom) {
            sy = bottom;
        }
        mapY[y] = sy;
    }
    destPtr = Rbc_ColorImageBits(destImage);
    if (src.pixelSize == 4) {
        for (y = 0; y < dest.height; y++) {
            srcRowPtr = src.pixelPtr + (mapY[y] * src.pitch);
            for (x = 0; x < dest.width; x++) {
                srcPtr = srcRowPtr + (mapX[x] * src.pixelSize);
                destPtr->Red = srcPtr[src.offset[0]];
                destPtr->Green = srcPtr[src.offset[1]];
                destPtr->Blue = srcPtr[src.offset[2]];
                destPtr->Alpha = srcPtr[src.offset[3]];
                destPtr++;
            }
        }
    } else if (src.pixelSize == 3) {
        for (y = 0; y < dest.height; y++) {
            srcRowPtr = src.pixelPtr + (mapY[y] * src.pitch);
            for (x = 0; x < dest.width; x++) {
                srcPtr = srcRowPtr + (mapX[x] * src.pixelSize);
                destPtr->Red = srcPtr[src.offset[0]];
                destPtr->Green = srcPtr[src.offset[1]];
                destPtr->Blue = srcPtr[src.offset[2]];
                destPtr->Alpha = (unsigned char)-1;
                destPtr++;
            }
        }
    } else  {
        for (y = 0; y < dest.height; y++) {
            srcRowPtr = src.pixelPtr + (mapY[y] * src.pitch);
            for (x = 0; x < dest.width; x++) {
                srcPtr = srcRowPtr + (mapX[x] * src.pixelSize);
                destPtr->Red = destPtr->Green = destPtr->Blue =
                                                    srcPtr[src.offset[0]];
                destPtr->Alpha = (unsigned char)-1;
                destPtr++;
            }
        }
    }
    ckfree((char *)mapX);
    ckfree((char *)mapY);
    Rbc_ColorImageToPhoto(interp, destImage, destPhoto);
    Rbc_FreeColorImage(destImage);
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ResizeColorImage --
 *
 *      Scales the region of the source image to the size of the
 *      destination image.  This routine performs raw scaling of
 *      the image and unlike Rbc_ResamplePhoto does not perform
 *      any antialiasing.
 *
 * Results:
 *      Returns the new resized color image.  The original image
 *      is left intact.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
Rbc_ColorImage
Rbc_ResizeColorImage(src, x, y, width, height, destWidth, destHeight)
    Rbc_ColorImage src; /* Source color image to be scaled. */
    register int x, y; /* Region of source image to scaled. */
    int width, height;
    int destWidth, destHeight; /* Requested dimensions of the scaled
                                * image. */
{
    register int sx, sy;
    double xScale, yScale;
    Rbc_ColorImage dest;
    Pix32 *srcPtr, *srcRowPtr, *destPtr;
    int *mapX, *mapY;
    int left, right, top, bottom;

    left = x, top = y;
    right = x + width - 1, bottom = y + height - 1;

    dest = Rbc_CreateColorImage(destWidth, destHeight);
    xScale = (double)width / (double)destWidth;
    yScale = (double)height / (double)destHeight;
    mapX = (int *)ckalloc(sizeof(int) * destWidth);
    mapY = (int *)ckalloc(sizeof(int) * destHeight);
    for (x = 0; x < destWidth; x++) {
        sx = (int)(xScale * (double)(x + left));
        if (sx > right) {
            sx = right;
        }
        mapX[x] = sx;
    }
    for (y = 0; y < destHeight; y++) {
        sy = (int)(yScale * (double)(y + top));
        if (sy > bottom) {
            sy = bottom;
        }
        mapY[y] = sy;
    }
    destPtr = Rbc_ColorImageBits(dest);
    for (y = 0; y < destHeight; y++) {
        srcRowPtr = Rbc_ColorImageBits(src) +
                    (Rbc_ColorImageWidth(src) * mapY[y]);
        for (x = 0; x < destWidth; x++) {
            srcPtr = srcRowPtr + mapX[x];
            destPtr->value = srcPtr->value; /* Copy the pixel. */
            destPtr++;
        }
    }
    ckfree((char *)mapX);
    ckfree((char *)mapY);
    return dest;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ResizeColorSubimage --
 *
 *      Scales the region of the source image to the size of the
 *      destination image.  This routine performs raw scaling of
 *      the image and unlike Rbc_ResamplePhoto does not perform
 *      any antialiasing.
 *
 * Results:
 *      Returns the new resized color image.  The original image
 *      is left intact.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
Rbc_ColorImage
Rbc_ResizeColorSubimage(src, regionX, regionY, regionWidth,
		regionHeight, destWidth, destHeight)
    Rbc_ColorImage src; /* Source color image to be scaled. */
    int regionX;
    int regionY; /* Offset of subimage in destination. */
    int regionWidth, regionHeight;  /* Dimension of subimage. */
    int destWidth, destHeight; /* Dimensions of the entire scaled
                                * image. */
{
    Rbc_ColorImage dest;
    Pix32 *srcPtr, *srcRowPtr, *destPtr;
    double xScale, yScale;
    int *mapX, *mapY;
    int srcWidth, srcHeight;
    register int sx, sy;
    register int x, y;

    srcWidth = Rbc_ColorImageWidth(src);
    srcHeight = Rbc_ColorImageHeight(src);

    xScale = (double)srcWidth / (double)destWidth;
    yScale = (double)srcHeight / (double)destHeight;
    mapX = (int *)ckalloc(sizeof(int) * regionWidth);
    mapY = (int *)ckalloc(sizeof(int) * regionHeight);

    /* Precompute scaling factors for each row and column. */
    for (x = 0; x < regionWidth; x++) {
        sx = (int)(xScale * (double)(x + regionX));
        if (sx >= srcWidth) {
            sx = srcWidth - 1;
        }
        mapX[x] = sx;
    }
    for (y = 0; y < regionHeight; y++) {
        sy = (int)(yScale * (double)(y + regionY));
        if (sy > srcHeight) {
            sy = srcHeight - 1;
        }
        mapY[y] = sy;
    }

    dest = Rbc_CreateColorImage(regionWidth, regionHeight);
    destPtr = Rbc_ColorImageBits(dest);
    for (y = 0; y < regionHeight; y++) {
        srcRowPtr = Rbc_ColorImageBits(src) +
                    (Rbc_ColorImageWidth(src) * mapY[y]);
        for (x = 0; x < regionWidth; x++) {
            srcPtr = srcRowPtr + mapX[x];
            destPtr->value = srcPtr->value; /* Copy the pixel. */
            destPtr++;
        }
    }
    ckfree((char *)mapX);
    ckfree((char *)mapY);
    return dest;
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_ConvolveColorImage --
 *
 *      FIXME: Boundary handling could be better (pixels
 *             are replicated). It's slow. Take boundary
 *             tests out of inner loop.
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
Rbc_ColorImage
Rbc_ConvolveColorImage(src, filterPtr)
    Rbc_ColorImage src;
    Filter2D *filterPtr;
{
    Rbc_ColorImage dest;
    register Pix32 *srcPtr, *destPtr;
#define MAXROWS	24
    register int sx, sy, dx, dy;
    register int x, y;
    double red, green, blue;
    int width, height;
    int radius;
    register double *valuePtr;

    width = Rbc_ColorImageWidth(src);
    height = Rbc_ColorImageHeight(src);

    dest = Rbc_CreateColorImage(width, height);
    radius = (int)filterPtr->support;
    if (radius < 1) {
        radius = 1;
    }
    destPtr = Rbc_ColorImageBits(dest);
    for (dy = 0; dy < height; dy++) {
        for (dx = 0; dx < width; dx++) {
            red = green = blue = 0.0;
            valuePtr = filterPtr->kernel;
            for (sy = (dy - radius); sy <= (dy + radius); sy++) {
                y = sy;
                if (y < 0) {
                    y = 0;
                } else if (y >= height) {
                    y = height - 1;
                }
                for (sx = (dx - radius); sx <= (dx + radius); sx++) {
                    x = sx;
                    if (x < 0) {
                        x = 0;
                    } else if (sx >= width) {
                        x = width - 1;
                    }
                    srcPtr = Rbc_ColorImagePixel(src, x, y);
                    red += *valuePtr * (double)srcPtr->Red;
                    green += *valuePtr * (double)srcPtr->Green;
                    blue += *valuePtr * (double)srcPtr->Blue;
#ifdef notdef
                    fprintf(stderr, "%d,%d = r=%f,g=%f,b=%f\n", x, y,
                            red, green, blue);
#endif
                    valuePtr++;
                }
            }
            red /= filterPtr->sum;
            green /= filterPtr->sum;
            blue /= filterPtr->sum;
            destPtr->Red = (unsigned char)CLAMP(red);
            destPtr->Green = (unsigned char)CLAMP(green);
            destPtr->Blue = (unsigned char)CLAMP(blue);
            destPtr->Alpha = (unsigned char)-1;
            destPtr++;
        }
    }
    return dest;
}


/*
 *----------------------------------------------------------------------
 *
 * Rbc_SnapPhoto --
 *
 *      Takes a snapshot of an X drawable (pixmap or window) and
 *      writes it to an existing Tk photo image.
 *
 * Results:
 *      A standard Tcl result.
 *
 * Side Effects:
 *      The named Tk photo is updated with the snapshot.
 *
 *----------------------------------------------------------------------
 */
int
Rbc_SnapPhoto(interp, tkwin, drawable, x, y, width, height, destWidth,
              destHeight, photoName, inputGamma)
    Tcl_Interp *interp; /* Interpreter to report errors back to */
    Tk_Window tkwin;
    Drawable drawable; /* Window or pixmap to be snapped */
    int x, y; /* Offset of image from drawable origin. */
    int width, height; /* Dimension of the drawable */
    int destWidth, destHeight; /* Desired size of the Tk photo */
    char *photoName; /* Name of an existing Tk photo image. */
    double inputGamma;
{
    Tk_PhotoHandle photo;	/* The photo image to write into. */
    Rbc_ColorImage image;

    photo = Rbc_FindPhoto(interp, photoName);
    if (photo == NULL) {
        Tcl_AppendResult(interp, "can't find photo \"", photoName, "\"",
                         (char *)NULL);
        return TCL_ERROR;
    }
    image = Rbc_DrawableToColorImage(tkwin, drawable, x, y, width, height, inputGamma);
    if (image == NULL) {
        Tcl_AppendResult(interp,
                         "can't grab window or pixmap (possibly obscured?)", (char *)NULL);
        return TCL_ERROR;	/* Can't grab window image */
    }
    if ((destWidth != width) || (destHeight != height)) {
        Rbc_ColorImage destImage;

        /*
         * The requested size for the destination image is different than
         * that of the source snapshot.  Resample the image as necessary.
         * We'll use a cheap box filter. I'm assuming that the destination
         * image will typically be smaller than the original.
         */
        destImage = Rbc_ResampleColorImage(image, destWidth, destHeight,
                                           rbcBoxFilterPtr, rbcBoxFilterPtr);
        Rbc_FreeColorImage(image);
        image = destImage;
    }
    Rbc_ColorImageToPhoto(interp, image, photo);
    Rbc_FreeColorImage(image);
    return TCL_OK;
}

#if HAVE_JPEG
/*
 *----------------------------------------------------------------------
 *
 * Rbc_JPEGToPhoto --
 *
 *      Reads a JPEG file and converts it into a Tk photo.
 *
 * Results:
 *      A standard Tcl result.  If successful, TCL_OK is returned
 *      and the designated photo is re-written with the image.
 *      Otherwise, TCL_ERROR is returned and interp->result will
 *      contain an error message.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
int
Rbc_JPEGToPhoto(interp, fileName, photo)
    Tcl_Interp *interp;
    char *fileName;
    Tk_PhotoHandle photo; /* The photo image to write into. */
{
    Rbc_ColorImage image;

    image = Rbc_JPEGToColorImage(interp, fileName);
    if (image == NULL) {
        return TCL_ERROR;
    }
    Rbc_ColorImageToPhoto(image, photo);
    Rbc_FreeColorImage(image);
    return TCL_OK;
}
#endif /* HAVE_JPEG */

/*
 * --------------------------------------------------------------------------
 *
 * ShearY --
 *
 *      Shears a row horizontally. Antialiasing limited to filtering
 *      two adjacent pixels.  So the shear angle must be between +-45
 *      degrees.
 *
 * Results:
 *      None.
 *
 * Side Effects:
 *      The sheared image is drawn into the destination color image.
 *
 * --------------------------------------------------------------------------
 */
static void
ShearY(src, dest, y, offset, frac, bgColor)
    Rbc_ColorImage src, dest;
    int y; /* Designates the row to be sheared */
    int offset; /* Difference between  of  */
    double frac;
    Pix32 bgColor;
{
    Pix32 *srcPtr, *destPtr;
    Pix32 *srcRowPtr, *destRowPtr;
    register int x, dx;
    int destWidth;
    int srcWidth;
    int red, blue, green, alpha;
    int leftRed, leftGreen, leftBlue, leftAlpha;
    int oldLeftRed, oldLeftGreen, oldLeftBlue, oldLeftAlpha;
    int ifrac;

    srcWidth = Rbc_ColorImageWidth(src);
    destWidth = Rbc_ColorImageWidth(dest);

    destRowPtr = Rbc_ColorImageBits(dest) + (y * destWidth);
    srcRowPtr = Rbc_ColorImageBits(src) + (y * srcWidth);

    destPtr = destRowPtr;
    for (x = 0; x < offset; x++) {
        *destPtr++ = bgColor;
    }
    destPtr = destRowPtr + offset;
    srcPtr = srcRowPtr;
    dx = offset;

    oldLeftRed = uchar2si(bgColor.Red);
    oldLeftGreen = uchar2si(bgColor.Green);
    oldLeftBlue = uchar2si(bgColor.Blue);
    oldLeftAlpha = uchar2si(bgColor.Alpha);

    ifrac = float2si(frac);
    for (x = 0; x < srcWidth; x++, dx++) { /* Loop through row pixels */
        leftRed = srcPtr->Red * ifrac;
        leftGreen = srcPtr->Green * ifrac;
        leftBlue = srcPtr->Blue * ifrac;
        leftAlpha = srcPtr->Alpha * ifrac;
        if ((dx >= 0) && (dx < destWidth)) {
            red = uchar2si(srcPtr->Red) - (leftRed - oldLeftRed);
            green = uchar2si(srcPtr->Green) - (leftGreen - oldLeftGreen);
            blue = uchar2si(srcPtr->Blue) - (leftBlue - oldLeftBlue);
            alpha = uchar2si(srcPtr->Alpha) - (leftAlpha - oldLeftAlpha);
            destPtr->Red = SICLAMP(red);
            destPtr->Green = SICLAMP(green);
            destPtr->Blue = SICLAMP(blue);
            destPtr->Alpha = SICLAMP(alpha);
        }
        oldLeftRed = leftRed;
        oldLeftGreen = leftGreen;
        oldLeftBlue = leftBlue;
        oldLeftAlpha = leftAlpha;
        srcPtr++, destPtr++;
    }
    x = srcWidth + offset;
    destPtr = Rbc_ColorImageBits(dest) + (y * destWidth) + x;
    if (x < destWidth) {
        leftRed = uchar2si(bgColor.Red);
        leftGreen = uchar2si(bgColor.Green);
        leftBlue = uchar2si(bgColor.Blue);
        leftAlpha = uchar2si(bgColor.Alpha);

        red = leftRed + oldLeftRed - (bgColor.Red * ifrac);
        green = leftGreen + oldLeftGreen - (bgColor.Green * ifrac);
        blue = leftBlue + oldLeftBlue - (bgColor.Blue * ifrac);
        alpha = leftAlpha + oldLeftAlpha - (bgColor.Alpha * ifrac);
        destPtr->Red = SICLAMP(red);
        destPtr->Green = SICLAMP(green);
        destPtr->Blue = SICLAMP(blue);
        destPtr->Alpha = SICLAMP(alpha);
        destPtr++;
    }
    for (x++; x < destWidth; x++) {
        *destPtr++ = bgColor;
    }
}

/*
 * --------------------------------------------------------------------------
 *
 * ShearX --
 *
 *      Shears a column. Antialiasing is limited to filtering two
 *      adjacent pixels.  So the shear angle must be between +-45
 *      degrees.
 *
 * Results:
 *      None.
 *
 * Side Effects:
 *      The sheared image is drawn into the destination color image.
 *
 * --------------------------------------------------------------------------
 */
static void
ShearX(src, dest, x, offset, frac, bgColor)
    Rbc_ColorImage src, dest;
    int x; /* Column in source image to be sheared. */
    int offset; /* Offset of */
    double frac; /* Fraction of subpixel. */
    Pix32 bgColor;
{
    Pix32 *srcPtr, *destPtr;
    register int y, dy;
#ifdef notef
    int srcWidth;
    int destWidth;
#endif
    int destHeight;
    int srcHeight;
    int red, blue, green, alpha;
    int leftRed, leftGreen, leftBlue, leftAlpha;
    int oldLeftRed, oldLeftGreen, oldLeftBlue, oldLeftAlpha;
    int ifrac;

#ifdef notdef
    srcWidth = Rbc_ColorImageWidth(src);
    destWidth = Rbc_ColorImageWidth(dest);
#endif
    srcHeight = Rbc_ColorImageHeight(src);
    destHeight = Rbc_ColorImageHeight(dest);
#ifdef notdef
    destPtr = Rbc_ColorImageBits(dest) + x;
#endif
    for (y = 0; y < offset; y++) {
        destPtr = Rbc_ColorImagePixel(dest, x, y);
        *destPtr = bgColor;
#ifdef notdef
        destPtr += destWidth;
#endif
    }

    oldLeftRed = uchar2si(bgColor.Red);
    oldLeftGreen = uchar2si(bgColor.Green);
    oldLeftBlue = uchar2si(bgColor.Blue);
    oldLeftAlpha = uchar2si(bgColor.Alpha);
#ifdef notdef
    destPtr = Rbc_ColorImageBits(dest) + x + offset;
    srcPtr = Rbc_ColorImageBits(src) + x;
#endif
    dy = offset;
    ifrac = float2si(frac);
    for (y = 0; y < srcHeight; y++, dy++) {
        srcPtr = Rbc_ColorImagePixel(src, x, y);
        leftRed = srcPtr->Red * ifrac;
        leftGreen = srcPtr->Green * ifrac;
        leftBlue = srcPtr->Blue * ifrac;
        leftAlpha = srcPtr->Alpha * ifrac;
        if ((dy >= 0) && (dy < destHeight)) {
            destPtr = Rbc_ColorImagePixel(dest, x, dy);
            red = uchar2si(srcPtr->Red) - (leftRed - oldLeftRed);
            green = uchar2si(srcPtr->Green) - (leftGreen - oldLeftGreen);
            blue = uchar2si(srcPtr->Blue) - (leftBlue - oldLeftBlue);
            alpha = uchar2si(srcPtr->Alpha) - (leftAlpha - oldLeftAlpha);
            destPtr->Red = SICLAMP(red);
            destPtr->Green = SICLAMP(green);
            destPtr->Blue = SICLAMP(blue);
            destPtr->Alpha = SICLAMP(alpha);
        }
        oldLeftRed = leftRed;
        oldLeftGreen = leftGreen;
        oldLeftBlue = leftBlue;
        oldLeftAlpha = leftAlpha;
#ifdef notdef
        srcPtr += srcWidth;
        destPtr += destWidth;
#endif
    }
    y = srcHeight + offset;
#ifdef notdef
    destPtr = Rbc_ColorImageBits(dest) + (y * destWidth) + x + offset;
#endif
    if (y < destHeight) {
        leftRed = uchar2si(bgColor.Red);
        leftGreen = uchar2si(bgColor.Green);
        leftBlue = uchar2si(bgColor.Blue);
        leftAlpha = uchar2si(bgColor.Alpha);

        destPtr = Rbc_ColorImagePixel(dest, x, y);
        red = leftRed + oldLeftRed - (bgColor.Red * ifrac);
        green = leftGreen + oldLeftGreen - (bgColor.Green * ifrac);
        blue = leftBlue + oldLeftBlue - (bgColor.Blue  * ifrac);
        alpha = leftAlpha + oldLeftAlpha - (bgColor.Alpha  * ifrac);
        destPtr->Red = SICLAMP(red);
        destPtr->Green = SICLAMP(green);
        destPtr->Blue = SICLAMP(blue);
        destPtr->Alpha = SICLAMP(alpha);
#ifdef notdef
        destPtr += destWidth;
#endif
    }

    for (y++; y < destHeight; y++) {
        destPtr = Rbc_ColorImagePixel(dest, x, y);
        *destPtr = bgColor;
#ifdef notdef
        destPtr += destWidth;
#endif
    }
}

/*
 * ---------------------------------------------------------------------------
 *
 * Rotate45 --
 *
 *      Rotates an image by a given angle.  The angle must be in the
 *      range -45.0 to 45.0 inclusive.  Anti-aliasing filtering is
 *      performed on two adjacent pixels, so the angle can't be so
 *      great as to force a sheared pixel to occupy 3 destination
 *      pixels.  Performs a three shear rotation described below.
 *
 *      Reference: Alan W. Paeth, "A Fast Algorithm for General Raster
 *               Rotation", Graphics Gems, pp 179-195.
 *
 *
 * Results:
 *      Returns a newly allocated rotated image.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 * ---------------------------------------------------------------------------
 */
static Rbc_ColorImage
Rotate45(src, theta, bgColor)
    Rbc_ColorImage src;
    double theta;
    Pix32 bgColor;
{
    int tmpWidth, tmpHeight;
    int srcWidth, srcHeight;
    double sinTheta, cosTheta, tanTheta;
    double  skewf;
    int skewi;
    Rbc_ColorImage tmp1, tmp2, dest;
    register int x, y;

    sinTheta = sin(theta);
    cosTheta = cos(theta);
    tanTheta = tan(theta * 0.5);

    srcWidth = Rbc_ColorImageWidth(src);
    srcHeight = Rbc_ColorImageHeight(src);

    tmpWidth = srcWidth + (int)(srcHeight * FABS(tanTheta));
    tmpHeight = srcHeight;

    /* 1st shear */

    tmp1 = Rbc_CreateColorImage(tmpWidth, tmpHeight);
    assert(tmp1);

    if (tanTheta >= 0.0) {	/* Positive angle */
        for (y = 0; y < tmpHeight; y++) {
            skewf = (y + 0.5) * tanTheta;
            skewi = (int)floor(skewf);
            ShearY(src, tmp1, y, skewi, skewf - skewi, bgColor);
        }
    } else {			/* Negative angle */
        for (y = 0; y < tmpHeight; y++) {
            skewf = ((y - srcHeight) + 0.5) * tanTheta;
            skewi = (int)floor(skewf);
            ShearY(src, tmp1, y, skewi, skewf - skewi, bgColor);
        }
    }
    tmpHeight = (int)(srcWidth * FABS(sinTheta) + srcHeight * cosTheta) + 1;

    tmp2 = Rbc_CreateColorImage(tmpWidth, tmpHeight);
    assert(tmp2);

    /* 2nd shear */

    if (sinTheta > 0.0) {	/* Positive angle */
        skewf = (srcWidth - 1) * sinTheta;
    } else {			/* Negative angle */
        skewf = (srcWidth - tmpWidth) * -sinTheta;
    }
    for (x = 0; x < tmpWidth; x++) {
        skewi = (int)floor(skewf);
        ShearX(tmp1, tmp2, x, skewi, skewf - skewi, bgColor);
        skewf -= sinTheta;
    }

    Rbc_FreeColorImage(tmp1);

    /* 3rd shear */

    tmpWidth = (int)(srcHeight * FABS(sinTheta) + srcWidth * cosTheta) + 1;

    dest = Rbc_CreateColorImage(tmpWidth, tmpHeight);
    assert(dest);

    if (sinTheta >= 0.0) {	/* Positive angle */
        skewf = (srcWidth - 1) * sinTheta * -tanTheta;
    } else {			/* Negative angle */
        skewf = tanTheta * ((srcWidth - 1) * -sinTheta - (tmpHeight - 1));
    }
    for (y = 0; y < tmpHeight; y++) {
        skewi = (int)floor(skewf);
        ShearY(tmp2, dest, y, skewi, skewf - skewi, bgColor);
        skewf += tanTheta;
    }
    Rbc_FreeColorImage(tmp2);
    return dest;
}

/*
 * ---------------------------------------------------------------------------
 *
 * CopyColorImage --
 *
 *      Creates a copy of the given color image.
 *
 * Results:
 *      Returns the new copy.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 * ---------------------------------------------------------------------------
 */
static Rbc_ColorImage
CopyColorImage(src)
    Rbc_ColorImage src;
{
    unsigned int width, height;
    Pix32 *srcPtr, *destPtr;
    Rbc_ColorImage dest;

    width = Rbc_ColorImageWidth(src);
    height = Rbc_ColorImageHeight(src);
    dest = Rbc_CreateColorImage(width, height);
    srcPtr = Rbc_ColorImageBits(src);
    destPtr = Rbc_ColorImageBits(dest);
    memcpy(destPtr, srcPtr, width * height * sizeof(Pix32));
    return dest;
}

/*
 * ---------------------------------------------------------------------------
 *
 * Rotate90 --
 *
 *      Rotates the given color image by 90 degrees.  This is part
 *      of the special case right-angle rotations that do not create
 *      subpixel aliasing.
 *
 * Results:
 *      Returns a newly allocated, rotated color image.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 * ---------------------------------------------------------------------------
 */
static Rbc_ColorImage
Rotate90(src)
    Rbc_ColorImage src;
{
    int width, height, offset;
    Pix32 *srcPtr, *destPtr;
    Rbc_ColorImage dest;
    register int x, y;

    height = Rbc_ColorImageWidth(src);
    width = Rbc_ColorImageHeight(src);

    srcPtr = Rbc_ColorImageBits(src);
    dest = Rbc_CreateColorImage(width, height);
    offset = (height - 1) * width;

    for (x = 0; x < width; x++) {
        destPtr = Rbc_ColorImageBits(dest) + offset + x;
        for (y = 0; y < height; y++) {
            *destPtr = *srcPtr++;
            destPtr -= width;
        }
    }
    return dest;
}

/*
 * ---------------------------------------------------------------------------
 *
 * Rotate180 --
 *
 *      Rotates the given color image by 180 degrees.  This is one of
 *      the special case orthogonal rotations that do not create
 *      subpixel aliasing.
 *
 * Results:
 *      Returns a newly allocated, rotated color image.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 * ---------------------------------------------------------------------------
 */
static Rbc_ColorImage
Rotate180(src)
    Rbc_ColorImage src;
{
    int width, height, offset;
    Pix32 *srcPtr, *destPtr;
    Rbc_ColorImage dest;
    register int x, y;

    width = Rbc_ColorImageWidth(src);
    height = Rbc_ColorImageHeight(src);
    dest = Rbc_CreateColorImage(width, height);

    srcPtr = Rbc_ColorImageBits(src);
    offset = (height - 1) * width;
    for (y = 0; y < height; y++) {
        destPtr = Rbc_ColorImageBits(dest) + offset + width - 1;
        for (x = 0; x < width; x++) {
            *destPtr-- = *srcPtr++;
        }
        offset -= width;
    }
    return dest;
}

/*
 * ---------------------------------------------------------------------------
 *
 * Rotate270 --
 *
 *      Rotates the given color image by 270 degrees.  This is part
 *      of the special case right-angle rotations that do not create
 *      subpixel aliasing.
 *
 * Results:
 *      Returns a newly allocated, rotated color image.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 * ---------------------------------------------------------------------------
 */
static Rbc_ColorImage
Rotate270(src)
    Rbc_ColorImage src;
{
    int width, height;
    Pix32 *srcPtr, *destPtr;
    Rbc_ColorImage dest;
    register int x, y;

    height = Rbc_ColorImageWidth(src);
    width = Rbc_ColorImageHeight(src);
    dest = Rbc_CreateColorImage(width, height);

    srcPtr = Rbc_ColorImageBits(src);
    for (x = width - 1; x >= 0; x--) {
        destPtr = Rbc_ColorImageBits(dest) + x;
        for (y = 0; y < height; y++) {
            *destPtr = *srcPtr++;
            destPtr += width;
        }
    }
    return dest;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_RotateColorImage --
 *
 *      Rotates a color image by a given # of degrees.
 *
 * Results:
 *      Returns a newly allocated, rotated color image.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
Rbc_ColorImage
Rbc_RotateColorImage(src, angle)
    Rbc_ColorImage src;
    double angle;
{
    Rbc_ColorImage dest, tmp;
    int quadrant;

    tmp = src;			/* Suppress compiler warning. */

    /* Make the angle positive between 0 and 360 degrees. */
    angle = FMOD(angle, 360.0);
    if (angle < 0.0) {
        angle += 360.0;
    }
    quadrant = ROTATE_0;
    if ((angle > 45.0) && (angle <= 135.0)) {
        quadrant = ROTATE_90;
        angle -= 90.0;
    } else if ((angle > 135.0) && (angle <= 225.0)) {
        quadrant = ROTATE_180;
        angle -= 180.0;
    } else if ((angle > 225.0) && (angle <= 315.0)) {
        quadrant = ROTATE_270;
        angle -= 270.0;
    } else if (angle > 315.0) {
        angle -= 360.0;
    }
    /*
     * If necessary, create a temporary image that's been rotated
     * by a right-angle.  We'll then rotate this color image between
     * -45 to 45 degrees to arrive at its final angle.
     */
    switch (quadrant) {
        case ROTATE_270:		/* 270 degrees */
            tmp = Rotate270(src);
            break;

        case ROTATE_90:		/* 90 degrees */
            tmp = Rotate90(src);
            break;

        case ROTATE_180:		/* 180 degrees */
            tmp = Rotate180(src);
            break;

        case ROTATE_0:		/* 0 degrees */
            if (angle == 0.0) {
                tmp = CopyColorImage(src); /* Make a copy of the source. */
            }
            break;
    }

    assert((angle >= -45.0) && (angle <= 45.0));

    dest = tmp;
    if (angle != 0.0) {
        double theta;
        Pix32 *srcPtr;
        Pix32 bgColor;

        /* FIXME: pick up background blending color from somewhere */
        srcPtr = Rbc_ColorImageBits(src);
        bgColor = *srcPtr;
        bgColor.Red = bgColor.Green = bgColor.Blue = 0xFF;
        bgColor.Alpha = 0x00;	/* Transparent background */
        theta = (angle / 180.0) * M_PI;
        dest = Rotate45(tmp, theta, bgColor);
        if (tmp != src) {
            Rbc_FreeColorImage(tmp);
        }
    }
    return dest;
}

/*
 *--------------------------------------------------------------
 *
 * GetColorImageStatistics --
 *
 *      Build 3-D color histogram of counts, R/G/B, c^2
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static ColorImageStatistics *
GetColorImageStatistics(image)
    Rbc_ColorImage image;
{
    register int r, g, b;
#define MAX_INTENSITIES	256
    unsigned int sqr[MAX_INTENSITIES];
    int numPixels;
    Pix32 *srcPtr, *endPtr;
    register int i;
    ColorImageStatistics *s;

    s = RbcCalloc(1, sizeof(ColorImageStatistics));
    assert(s);

    /* Precompute table of squares. */
    for (i = 0; i < MAX_INTENSITIES; i++) {
        sqr[i] = i * i;
    }
    numPixels = Rbc_ColorImageWidth(image) * Rbc_ColorImageHeight(image);

    for (srcPtr = Rbc_ColorImageBits(image), endPtr = srcPtr + numPixels;
            srcPtr < endPtr; srcPtr++) {
        /*
         * Reduce the number of bits (5) per color component. This
         * will keep the table size (2^15) reasonable without perceptually
         * affecting the final image.
         */
        r = (srcPtr->Red >> 3) + 1;
        g = (srcPtr->Green >> 3) + 1;
        b = (srcPtr->Blue >> 3) + 1;
        s->wt[r][g][b] += 1;
        s->mR[r][g][b] += srcPtr->Red;
        s->mG[r][g][b] += srcPtr->Green;
        s->mB[r][g][b] += srcPtr->Blue;
        s->gm2[r][g][b] += sqr[srcPtr->Red] + sqr[srcPtr->Green] +
                           sqr[srcPtr->Blue];
    }
    return s;
}

/*
 *----------------------------------------------------------------------
 * At conclusion of the histogram step, we can interpret
 *   wt[r][g][b] = sum over voxel of P(c)
 *   mR[r][g][b] = sum over voxel of r*P(c)  ,  similarly for mG, mB
 *   m2[r][g][b] = sum over voxel of c^2*P(c)
 * Actually each of these should be divided by 'size' to give the usual
 * interpretation of P() as ranging from 0 to 1, but we needn't do that here.
 *----------------------------------------------------------------------
 */

/*
 *--------------------------------------------------------------
 *
 * M3d --
 *
 *      We now convert histogram into moments so that we
 *      can rapidly calculate the sums of the above
 *      quantities over any desired box.
 *
 *      compute cumulative moments
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
M3d(s)
    ColorImageStatistics *s;
{
    register unsigned char i, r, g, b, r0;
    long int line, rLine, gLine, bLine;
    long int area[33], rArea[33], gArea[33], bArea[33];
    unsigned int line2, area2[33];

    for (r = 1, r0 = 0; r <= 32; r++, r0++) {
        for (i = 0; i <= 32; ++i) {
            area2[i] = area[i] = rArea[i] = gArea[i] = bArea[i] = 0;
        }
        for (g = 1; g <= 32; g++) {
            line2 = line = rLine = gLine = bLine = 0;
            for (b = 1; b <= 32; b++) {
                /* ind1 = RGBIndex(r, g, b); */

                line += s->wt[r][g][b];
                rLine += s->mR[r][g][b];
                gLine += s->mG[r][g][b];
                bLine += s->mB[r][g][b];
                line2 += s->gm2[r][g][b];

                area[b] += line;
                rArea[b] += rLine;
                gArea[b] += gLine;
                bArea[b] += bLine;
                area2[b] += line2;

                /* ind2 = ind1 - 1089; [r0][g][b] */
                s->wt[r][g][b] = s->wt[r0][g][b] + area[b];
                s->mR[r][g][b] = s->mR[r0][g][b] + rArea[b];
                s->mG[r][g][b] = s->mG[r0][g][b] + gArea[b];
                s->mB[r][g][b] = s->mB[r0][g][b] + bArea[b];
                s->gm2[r][g][b] = s->gm2[r0][g][b] + area2[b];
            }
        }
    }
}

/*
 *--------------------------------------------------------------
 *
 * Volume --
 *
 *      Compute sum over a box of any given statistic
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static INLINE long int
Volume(cubePtr, m)
    Cube *cubePtr;
    long int m[33][33][33];
{
    return (m[R1][G1][B1] - m[R1][G1][B0] - m[R1][G0][B1] + m[R1][G0][B0] -
            m[R0][G1][B1] + m[R0][G1][B0] + m[R0][G0][B1] - m[R0][G0][B0]);
}

/*
 *----------------------------------------------------------------------
 *
 *      The next two routines allow a slightly more efficient
 *      calculation of Volume() for a proposed subbox of a given box.
 *      The sum of Top() and Bottom() is the Volume() of a subbox split
 *      in the given direction and with the specified new upper
 *      bound.
 *
 *----------------------------------------------------------------------
 */

/*
 *--------------------------------------------------------------
 *
 * Bottom --
 *
 *      Compute part of Volume(cubePtr, mmt) that doesn't
 *      depend on r1, g1, or b1 (depending on dir)
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static long int
Bottom(cubePtr, dir, m)
    Cube *cubePtr;
    unsigned char dir;
    long int m[33][33][33];	/* Moment */
{
    switch (dir) {
        case RED:
            return -m[R0][G1][B1] + m[R0][G1][B0] + m[R0][G0][B1] - m[R0][G0][B0];
        case GREEN:
            return -m[R1][G0][B1] + m[R1][G0][B0] + m[R0][G0][B1] - m[R0][G0][B0];
        case BLUE:
            return -m[R1][G1][B0] + m[R1][G0][B0] + m[R0][G1][B0] - m[R0][G0][B0];
    }
    return 0;
}

/*
 *--------------------------------------------------------------
 *
 * Top --
 *
 *      Compute remainder of Volume(cubePtr, mmt),
 *      substituting pos for r1, g1, or b1 (depending on dir)
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static long int
Top(cubePtr, dir, pos, m)
    Cube *cubePtr;
    unsigned char dir;
    int pos;
    long int m[33][33][33];
{
    switch (dir) {
        case RED:
            return (m[pos][G1][B1] - m[pos][G1][B0] -
                    m[pos][G0][B1] + m[pos][G0][B0]);

        case GREEN:
            return (m[R1][pos][B1] - m[R1][pos][B0] -
                    m[R0][pos][B1] + m[R0][pos][B0]);

        case BLUE:
            return (m[R1][G1][pos] - m[R1][G0][pos] -
                    m[R0][G1][pos] + m[R0][G0][pos]);
    }
    return 0;
}

/*
 *--------------------------------------------------------------
 *
 * Variance --
 *
 *      Compute the weighted variance of a box NB: as with
 *      the raw statistics, this is really the (variance * size)
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static double
Variance(cubePtr, s)
    Cube *cubePtr;
    ColorImageStatistics *s;
{
    double dR, dG, dB, xx;

    dR = Volume(cubePtr, s->mR);
    dG = Volume(cubePtr, s->mG);
    dB = Volume(cubePtr, s->mB);
    xx = (s->gm2[R1][G1][B1] - s->gm2[R1][G1][B0] -
          s->gm2[R1][G0][B1] + s->gm2[R1][G0][B0] -
          s->gm2[R0][G1][B1] + s->gm2[R0][G1][B0] +
          s->gm2[R0][G0][B1] - s->gm2[R0][G0][B0]);
    return (xx - (dR * dR + dG * dG + dB * dB) / Volume(cubePtr, s->wt));
}

/*
 *--------------------------------------------------------------
 *
 * Maximize --
 *
 *      We want to minimize the sum of the variances of two
 *      subboxes. The sum(c^2) terms can be ignored since
 *      their sum over both subboxes is the same (the sum
 *      for the whole box) no matter where we split.  The
 *      remaining terms have a minus sign in the variance
 *      formula, so we drop the minus sign and MAXIMIZE the
 *      sum of the two terms.
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
static double
Maximize(cubePtr, dir, first, last, cut, rWhole, gWhole, bWhole, wWhole, s)
    Cube *cubePtr;
    unsigned char dir;
    int first, last, *cut;
    long int rWhole, gWhole, bWhole, wWhole;
    ColorImageStatistics *s;
{
    register long int rHalf, gHalf, bHalf, wHalf;
    long int rBase, gBase, bBase, wBase;
    register int i;
    register double temp, max;

    rBase = Bottom(cubePtr, dir, s->mR);
    gBase = Bottom(cubePtr, dir, s->mG);
    bBase = Bottom(cubePtr, dir, s->mB);
    wBase = Bottom(cubePtr, dir, s->wt);
    max = 0.0;
    *cut = -1;
    for (i = first; i < last; i++) {
        rHalf = rBase + Top(cubePtr, dir, i, s->mR);
        gHalf = gBase + Top(cubePtr, dir, i, s->mG);
        bHalf = bBase + Top(cubePtr, dir, i, s->mB);
        wHalf = wBase + Top(cubePtr, dir, i, s->wt);

        /* Now half_x is sum over lower half of box, if split at i */
        if (wHalf == 0) {	/* subbox could be empty of pixels! */
            continue;		/* never split into an empty box */
        } else {
            temp = ((double)rHalf * rHalf + (float)gHalf * gHalf +
                    (double)bHalf * bHalf) / wHalf;
        }
        rHalf = rWhole - rHalf;
        gHalf = gWhole - gHalf;
        bHalf = bWhole - bHalf;
        wHalf = wWhole - wHalf;
        if (wHalf == 0) {	/* Subbox could be empty of pixels! */
            continue;		/* never split into an empty box */
        } else {
            temp += ((double)rHalf * rHalf + (float)gHalf * gHalf +
                     (double)bHalf * bHalf) / wHalf;
        }
        if (temp > max) {
            max = temp;
            *cut = i;
        }
    }
    return max;
}

/*
 *--------------------------------------------------------------
 *
 * Cut --
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
Cut(set1, set2, s)
    Cube *set1, *set2;
    ColorImageStatistics *s;
{
    unsigned char dir;
    int rCut, gCut, bCut;
    double rMax, gMax, bMax;
    long int rWhole, gWhole, bWhole, wWhole;

    rWhole = Volume(set1, s->mR);
    gWhole = Volume(set1, s->mG);
    bWhole = Volume(set1, s->mB);
    wWhole = Volume(set1, s->wt);

    rMax = Maximize(set1, RED, set1->r0 + 1, set1->r1, &rCut,
                    rWhole, gWhole, bWhole, wWhole, s);
    gMax = Maximize(set1, GREEN, set1->g0 + 1, set1->g1, &gCut,
                    rWhole, gWhole, bWhole, wWhole, s);
    bMax = Maximize(set1, BLUE, set1->b0 + 1, set1->b1, &bCut,
                    rWhole, gWhole, bWhole, wWhole, s);

    if ((rMax >= gMax) && (rMax >= bMax)) {
        dir = RED;
        if (rCut < 0) {
            return 0;		/* can't split the box */
        }
    } else {
        dir = ((gMax >= rMax) && (gMax >= bMax)) ? GREEN : BLUE;
    }
    set2->r1 = set1->r1;
    set2->g1 = set1->g1;
    set2->b1 = set1->b1;

    switch (dir) {
        case RED:
            set2->r0 = set1->r1 = rCut;
            set2->g0 = set1->g0;
            set2->b0 = set1->b0;
            break;

        case GREEN:
            set2->g0 = set1->g1 = gCut;
            set2->r0 = set1->r0;
            set2->b0 = set1->b0;
            break;

        case BLUE:
            set2->b0 = set1->b1 = bCut;
            set2->r0 = set1->r0;
            set2->g0 = set1->g0;
            break;
    }
    set1->vol = (set1->r1 - set1->r0) * (set1->g1 - set1->g0) *
                (set1->b1 - set1->b0);
    set2->vol = (set2->r1 - set2->r0) * (set2->g1 - set2->g0) *
                (set2->b1 - set2->b0);
    return 1;
}

/*
 *--------------------------------------------------------------
 *
 * SplitColorSpace --
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
SplitColorSpace(s, cubes, nColors)
    ColorImageStatistics *s;
    Cube *cubes;
    int nColors;
{
    double *vv, temp;
    register int i;
    register int n, k;

    vv = (double *)ckalloc(sizeof(double) * nColors);
    assert(vv);

    cubes[0].r0 = cubes[0].g0 = cubes[0].b0 = 0;
    cubes[0].r1 = cubes[0].g1 = cubes[0].b1 = 32;
    for (i = 1, n = 0; i < nColors; i++) {
        if (Cut(cubes + n, cubes + i, s)) {
            /*
             * Volume test ensures we won't try to cut one-cell box
             */
            vv[n] = vv[i] = 0.0;
            if (cubes[n].vol > 1) {
                vv[n] = Variance(cubes + n, s);
            }
            if (cubes[i].vol > 1) {
                vv[i] = Variance(cubes + i, s);
            }
        } else {
            vv[n] = 0.0;	/* don't try to split this box again */
            i--;		/* didn't create box i */
        }

        n = 0;
        temp = vv[0];
        for (k = 1; k <= i; k++) {
            if (vv[k] > temp) {
                temp = vv[k];
                n = k;
            }
        }
        if (temp <= 0.0) {
            i++;
            fprintf(stderr, "Only got %d boxes\n", i);
            break;
        }
    }
    ckfree((char *)vv);
    return i;
}

/*
 *--------------------------------------------------------------
 *
 * Mark --
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
Mark(cubePtr, label, tag)
    Cube *cubePtr;
    int label;
    unsigned int tag[33][33][33];
{
    register int r, g, b;

    for (r = R0 + 1; r <= R1; r++) {
        for (g = G0 + 1; g <= G1; g++) {
            for (b = B0 + 1; b <= B1; b++) {
                tag[r][g][b] = label;
            }
        }
    }
}

/*
 *--------------------------------------------------------------
 *
 * CreateColorLookupTable --
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
static unsigned int *
CreateColorLookupTable(s, cubes, nColors)
    ColorImageStatistics *s;
    Cube *cubes;
    int nColors;
{
    unsigned int *lut;
    Pix32 color;
    unsigned int red, green, blue;
    unsigned int weight;
    register Cube *cubePtr;
    register int i;

    lut = RbcCalloc(sizeof(unsigned int), 33 * 33 * 33);
    assert(lut);

    color.Alpha = (unsigned char)-1;
    for (cubePtr = cubes, i = 0; i < nColors; i++, cubePtr++) {
        weight = Volume(cubePtr, s->wt);
        if (weight) {
            red = (Volume(cubePtr, s->mR) / weight) * (NC + 1);
            green = (Volume(cubePtr, s->mG) / weight) * (NC + 1);
            blue = (Volume(cubePtr, s->mB) / weight) * (NC + 1);
        } else {
            fprintf(stderr, "bogus box %d\n", i);
            red = green = blue = 0;
        }
        color.Red = red >> 8;
        color.Green = green >> 8;
        color.Blue = blue >> 8;
        Mark(cubePtr, color.value, lut);
    }
    return lut;
}

/*
 *--------------------------------------------------------------
 *
 * MapColors --
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
MapColors(src, dest, lut)
    Rbc_ColorImage src, dest;
    unsigned int lut[33][33][33];
{
    /* Apply the color lookup table against the original image */
    int width, height;
    int count;
    Pix32 *srcPtr, *destPtr, *endPtr;
    unsigned char alpha;

    width = Rbc_ColorImageWidth(src);
    height = Rbc_ColorImageHeight(src);
    count = width * height;

    srcPtr = Rbc_ColorImageBits(src);
    destPtr = Rbc_ColorImageBits(dest);
    for (endPtr = destPtr + count; destPtr < endPtr; srcPtr++, destPtr++) {
        alpha = srcPtr->Alpha;
        destPtr->value = lut[srcPtr->Red>>3][srcPtr->Green>>3][srcPtr->Blue>>3];
        destPtr->Alpha = alpha;
    }
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_QuantizeColorImage --
 *
 *      C Implementation of Wu's Color Quantizer (v. 2) (see Graphics Gems
 *      vol. II, pp. 126-133)
 *
 *      Author: Xiaolin Wu
 *            Dept. of Computer Science Univ. of Western
 *            Ontario London, Ontario
 *            N6A 5B7
 *            wu@csd.uwo.ca
 *
 *      Algorithm:
 *            Greedy orthogonal bipartition of RGB space for variance
 *            minimization aided by inclusion-exclusion tricks.  For
 *            speed no nearest neighbor search is done. Slightly
 *            better performance can be expected by more
 *            sophisticated but more expensive versions.
 *
 *      The author thanks Tom Lane at Tom_Lane@G.GP.CS.CMU.EDU for much of
 *      additional documentation and a cure to a previous bug.
 *
 *      Free to distribute, comments and suggestions are appreciated.
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
Rbc_QuantizeColorImage(src, dest, reduceColors)
    Rbc_ColorImage src, dest; /* Source and destination images. */
    int reduceColors; /* Reduced number of colors. */
{
    Cube *cubes;
    ColorImageStatistics *statistics;
    int nColors;
    unsigned int *lut;

    /*
     * Allocated a structure to hold color statistics.
     */
    statistics = GetColorImageStatistics(src);
    M3d(statistics);

    cubes = (Cube *)ckalloc(sizeof(Cube) * reduceColors);
    assert(cubes);

    nColors = SplitColorSpace(statistics, cubes, reduceColors);
    assert(nColors <= reduceColors);

    lut = CreateColorLookupTable(statistics, cubes, nColors);
    ckfree((char *)statistics);
    ckfree((char *)cubes);
    MapColors(src, dest, lut);
    ckfree((char *)lut);
    return TCL_OK;
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_SetRegion --
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
Region2D *
Rbc_SetRegion(x, y, width, height, regionPtr)
    int x, y, width, height;
    Region2D *regionPtr;
{
    regionPtr->left = x;
    regionPtr->top = y;
    regionPtr->right = x + width - 1;
    regionPtr->bottom = y + height - 1;
    return regionPtr;
}


/*
 * Each call to Tk_GetImage returns a pointer to one of the following
 * structures, which is used as a token by clients (widgets) that
 * display images.
 */
typedef struct TkImageStruct {
    Tk_Window tkwin;		/* Window passed to Tk_GetImage (needed to
				 * "re-get" the image later if the manager
				 * changes). */
    Display *display;		/* Display for tkwin.  Needed because when
				 * the image is eventually freed tkwin may
				 * not exist anymore. */
    struct TkImageMasterStruct *masterPtr;
    /* Master for this image (identifiers image
     * manager, for example). */
    ClientData instanceData;
    /* One word argument to pass to image manager
     * when dealing with this image instance. */
    Tk_ImageChangedProc *changeProc;
    /* Code in widget to call when image changes
     * in a way that affects redisplay. */
    ClientData widgetClientData;
    /* Argument to pass to changeProc. */
    struct Image *nextPtr;	/* Next in list of all image instances
				 * associated with the same name. */

} TkImage;

/*
 * For each image master there is one of the following structures,
 * which represents a name in the image table and all of the images
 * instantiated from it.  Entries in mainPtr->imageTable point to
 * these structures.
 */
typedef struct TkImageMasterStruct {
    Tk_ImageType *typePtr;	/* Information about image type.  NULL means
				 * that no image manager owns this image:  the
				 * image was deleted. */
    ClientData masterData;	/* One-word argument to pass to image mgr
				 * when dealing with the master, as opposed
				 * to instances. */
    int width, height;		/* Last known dimensions for image. */
    Tcl_HashTable *tablePtr;	/* Pointer to hash table containing image
				 * (the imageTable field in some TkMainInfo
				 * structure). */
    Tcl_HashEntry *hPtr;	/* Hash entry in mainPtr->imageTable for
				 * this structure (used to delete the hash
				 * entry). */
    TkImage *instancePtr;	/* Pointer to first in list of instances
				 * derived from this name. */
} TkImageMaster;


typedef struct TkPhotoMasterStruct TkPhotoMaster;
typedef struct TkColorTableStruct TkColorTable;

typedef struct TkPhotoInstanceStruct {
    TkPhotoMaster *masterPtr;	/* Pointer to master for image. */
    Display *display;		/* Display for windows using this instance. */
    Colormap colormap;		/* The image may only be used in windows with
				 * this particular colormap. */
    struct TkPhotoInstanceStruct *nextPtr;
    /* Pointer to the next instance in the list
     * of instances associated with this master. */
    int refCount;		/* Number of instances using this structure. */
    Tk_Uid palette;		/* Palette for these particular instances. */
    double outputGamma;		/* Gamma value for these instances. */
    Tk_Uid defaultPalette;	/* Default palette to use if a palette
				 * is not specified for the master. */
    TkColorTable *colorTablePtr;	/* Pointer to information about colors
				 * allocated for image display in windows
				 * like this one. */
    Pixmap pixels;		/* X pixmap containing dithered image. */
    int width, height;		/* Dimensions of the pixmap. */
    char *error;		/* Error image, used in dithering. */
    XImage *imagePtr;		/* Image structure for converted pixels. */
    XVisualInfo visualInfo;	/* Information about the visual that these
				 * windows are using. */
    GC gc;			/* Graphics context for writing images
				 * to the pixmap. */
} TkPhotoInstance;

/*
 * ----------------------------------------------------------------------
 *
 * Tk_ImageDeleted --
 *
 *      Is there any other way to determine if an image has been
 *      deleted?
 *
 * Results:
 *      Returns 1 if the image has been deleted, 0 otherwise.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 * ----------------------------------------------------------------------
 */
int
Tk_ImageIsDeleted(tkImage)
    Tk_Image tkImage; /* Token for image. */
{
    TkImage *imagePtr = (TkImage *) tkImage;

    if (imagePtr->masterPtr == NULL) {
        return TRUE;
    }
    return (imagePtr->masterPtr->typePtr == NULL);
}

/*
 *--------------------------------------------------------------
 *
 * Tk_ImageGetMaster --
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
Tk_ImageMaster
Tk_ImageGetMaster(tkImage)
    Tk_Image tkImage; /* Token for image. */
{
    TkImage *imagePtr = (TkImage *)tkImage;

    return (Tk_ImageMaster) imagePtr->masterPtr;
}

/*
 *--------------------------------------------------------------
 *
 * Tk_ImageGetType --
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
Tk_ImageType *
Tk_ImageGetType(tkImage)
    Tk_Image tkImage; /* Token for image. */
{
    TkImage *imagePtr = (TkImage *)tkImage;

    return imagePtr->masterPtr->typePtr;
}

/*
 *--------------------------------------------------------------
 *
 * Tk_ImageGetPhotoPixmap --
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
Pixmap
Tk_ImageGetPhotoPixmap(tkImage)
    Tk_Image tkImage; /* Token for image. */
{
    TkImage *imagePtr = (TkImage *)tkImage;

    if (strcmp(imagePtr->masterPtr->typePtr->name, "photo") == 0) {
        TkPhotoInstance *instPtr = (TkPhotoInstance *)imagePtr->instanceData;
        return instPtr->pixels;
    }
    return None;
}

/*
 *--------------------------------------------------------------
 *
 * Tk_ImageGetPhotoGC --
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
GC
Tk_ImageGetPhotoGC(photoImage)
    Tk_Image photoImage; /* Token for image. */
{
    TkImage *imagePtr = (TkImage *) photoImage;
    if (strcmp(imagePtr->masterPtr->typePtr->name, "photo") == 0) {
        TkPhotoInstance *instPtr = (TkPhotoInstance *)imagePtr->instanceData;
        return instPtr->gc;
    }
    return NULL;
}

/*
 *----------------------------------------------------------------------
 *
 * TempImageChangedProc
 *
 *      The image is over-written each time it's resized.  We always
 *      resample from the color image we saved when the photo image
 *      was specified (-image option). So we only worry if the image
 *      is deleted.
 *
 * Results:
 *      None.
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
static void
TempImageChangedProc(clientData, x, y, width, height, imageWidth, imageHeight)
    ClientData clientData;
    int x, y, width, height; /* Not used. */
    int imageWidth, imageHeight; /* Not used. */
{
#ifdef notdef
    fprintf(stderr, "should be redrawing temp image\n");
#endif
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_CreateTemporaryImage --
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
Tk_Image
Rbc_CreateTemporaryImage(interp, tkwin, clientData)
    Tcl_Interp *interp;
    Tk_Window tkwin;
    ClientData clientData;
{
    Tk_Image token;
    char *name;			/* Contains image name. */

    if (Tcl_Eval(interp, "image create photo") != TCL_OK) {
        return NULL;
    }
    name = (char *)Tcl_GetStringResult(interp);
    token = Tk_GetImage(interp, tkwin, name, TempImageChangedProc, clientData);
    if (token == NULL) {
        return NULL;
    }
    return token;
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_DestroyTemporaryImage --
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
Rbc_DestroyTemporaryImage(interp, tkImage)
    Tcl_Interp *interp;
    Tk_Image tkImage;
{
    if (tkImage != NULL) {
        if (Tcl_VarEval(interp, "image delete ", Rbc_NameOfImage(tkImage),
                        (char *)NULL) != TCL_OK) {
            return TCL_ERROR;
        }
        Tk_FreeImage(tkImage);
    }
    return TCL_OK;
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_NameOfImage --
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
Rbc_NameOfImage(tkImage)
    Tk_Image tkImage;
{
    Tk_ImageMaster master;

    master = Tk_ImageGetMaster(tkImage);
    return Tk_NameOfImage(master);
}
