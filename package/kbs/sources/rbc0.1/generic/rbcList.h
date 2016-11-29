/*
 * rbcList.h --
 *
 *      TODO: Description
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */
#ifndef _RBCLIST
#define _RBCLIST

typedef struct Rbc_ListStruct *Rbc_List;
typedef struct Rbc_ListNodeStruct *Rbc_ListNode;

/*
 * A Rbc_ListNode is the container structure for the Rbc_List.
 */
struct Rbc_ListNodeStruct {
    struct Rbc_ListNodeStruct *prevPtr; /* Link to the previous node */
    struct Rbc_ListNodeStruct *nextPtr; /* Link to the next node */
    ClientData clientData;	/* Pointer to the data object */
    struct Rbc_ListStruct *listPtr; /* List to eventually insert node */
    union {			/* Key has one of these forms: */
        const char *oneWordValue; /* One-word value for key. */
        int *words[1];		/* Multiple integer words for key.
				 * The actual size will be as large
				 * as necessary for this table's
				 * keys. */
        char string[4];		/* String for key.  The actual size
				 * will be as large as needed to hold
				 * the key. */
    } key;			/* MUST BE LAST FIELD IN RECORD!! */
};

typedef int (Rbc_ListCompareProc) _ANSI_ARGS_((Rbc_ListNode *node1Ptr, Rbc_ListNode *node2Ptr));

/*
 * A Rbc_List is a doubly chained list structure.
 */
struct Rbc_ListStruct {
    struct Rbc_ListNodeStruct *headPtr;	/* Pointer to first element in list */
    struct Rbc_ListNodeStruct *tailPtr;	/* Pointer to last element in list */
    int nNodes;			/* Number of node currently in the list. */
    int type;			/* Type of keys in list. */
};

void Rbc_ListInit _ANSI_ARGS_((Rbc_List list, int type));
void Rbc_ListReset _ANSI_ARGS_((Rbc_List list));
Rbc_List Rbc_ListCreate _ANSI_ARGS_((int type));
void Rbc_ListDestroy _ANSI_ARGS_((Rbc_List list));
Rbc_ListNode Rbc_ListCreateNode _ANSI_ARGS_((Rbc_List list,
        CONST char *key));
void Rbc_ListDeleteNode _ANSI_ARGS_((Rbc_ListNode node));

Rbc_ListNode Rbc_ListAppend _ANSI_ARGS_((Rbc_List list, CONST char *key,
                                        ClientData clientData));
Rbc_ListNode Rbc_ListPrepend _ANSI_ARGS_((Rbc_List list, CONST char *key,
        ClientData clientData));
void Rbc_ListLinkAfter _ANSI_ARGS_((Rbc_List list, Rbc_ListNode node,
                                    Rbc_ListNode afterNode));
void Rbc_ListLinkBefore _ANSI_ARGS_((Rbc_List list, Rbc_ListNode node,
                                     Rbc_ListNode beforeNode));
void Rbc_ListUnlinkNode _ANSI_ARGS_((Rbc_ListNode node));
Rbc_ListNode Rbc_ListGetNode _ANSI_ARGS_((Rbc_List list,
        CONST char *key));
void Rb_ListDeleteNodeByKey _ANSI_ARGS_((Rbc_List list,
        CONST char *key));
Rbc_ListNode Rbc_ListGetNthNode _ANSI_ARGS_((Rbc_List list,
        int position, int direction));
void Rbc_ListSort _ANSI_ARGS_((Rbc_List list, Rbc_ListCompareProc * proc));

#define Rbc_ListGetLength(list) \
	(((list) == NULL) ? 0 : ((struct Rbc_ListStruct *)list)->nNodes)
#define Rbc_ListFirstNode(list) \
	(((list) == NULL) ? NULL : ((struct Rbc_ListStruct *)list)->headPtr)
#define Rbc_ListLastNode(list)	\
	(((list) == NULL) ? NULL : ((struct Rbc_ListStruct *)list)->tailPtr)
#define Rbc_ListPrevNode(node)	((node)->prevPtr)
#define Rbc_ListNextNode(node) 	((node)->nextPtr)
#define Rbc_ListGetKey(node)	\
	(((node)->listPtr->type == TCL_STRING_KEYS) \
		 ? (node)->key.string : (node)->key.oneWordValue)
#define Rbc_ListGetValue(node)  	((node)->clientData)
#define Rbc_ListSetValue(node, value) \
	((node)->clientData = (ClientData)(value))
#define Rbc_ListAppendNode(list, node) \
	(Rbc_ListLinkBefore((list), (node), (Rbc_ListNode)NULL))
#define Rbc_ListPrependNode(list, node) \
	(Rbc_ListLinkAfter((list), (node), (Rbc_ListNode)NULL))

#endif /* _RBCLIST */
