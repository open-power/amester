/*
 * rbc.h --
 *
 *      This file constructs the basic functionality of the
 *      rbc commands.
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#ifndef _RBC
#define _RBC

#define RBC_VERSION "0.1"
#define RBC_MAJOR_VERSION 0
#define RBC_MINOR_VERSION 1

#include <tcl.h>

#ifndef EXPORT
#define EXPORT
#endif

#undef EXTERN

#ifdef __cplusplus
#   define EXTERN extern "C" EXPORT
#else
#   define EXTERN extern EXPORT
#endif

#include "rbcVector.h"

typedef char *Rbc_Uid;

EXTERN Rbc_Uid Rbc_GetUid _ANSI_ARGS_((char *string));
EXTERN void Rbc_FreeUid _ANSI_ARGS_((Rbc_Uid uid));
EXTERN Rbc_Uid Rbc_FindUid _ANSI_ARGS_((char *string));

EXTERN int Rbc_Init _ANSI_ARGS_ ((Tcl_Interp *interp));

#endif /* _RBC */
