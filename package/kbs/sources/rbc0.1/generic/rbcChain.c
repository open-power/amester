/*
 * rbcChain.c --
 *
 * The module implements a generic linked list package.
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#include "rbcInt.h"
#include "rbcChain.h"

#ifndef ALIGN
#define ALIGN(a) \
    (((size_t)a + (sizeof(double) - 1)) & (~(sizeof(double) - 1)))
#endif /* ALIGN */

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ChainCreate --
 *
 *      Creates a new linked list (chain) structure and initializes
 *      its pointers;
 *
 * Results:
 *      Returns a pointer to the newly created chain structure.
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
Rbc_Chain *
Rbc_ChainCreate()
{
    Rbc_Chain *chainPtr;

    chainPtr = (Rbc_Chain *) ckalloc(sizeof(Rbc_Chain));
    if (chainPtr != NULL) {
        Rbc_ChainInit(chainPtr);
    }
    return chainPtr;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ChainInit --
 *
 *      Initializes a linked list.
 *
 * Results:
 *      None.
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_ChainInit(chainPtr)
    Rbc_Chain *chainPtr; /* The chain to initialize */
{
    chainPtr->nLinks = 0;
    chainPtr->headPtr = chainPtr->tailPtr = NULL;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ChainLinkAfter --
 *
 *      Inserts an entry following a given entry.
 *
 * Results:
 *      None.
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_ChainLinkAfter(chainPtr, linkPtr, afterPtr)
    Rbc_Chain *chainPtr;
    Rbc_ChainLink *linkPtr, *afterPtr;
{
    if (chainPtr->headPtr == NULL) {
        chainPtr->tailPtr = chainPtr->headPtr = linkPtr;
    } else {
        if (afterPtr == NULL) {
            /* Prepend to the front of the chain */
            linkPtr->nextPtr = chainPtr->headPtr;
            linkPtr->prevPtr = NULL;
            chainPtr->headPtr->prevPtr = linkPtr;
            chainPtr->headPtr = linkPtr;
        } else {
            linkPtr->nextPtr = afterPtr->nextPtr;
            linkPtr->prevPtr = afterPtr;
            if (afterPtr == chainPtr->tailPtr) {
                chainPtr->tailPtr = linkPtr;
            } else {
                afterPtr->nextPtr->prevPtr = linkPtr;
            }
            afterPtr->nextPtr = linkPtr;
        }
    }
    chainPtr->nLinks++;
}

/*----------------------------------------------------------------------
 *
 * Rbc_ChainLinkBefore --
 *
 *      Inserts a link preceding a given link.
 *
 * Results:
 *      None.
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_ChainLinkBefore(chainPtr, linkPtr, beforePtr)
    Rbc_Chain *chainPtr;    /* Chain to contain new entry */
    Rbc_ChainLink *linkPtr;    /* New entry to be inserted */
    Rbc_ChainLink *beforePtr;    /* Entry to link before */
{
    if (chainPtr->headPtr == NULL) {
        chainPtr->tailPtr = chainPtr->headPtr = linkPtr;
    } else {
        if (beforePtr == NULL) {
            /* Append to the end of the chain. */
            linkPtr->nextPtr = NULL;
            linkPtr->prevPtr = chainPtr->tailPtr;
            chainPtr->tailPtr->nextPtr = linkPtr;
            chainPtr->tailPtr = linkPtr;
        } else {
            linkPtr->prevPtr = beforePtr->prevPtr;
            linkPtr->nextPtr = beforePtr;
            if (beforePtr == chainPtr->headPtr) {
                chainPtr->headPtr = linkPtr;
            } else {
                beforePtr->prevPtr->nextPtr = linkPtr;
            }
            beforePtr->prevPtr = linkPtr;
        }
    }
    chainPtr->nLinks++;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ChainNewLink --
 *
 *      Creates a new link.
 *
 * Results:
 *      The return value is the pointer to the newly created link.
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
Rbc_ChainLink *
Rbc_ChainNewLink()
{
    Rbc_ChainLink *linkPtr;

    linkPtr = (Rbc_ChainLink *)ckalloc(sizeof(Rbc_ChainLink));
    assert(linkPtr);
    linkPtr->clientData = NULL;
    linkPtr->nextPtr = linkPtr->prevPtr = NULL;
    return linkPtr;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ChainReset --
 *
 *      Removes all the links from the chain, freeing the memory for
 *      each link.  Memory pointed to by the link (clientData) is not
 *      freed.  It's the caller's responsibility to deallocate it.
 *
 * Results:
 *      None.
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_ChainReset(chainPtr)
    Rbc_Chain *chainPtr;/* Chain to clear */
{
    if (chainPtr != NULL) {
        Rbc_ChainLink *oldPtr;
        Rbc_ChainLink *linkPtr = chainPtr->headPtr;

        while (linkPtr != NULL) {
            oldPtr = linkPtr;
            linkPtr = linkPtr->nextPtr;
            ckfree((char *) oldPtr);
        }
        Rbc_ChainInit(chainPtr);
    }
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ChainDestroy
 *
 *      Frees all the nodes from the chain and deallocates the memory
 *      allocated for the chain structure itself.  It's assumed that
 *      the chain was previous allocated by Rbc_ChainCreate.
 *
 * Results:
 *      None.
 *
 * Side effects:
 *      None.
 *
 *----------------------------------------------------------------------
 */
void
Rbc_ChainDestroy(chainPtr)
    Rbc_Chain *chainPtr; /* The chain to destroy. */
{
    if (chainPtr != NULL) {
        Rbc_ChainReset(chainPtr);
        ckfree((char *) chainPtr);
    }
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ChainUnlinkLink --
 *
 *      Unlinks a link from the chain. The link is not deallocated,
 *      but only removed from the chain.
 *
 * Results:
 *      None.
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_ChainUnlinkLink(chainPtr, linkPtr)
    Rbc_Chain *chainPtr;
    Rbc_ChainLink *linkPtr;
{
    /* Indicates if the link is actually removed from the chain. */
    int unlinked;

    unlinked = FALSE;
    if (chainPtr->headPtr == linkPtr) {
        chainPtr->headPtr = linkPtr->nextPtr;
        unlinked = TRUE;
    }
    if (chainPtr->tailPtr == linkPtr) {
        chainPtr->tailPtr = linkPtr->prevPtr;
        unlinked = TRUE;
    }
    if (linkPtr->nextPtr != NULL) {
        linkPtr->nextPtr->prevPtr = linkPtr->prevPtr;
        unlinked = TRUE;
    }
    if (linkPtr->prevPtr != NULL) {
        linkPtr->prevPtr->nextPtr = linkPtr->nextPtr;
        unlinked = TRUE;
    }
    if (unlinked) {
        chainPtr->nLinks--;
    }
    linkPtr->prevPtr = linkPtr->nextPtr = NULL;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ChainDeleteLink --
 *
 *      Unlinks and also frees the given link.
 *
 * Results:
 *      None.
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
void
Rbc_ChainDeleteLink(chainPtr, linkPtr)
    Rbc_Chain *chainPtr;
    Rbc_ChainLink *linkPtr;
{
    Rbc_ChainUnlinkLink(chainPtr, linkPtr);
    ckfree((char *)linkPtr);
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ChainAppend --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
Rbc_ChainLink *
Rbc_ChainAppend(chainPtr, clientData)
    Rbc_Chain *chainPtr;
    ClientData clientData;
{
    Rbc_ChainLink *linkPtr;

    linkPtr = Rbc_ChainNewLink();
    Rbc_ChainLinkBefore(chainPtr, linkPtr, (Rbc_ChainLink *)NULL);
    Rbc_ChainSetValue(linkPtr, clientData);
    return linkPtr;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ChainPrepend --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
Rbc_ChainLink *
Rbc_ChainPrepend(chainPtr, clientData)
    Rbc_Chain *chainPtr;
    ClientData clientData;
{
    Rbc_ChainLink *linkPtr;

    linkPtr = Rbc_ChainNewLink();
    Rbc_ChainLinkAfter(chainPtr, linkPtr, (Rbc_ChainLink *)NULL);
    Rbc_ChainSetValue(linkPtr, clientData);
    return linkPtr;
}

/*
 *----------------------------------------------------------------------
 *
 * Rbc_ChainAllocLink --
 *
 *      Creates a new chain link.  Unlink Rbc_ChainNewLink, this
 *      routine also allocates extra memory in the node for data.
 *
 * Results:
 *      The return value is the pointer to the newly created entry.
 *
 * Side Effects:
 *      TODO: Side Effects
 *
 *----------------------------------------------------------------------
 */
Rbc_ChainLink *
Rbc_ChainAllocLink(extraSize)
    unsigned int extraSize;
{
    Rbc_ChainLink *linkPtr;
    unsigned int linkSize;

    linkSize = ALIGN(sizeof(Rbc_ChainLink));
    linkPtr = RbcCalloc(1, linkSize + extraSize);
    assert(linkPtr);
    if (extraSize > 0) {
        /* Point clientData at the memory beyond the normal structure. */
        linkPtr->clientData = (ClientData)((char *)linkPtr + linkSize);
    }
    return linkPtr;
}
