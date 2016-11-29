/*
 * rbcBind.h --
 *
 *      TODO: Abstract
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#ifndef _RBCBIND
#define _RBCBIND

#include "rbcList.h"

typedef struct Rbc_BindTableStruct *Rbc_BindTable;
typedef ClientData (Rbc_BindPickProc) _ANSI_ARGS_((ClientData clientData, int x, int y, ClientData *contextPtr));
typedef void (Rbc_BindTagProc) _ANSI_ARGS_((Rbc_BindTable bindTable, ClientData object, ClientData context, Rbc_List list));

/*
 *  Binding structure information:
 */

typedef struct Rbc_BindTableStruct {
    unsigned int flags;
    Tk_BindingTable bindingTable; /* Table of all bindings currently defined.
                                   * NULL means that no bindings exist, so the
                                   * table hasn't been created.  Each "object"
                                   * used for this table is either a Tk_Uid for
                                   * a tag or the address of an item named by
                                   * id. */
    ClientData currentItem; /* The item currently containing the mouse
                             * pointer, or NULL if none. */
    ClientData currentContext; /* One word indicating what kind of object
                                * was picked. */
    ClientData newItem; /* The item that is about to become the
                         * current one, or NULL.  This field is
                         * used to detect deletions of the new
                         * current item pointer that occur during
                         * Leave processing of the previous current
                         * tab.  */
    ClientData newContext; /* One-word indicating what kind of object
                            * was just picked. */
    ClientData focusItem;
    ClientData focusContext;
    XEvent pickEvent; /* The event upon which the current choice
                       * of the current tab is based.  Must be saved
                       * so that if the current item is deleted,
                       * we can pick another. */
    int activePick; /* The pick event has been initialized so
                     * that we can repick it */
    int state; /* Last known modifier state.  Used to
                * defer picking a new current object
                * while buttons are down. */
    ClientData clientData;
    Tk_Window tkwin;
    Rbc_BindPickProc *pickProc; /* Routine to report the item the mouse is
                                 * currently over. */
    Rbc_BindTagProc *tagProc; /* Routine to report tags picked items. */
} Rbc_BindTableStruct;

void Rbc_DestroyBindingTable _ANSI_ARGS_((Rbc_BindTable table));
Rbc_BindTable Rbc_CreateBindingTable _ANSI_ARGS_((Tcl_Interp *interp, Tk_Window tkwin, ClientData clientData, Rbc_BindPickProc *pickProc, Rbc_BindTagProc *tagProc));
int Rbc_ConfigureBindings _ANSI_ARGS_((Tcl_Interp *interp, Rbc_BindTable table, ClientData item, int argc, char **argv));
int Rbc_ConfigureBindingsFromObj _ANSI_ARGS_((Tcl_Interp *interp, Rbc_BindTable table, ClientData item, int objc, Tcl_Obj *CONST *objv));
void Rbc_PickCurrentItem _ANSI_ARGS_((Rbc_BindTable table));
void Rbc_DeleteBindings _ANSI_ARGS_((Rbc_BindTable table, ClientData object));
void Rbc_MoveBindingTable _ANSI_ARGS_((Rbc_BindTable table, Tk_Window tkwin));

#define Rbc_SetFocusItem(bindPtr, object, context) \
    ((bindPtr)->focusItem = (ClientData)(object),\
    (bindPtr)->focusContext = (ClientData)(context))

#define Rbc_SetCurrentItem(bindPtr, object, context) \
    ((bindPtr)->currentItem = (ClientData)(object),\
    (bindPtr)->currentContext = (ClientData)(context))

#define Rbc_GetCurrentItem(bindPtr)  ((bindPtr)->currentItem)
#define Rbc_GetCurrentContext(bindPtr)  ((bindPtr)->currentContext)
#define Rbc_GetLatestItem(bindPtr)  ((bindPtr)->newItem)

#define Rbc_GetBindingData(bindPtr)  ((bindPtr)->clientData)

#endif /* _RBCBIND */
