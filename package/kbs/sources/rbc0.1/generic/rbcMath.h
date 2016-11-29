/*
 * rbcMath.h --
 *
 *      TODO: Description
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#ifndef _RBCMATH
#define _RBCMATH

#include <math.h>

#ifdef HAVE_FLOAT_H
#include <float.h>
#endif

#ifdef HAVE_IEEEFP_H
#include <ieeefp.h>
#endif /* HAVE_IEEEFP_H */

#ifndef M_PI
#define M_PI    	3.14159265358979323846
#endif /* M_PI */

#ifndef M_PI_2
#define M_PI_2		1.57079632679489661923
#endif

#ifndef M_SQRT2
#define M_SQRT2		1.41421356237309504880
#endif /* M_SQRT2 */

#ifndef M_SQRT1_2
#define M_SQRT1_2	0.70710678118654752440
#endif /* M_SQRT1_2 */

#ifndef SHRT_MAX
#define SHRT_MAX	0x7FFF
#endif /* SHRT_MAX */

#ifndef SHRT_MIN
#define SHRT_MIN	-(SHRT_MAX)
#endif /* SHRT_MAX */

#ifndef USHRT_MAX
#define	USHRT_MAX	0xFFFF
#endif /* USHRT_MAX */

#ifndef INT_MAX
#define INT_MAX		2147483647
#endif /* INT_MAX */

#ifndef HAVE_FLOAT_H
/*
 * ----------------------------------------------------------------------
 *
 * DBL_MIN, DBL_MAX --
 *
 * 	DBL_MAX and DBL_MIN are the largest and smaller double
 * 	precision numbers that can be represented by the floating
 * 	point hardware. If the compiler is ANSI, they can be found in
 * 	float.h.  Otherwise, we use HUGE_VAL or HUGE to determine
 * 	them.
 *
 * ----------------------------------------------------------------------
 */
/*
 * Don't want to include __infinity (definition of HUGE_VAL (SC1.x))
 */
#ifdef sun
#define DBL_MAX		1.7976931348623157E+308
#define DBL_MIN		2.2250738585072014E-308
#define DBL_EPSILON	2.2204460492503131e-16
#else
#ifndef DBL_EPSILON
#define DBL_EPSILON	2.2204460492503131e-16
#endif
#ifdef HUGE_VAL
#define DBL_MAX		HUGE_VAL
#define DBL_MIN		(1/HUGE_VAL)
#else
#ifdef HUGE
#define DBL_MAX		HUGE
#define DBL_MIN		(1/HUGE)
#else
/*
 * Punt: Assume relatively small values
 */
#define DBL_MAX		3.40282347E+38
#define DBL_MIN		1.17549435E-38
#endif /*HUGE*/
#endif /*HUGE_VAL*/
#endif /*sun*/
#endif /*!HAVE_FLOAT_H*/

/*
 * ----------------------------------------------------------------------
 *
 *  	The following are macros replacing math library functions:
 *  	"fabs", "fmod", "abs", "rint", and "exp10".
 *
 *  	Although many of these routines may exist in your math
 *  	library, they aren't used in libtcl.a or libtk.a.  This makes
 *  	it difficult to dynamically load the rbc library as a shared
 *  	object unless the math library is also shared (which isn't
 *  	true on several systems).  We can avoid the problem by
 *  	replacing the "exotic" math routines with macros.
 *
 * ----------------------------------------------------------------------
 */
#undef ABS
#define ABS(x)		(((x)<0)?(-(x)):(x))

#undef EXP10
#define EXP10(x)	(pow(10.0,(x)))

#undef FABS
#define FABS(x) 	(((x)<0.0)?(-(x)):(x))

#undef SIGN
#define SIGN(x)		(((x) < 0.0) ? -1 : 1)

/*
 * Be careful when using the next two macros.  They both assume the floating
 * point number is less than the size of an int.  That means, for example, you
 * can't use these macros with numbers bigger than than 2^31-1.
 */
#undef FMOD
#define FMOD(x,y) 	((x)-(((int)((x)/(y)))*y))

#undef ROUND
#define ROUND(x) 	((int)((x) + (((x)<0.0) ? -0.5 : 0.5)))

#ifdef HAVE_FINITE
#define FINITE(x)	finite(x)
#else
#ifdef HAVE_ISFINITE
#define FINITE(x)	isfinite(x)
#else
#ifdef HAVE_ISNAN
#define FINITE(x)	(!isnan(x))
#else
#define FINITE(x)	(TRUE)
#endif /* HAVE_ISNAN */
#endif /* HAVE_ISFINITE */
#endif /* HAVE_FINITE */

extern double rbcNaN;

#define DEFINED(x)	(!isnan(x))
#define UNDEFINED(x)	(isnan(x))
#define VALUE_UNDEFINED rbcNaN

/*
 * ----------------------------------------------------------------------
 *
 *	On some systems "strdup" and "strcasecmp" are in the C library,
 *      but have no declarations in the C header files. Make sure we
 *      supply them here.
 *
 * ----------------------------------------------------------------------
 */
#ifdef NEED_DECL_STRDUP
char *strdup _ANSI_ARGS_((CONST char *s));
#endif /* NEED_DECL_STRDUP */

/*
#ifndef HAVE_STRTOLOWER
extern void strtolower _ANSI_ARGS_((char *s));
#endif HAVE_STRTOLOWER */

#ifdef NEED_DECL_DRAND48
double drand48 _ANSI_ARGS_((void));
void srand48 _ANSI_ARGS_((long seed));
#endif /* NEED_DECL_DRAND48 */

#ifdef NEED_DECL_STRCASECMP
int strcasecmp _ANSI_ARGS_((CONST char *s1, CONST char *s2));
#endif /* NEED_DECL_STRCASECMP */

#endif /* _RBCMATH */
