/*
 * rbcChain.h --
 *
 *      Adds descriptions for the chains used in rbc.
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#ifndef _RBCCHAIN
#define _RBCCHAIN

#include <tcl.h>

#define Rbc_ChainGetLength(c)	(((c) == NULL) ? 0 : (c)->nLinks)
#define Rbc_ChainFirstLink(c)	(((c) == NULL) ? NULL : (c)->headPtr)
#define Rbc_ChainLastLink(c)	(((c) == NULL) ? NULL : (c)->tailPtr)
#define Rbc_ChainPrevLink(l)	((l)->prevPtr)
#define Rbc_ChainNextLink(l) 	((l)->nextPtr)
#define Rbc_ChainGetValue(l)  	((l)->clientData)
#define Rbc_ChainSetValue(l, value) ((l)->clientData = (ClientData)(value))
#define Rbc_ChainAppendLink(c, l) \
	(Rbc_ChainLinkBefore((c), (l), (Rbc_ChainLink *)NULL))
#define Rbc_ChainPrependLink(c, l) \
	(Rbc_ChainLinkAfter((c), (l), (Rbc_ChainLink *)NULL))

typedef struct Rbc_ChainLinkStruct Rbc_ChainLink;

/*
 * A Rbc_ChainLink is the container structure for the Rbc_Chain.
 */

struct Rbc_ChainLinkStruct {
    Rbc_ChainLink *prevPtr;	/* Link to the previous link */
    Rbc_ChainLink *nextPtr;	/* Link to the next link */
    ClientData clientData; /* Pointer to the data object */
};

typedef int (Rbc_ChainCompareProc) _ANSI_ARGS_((Rbc_ChainLink **l1PtrPtr,  Rbc_ChainLink **l2PtrPtr));

/*
 * A Rbc_Chain is a doubly chained list structure.
 */

typedef struct {
    Rbc_ChainLink *headPtr;	/* Pointer to first element in chain */
    Rbc_ChainLink *tailPtr;	/* Pointer to last element in chain */
    int nLinks; /* Number of elements in chain */
} Rbc_Chain;

void Rbc_ChainInit _ANSI_ARGS_((Rbc_Chain * chainPtr));
Rbc_Chain *Rbc_ChainCreate _ANSI_ARGS_(());
void Rbc_ChainDestroy _ANSI_ARGS_((Rbc_Chain * chainPtr));
Rbc_ChainLink *Rbc_ChainNewLink _ANSI_ARGS_((void));
Rbc_ChainLink *Rbc_ChainAllocLink _ANSI_ARGS_((unsigned int size));
Rbc_ChainLink *Rbc_ChainAppend _ANSI_ARGS_((Rbc_Chain * chainPtr, ClientData clientData));
Rbc_ChainLink *Rbc_ChainPrepend _ANSI_ARGS_((Rbc_Chain * chainPtr, ClientData clientData));
void Rbc_ChainReset _ANSI_ARGS_((Rbc_Chain * chainPtr));
void Rbc_ChainLinkAfter _ANSI_ARGS_((Rbc_Chain * chainPtr, Rbc_ChainLink * linkPtr, Rbc_ChainLink * afterLinkPtr));
void Rbc_ChainLinkBefore _ANSI_ARGS_((Rbc_Chain * chainPtr, Rbc_ChainLink * linkPtr, Rbc_ChainLink * beforeLinkPtr));
void Rbc_ChainUnlinkLink _ANSI_ARGS_((Rbc_Chain * chainPtr, Rbc_ChainLink * linkPtr));
void Rbc_ChainDeleteLink _ANSI_ARGS_((Rbc_Chain * chainPtr, Rbc_ChainLink * linkPtr));
Rbc_ChainLink *Rbc_ChainGetNthLink _ANSI_ARGS_((Rbc_Chain * chainPtr, int n));
void Rbc_ChainSort _ANSI_ARGS_((Rbc_Chain * chainPtr, Rbc_ChainCompareProc * proc));

#endif /* _RBCCHAIN */
